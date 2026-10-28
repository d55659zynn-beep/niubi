import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/schemas/job_posting.dart';
import 'package:wangshen_app/services/job_filter.dart';

/// 岗位本地过滤测试：实习生专区开关 + 关键词搜索（纯内存逻辑，不联网）。
void main() {
  JobPosting makeJob({
    required int id,
    required String title,
    String description = '',
    String city = '北京',
    String direction = '',
    String source = 'nowcoder',
  }) {
    return JobPosting()
      ..id = id
      ..uniqueKey = 'test:$id'
      ..source = source
      ..externalId = '$id'
      ..company = '测试公司'
      ..title = title
      ..city = city
      ..direction = direction
      ..deadline = null
      ..description = description
      ..applyUrl = 'https://example.com/$id'
      ..isFavorite = false
      ..reminderEnabled = false
      ..importedAt = DateTime.now();
  }

  final jobs = [
    makeJob(
      id: 1,
      title: '供应链管理实习生',
      description: '负责物流配送与供应链计划',
      direction: '物流/供应链',
    ),
    makeJob(
      id: 2,
      title: 'Java后端开发实习生',
      description: '负责后端接口开发与维护',
      direction: '后端',
    ),
    makeJob(
      id: 3,
      title: '运营专员',
      description: '负责活动策划与执行',
      direction: '运营',
    ),
    makeJob(
      id: 4,
      title: '采购助理 Intern',
      description: '供应商管理与询价',
      direction: '采购',
    ),
  ];

  group('实习生判断', () {
    test('标题含“实习”视为实习岗', () {
      expect(JobFilter.isInternship(jobs[0]), isTrue);
    });

    test('JD 含“实习”视为实习岗', () {
      final job = makeJob(id: 99, title: '数据分析员', description: '该岗位为实习岗');
      expect(JobFilter.isInternship(job), isTrue);
    });

    test('标题/JD 含 Intern 视为实习岗（忽略大小写）', () {
      expect(JobFilter.isInternship(jobs[3]), isTrue);
    });

    test('无实习字样视为全职岗', () {
      expect(JobFilter.isInternship(jobs[2]), isFalse);
    });
  });

  group('实习生专区开关过滤', () {
    test('开启后过滤全职岗位', () {
      final result = JobFilter.apply(jobs, internOnly: true);
      expect(result.length, 3);
      expect(result.map((j) => j.title), isNot(contains('运营专员')));
    });

    test('关闭时不过滤', () {
      expect(JobFilter.apply(jobs).length, jobs.length);
    });
  });

  group('关键词搜索（标题 + JD 全文）', () {
    test('匹配岗位标题', () {
      final result = JobFilter.apply(jobs, keyword: '供应链');
      expect(result.length, 1);
      expect(result.single.title, '供应链管理实习生');
    });

    test('匹配 JD 全文', () {
      final result = JobFilter.apply(jobs, keyword: '物流配送');
      expect(result.length, 1);
      expect(result.single.title, '供应链管理实习生');
    });

    test('关键词过滤结合实习生开关', () {
      final result = JobFilter.apply(
        jobs,
        internOnly: true,
        keyword: '采购',
      );
      expect(result.length, 1);
      expect(result.single.title, '采购助理 Intern');
    });

    test('无匹配时返回空列表', () {
      expect(JobFilter.apply(jobs, keyword: '不存在的岗位关键词'), isEmpty);
    });

    test('空关键词不过滤', () {
      expect(JobFilter.apply(jobs, keyword: '   ').length, jobs.length);
    });

    test('大小写不敏感', () {
      expect(JobFilter.apply(jobs, keyword: 'INTERN').length, 1);
    });
  });

  group('招聘平台多选筛选', () {
    final platformJobs = [
      makeJob(id: 11, title: '牛客供应链实习生', source: 'nowcoder'),
      makeJob(id: 12, title: '实习僧供应链实习生', source: 'shixiseng'),
      makeJob(id: 13, title: 'BOSS直聘物流实习生', source: 'boss'),
    ];

    test('单选平台过滤', () {
      final result = JobFilter.apply(platformJobs, sources: {'nowcoder'});
      expect(result.length, 1);
      expect(result.single.source, 'nowcoder');
    });

    test('多选平台过滤', () {
      final result = JobFilter.apply(
        platformJobs,
        sources: {'nowcoder', 'shixiseng'},
      );
      expect(result.length, 2);
      expect(result.map((j) => j.source).toSet(),
          {'nowcoder', 'shixiseng'});
    });

    test('空集合表示不限平台', () {
      expect(JobFilter.apply(platformJobs, sources: {}).length, 3);
      expect(JobFilter.apply(platformJobs).length, 3);
    });

    test('平台与关键词组合过滤', () {
      final result = JobFilter.apply(
        platformJobs,
        sources: {'shixiseng'},
        keyword: '供应链',
      );
      expect(result.length, 1);
      expect(result.single.title, '实习僧供应链实习生');
    });
  });
}