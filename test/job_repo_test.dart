import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/isar_service.dart';
import 'package:wangshen_app/db/job_repo.dart';
import 'package:wangshen_app/db/schemas/job_posting.dart';
import 'package:wangshen_app/services/job_scraper.dart';

import 'isar_test_helper.dart';

/// JobRepo 数据层测试：使用临时目录的真实 Isar 实例，
/// 验证 JSON 导入去重、筛选、收藏逻辑，以及网页抓取结果入库。
void main() {
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('ws_job_test');
    loadIsarNativeLib(); // 先加载原生库，再打开数据库
    await IsarService.instance.init(directoryOverride: tmpDir.path);
  });

  tearDownAll(() async {
    await IsarService.instance.isar.close();
    tmpDir.deleteSync(recursive: true);
  });

  /// 构造一条网页抓取岗位（Id 由标题+公司 sha256 生成）
  JobPosting scrapedJob({
    required String title,
    required String company,
    String city = '北京',
  }) {
    final hash = JobScraper.stableHash(title, company);
    final id = JobScraper.stableIdFromHash(hash);
    return JobPosting()
      ..id = id
      ..uniqueKey = 'web:$hash'
      ..source = 'web'
      ..externalId = hash
      ..company = company
      ..title = title
      ..city = city
      ..direction = '后端'
      ..deadline = null
      ..description = ''
      ..applyUrl = 'https://example.com/apply'
      ..isFavorite = false
      ..reminderEnabled = false
      ..importedAt = DateTime.now();
  }

  /// 模拟爬虫导出的 JSON 文件内容
  File writeJobsJson(String content) {
    final f = File('${tmpDir.path}/jobs.json');
    f.writeAsStringSync(content);
    return f;
  }

  String sampleJson() => '''
{
  "source": "demo",
  "exportedAt": "2026-10-28T12:00:00",
  "jobs": [
    {
      "id": "d-001",
      "company": "A公司",
      "title": "后端开发实习生",
      "city": "北京",
      "direction": "后端",
      "deadline": "2026-11-30",
      "description": "后端实习",
      "applyUrl": "https://a.example.com/apply/1"
    },
    {
      "id": "d-002",
      "company": "B公司",
      "title": "前端开发实习生",
      "city": "上海",
      "direction": "前端",
      "deadline": "2026-12-10",
      "description": "前端实习",
      "applyUrl": "https://b.example.com/apply/2"
    },
    {
      "id": "d-003",
      "company": "C公司",
      "title": "算法实习生",
      "city": "北京",
      "direction": "算法",
      "description": "无截止日期",
      "applyUrl": "https://c.example.com/apply/3"
    }
  ]
}
''';

  test('导入 JSON：新增 3 条，字段完整', () async {
    final f = writeJobsJson(sampleJson());
    final result = await JobRepo.instance.importJsonFile(f.path);
    expect(result.added, 3);
    expect(result.updated, 0);

    final all = await JobRepo.instance.query();
    expect(all.length, 3);
    final job = all.firstWhere((j) => j.externalId == 'd-001');
    expect(job.company, 'A公司');
    expect(job.city, '北京');
    expect(job.direction, '后端');
    expect(job.deadline, '2026-11-30');
    expect(job.applyUrl, 'https://a.example.com/apply/1');
    expect(job.isFavorite, isFalse);
  });

  test('再次导入相同 JSON：不重复新增（按 source+id 去重更新）', () async {
    final f = writeJobsJson(sampleJson());
    final result = await JobRepo.instance.importJsonFile(f.path);
    expect(result.added, 0);
    expect(result.updated, 3);
    final all = await JobRepo.instance.query();
    expect(all.length, 3);
  });

  test('筛选：城市/方向/截止时间', () async {
    // 城市筛选
    var list = await JobRepo.instance.query(city: '北京');
    expect(list.length, 2);

    // 方向筛选
    list = await JobRepo.instance.query(direction: '前端');
    expect(list.length, 1);
    expect(list.first.externalId, 'd-002');

    // 未截止：含无截止日期的岗位
    list = await JobRepo.instance.query(deadline: DeadlineFilter.open);
    expect(list.length, 3);

    // 已过期：构造一条过期数据再验证
    final expired = writeJobsJson('''
{
  "source": "demo",
  "jobs": [
    {
      "id": "d-old",
      "company": "旧公司",
      "title": "过期实习",
      "city": "广州",
      "direction": "测试",
      "deadline": "2020-01-01",
      "description": "",
      "applyUrl": "https://old.example.com/apply/1"
    }
  ]
}
''');
    await JobRepo.instance.importJsonFile(expired.path);
    list = await JobRepo.instance.query(deadline: DeadlineFilter.expired);
    expect(list.length, 1);
    expect(list.first.externalId, 'd-old');

    // 7 天内截止：当前测试数据无此类，应为空
    list = await JobRepo.instance.query(deadline: DeadlineFilter.withinWeek);
    expect(list, isEmpty);
  });

  test('收藏切换与收藏筛选', () async {
    final all = await JobRepo.instance.query();
    final target = all.firstWhere((j) => j.externalId == 'd-001');
    await JobRepo.instance.toggleFavorite(target);

    final fav = await JobRepo.instance.query(isFavorite: true);
    expect(fav.length, 1);
    expect(fav.first.externalId, 'd-001');

    // 取消收藏
    await JobRepo.instance.toggleFavorite(target);
    final fav2 = await JobRepo.instance.query(isFavorite: true);
    expect(fav2.length, 0);
  });

  test('重新导入：收藏与提醒状态保持', () async {
    final f = writeJobsJson('''
{
  "source": "state",
  "jobs": [
    {
      "id": "s-1",
      "company": "状态公司",
      "title": "状态测试岗",
      "city": "北京",
      "direction": "后端",
      "deadline": "2026-12-31",
      "description": "",
      "applyUrl": "https://s.example.com/1"
    }
  ]
}
''');
    await JobRepo.instance.importJsonFile(f.path);

    // 设置收藏 + 提醒状态
    var job = (await JobRepo.instance.query())
        .firstWhere((j) => j.externalId == 's-1');
    await JobRepo.instance.toggleFavorite(job);
    job = (await JobRepo.instance.query())
        .firstWhere((j) => j.externalId == 's-1');
    job.reminderEnabled = true;
    await JobRepo.instance.save(job);

    // 再次导入相同内容（截止日期未变）
    final result = await JobRepo.instance.importJsonFile(f.path);
    expect(result.updated, 1);
    expect(result.reminderResetIds, isEmpty);

    final re = (await JobRepo.instance.query())
        .firstWhere((j) => j.externalId == 's-1');
    expect(re.isFavorite, isTrue, reason: '重新导入不应重置收藏');
    expect(re.reminderEnabled, isTrue, reason: '截止日期未变时提醒应保持');
  });

  test('重新导入：截止日期变化时提醒重置并返回岗位 id', () async {
    // 前置：确保该岗位已开启提醒
    var job = (await JobRepo.instance.query())
        .firstWhere((j) => j.externalId == 's-1');
    if (!job.reminderEnabled) {
      job.reminderEnabled = true;
      await JobRepo.instance.save(job);
    }

    // 同 source+id，但截止日期改为更早的日期
    final f = writeJobsJson('''
{
  "source": "state",
  "jobs": [
    {
      "id": "s-1",
      "company": "状态公司",
      "title": "状态测试岗",
      "city": "北京",
      "direction": "后端",
      "deadline": "2026-11-15",
      "description": "截止日期已更新",
      "applyUrl": "https://s.example.com/1"
    }
  ]
}
''');
    final result = await JobRepo.instance.importJsonFile(f.path);
    expect(result.reminderResetIds.length, 1);

    job = (await JobRepo.instance.query())
        .firstWhere((j) => j.externalId == 's-1');
    expect(job.deadline, '2026-11-15');
    expect(job.reminderEnabled, isFalse, reason: '截止日期变化后旧提醒应重置');
  });

  test('saveScraped：抓取岗位写入 Isar，相同岗位不重复新增', () async {
    // 第一次抓取写入
    final saved = await JobRepo.instance
        .saveScraped([scrapedJob(title: '网页后端实习生', company: '网页科技')]);
    expect(saved, 1);
    var matched = (await JobRepo.instance.query())
        .where((j) => j.title == '网页后端实习生')
        .toList();
    expect(matched.length, 1);
    expect(matched.single.source, 'web');

    // 再次抓取到相同岗位（城市变化）：稳定 Id 相同 → 覆盖更新
    await JobRepo.instance.saveScraped(
      [scrapedJob(title: '网页后端实习生', company: '网页科技', city: '上海')],
    );
    matched = (await JobRepo.instance.query())
        .where((j) => j.title == '网页后端实习生')
        .toList();
    expect(matched.length, 1, reason: '相同岗位不应重复新增');
    expect(matched.single.city, '上海', reason: '抓取内容应被更新');
  });

  test('saveScraped：保留已有岗位的收藏与提醒状态', () async {
    await JobRepo.instance.saveScraped(
      [scrapedJob(title: '网页算法实习生', company: '网页智能')],
    );

    // 设置收藏 + 提醒
    var stored = (await JobRepo.instance.query())
        .firstWhere((j) => j.title == '网页算法实习生');
    await JobRepo.instance.toggleFavorite(stored);
    stored = (await JobRepo.instance.query())
        .firstWhere((j) => j.title == '网页算法实习生');
    stored.reminderEnabled = true;
    await JobRepo.instance.save(stored);

    // 模拟再次抓取到同一岗位
    await JobRepo.instance.saveScraped(
      [scrapedJob(title: '网页算法实习生', company: '网页智能')],
    );

    final after = (await JobRepo.instance.query())
        .firstWhere((j) => j.title == '网页算法实习生');
    expect(after.isFavorite, isTrue, reason: '重新抓取不应重置收藏');
    expect(after.reminderEnabled, isTrue, reason: '重新抓取不应重置提醒');
  });
}