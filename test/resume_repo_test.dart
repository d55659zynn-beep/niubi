import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/isar_service.dart';
import 'package:wangshen_app/db/resume_repo.dart';
import 'package:wangshen_app/db/schemas/resume_template.dart';

import 'isar_test_helper.dart';

/// ResumeRepo 数据层测试：使用临时目录的真实 Isar 实例，
/// 验证多模板的新建、保存（含经历/自定义字段）、激活切换、删除逻辑。
void main() {
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('ws_resume_test');
    loadIsarNativeLib(); // 先加载原生库，再打开数据库
    await IsarService.instance.init(directoryOverride: tmpDir.path);
  });

  tearDownAll(() async {
    await IsarService.instance.isar.close();
    tmpDir.deleteSync(recursive: true);
  });

  test('新建模板：默认未激活，出现在列表里', () async {
    final tpl = await ResumeRepo.instance.create('测试模板');
    expect(tpl.templateName, '测试模板');
    expect(tpl.isActive, isFalse);

    final all = await ResumeRepo.instance.getAll();
    expect(all.any((t) => t.templateName == '测试模板'), isTrue);
  });

  test('保存模板：全部字段（含经历/自定义字段/PDF）可完整读回', () async {
    final tpl = await ResumeRepo.instance.create('后端通用版');
    tpl.personName = '张三';
    tpl.phone = '13800138000';
    tpl.email = 'zhangsan@example.com';
    tpl.school = '示例大学';
    tpl.major = '计算机科学与技术';
    tpl.education = '本科';
    tpl.skills = 'Java、Spring、MySQL';
    tpl.internships = [
      ResumeExperience()
        ..title = '后端开发实习生'
        ..org = '示例科技'
        ..timeRange = '2025.06-2025.09'
        ..content = '参与接口开发',
    ];
    tpl.projects = [
      ResumeExperience()
        ..title = '选课系统'
        ..org = '课程项目'
        ..timeRange = '2025.03'
        ..content = 'Spring Boot 后端',
    ];
    tpl.customFields = [
      CustomField()
        ..key = '毕业时间'
        ..value = '2026.06',
    ];
    tpl.pdfLocalPath = '/tmp/resume.pdf';
    await ResumeRepo.instance.save(tpl);

    final saved = (await ResumeRepo.instance.getAll())
        .firstWhere((t) => t.templateName == '后端通用版');
    expect(saved.personName, '张三');
    expect(saved.phone, '13800138000');
    expect(saved.email, 'zhangsan@example.com');
    expect(saved.school, '示例大学');
    expect(saved.major, '计算机科学与技术');
    expect(saved.education, '本科');
    expect(saved.skills, 'Java、Spring、MySQL');
    expect(saved.internships.length, 1);
    expect(saved.internships.first.title, '后端开发实习生');
    expect(saved.internships.first.org, '示例科技');
    expect(saved.projects.single.content, 'Spring Boot 后端');
    expect(saved.customFields.single.key, '毕业时间');
    expect(saved.customFields.single.value, '2026.06');
    expect(saved.pdfLocalPath, '/tmp/resume.pdf');
  });

  test('激活切换：任意时刻只有一套激活模板', () async {
    final all = await ResumeRepo.instance.getAll();
    expect(all.length, greaterThanOrEqualTo(2), reason: '需要至少两套模板');
    final t1 = all[0];
    final t2 = all[1];

    await ResumeRepo.instance.setActive(t1);
    var now = await ResumeRepo.instance.getAll();
    expect(now.where((t) => t.isActive).length, 1);
    expect(now.firstWhere((t) => t.isActive).id, t1.id);
    expect((await ResumeRepo.instance.getActive())!.id, t1.id);

    await ResumeRepo.instance.setActive(t2);
    now = await ResumeRepo.instance.getAll();
    expect(now.where((t) => t.isActive).length, 1);
    expect(now.firstWhere((t) => t.isActive).id, t2.id);
  });

  test('删除激活模板：自动激活剩余模板', () async {
    final active = (await ResumeRepo.instance.getActive())!;
    final before = await ResumeRepo.instance.getAll();
    expect(before.length, greaterThan(1));

    await ResumeRepo.instance.delete(active);
    final after = await ResumeRepo.instance.getAll();
    expect(after.length, before.length - 1);
    // 删除后仍有且仅有一个激活模板
    expect(after.where((t) => t.isActive).length, 1);
  });

  test('列表按更新时间倒序返回', () async {
    final list = await ResumeRepo.instance.getAll();
    for (var i = 0; i < list.length - 1; i++) {
      final a = list[i].updatedAt;
      final b = list[i + 1].updatedAt;
      expect(
        a.isAfter(b) || a.isAtSameMomentAs(b),
        isTrue,
        reason: '第 $i 项应不早于第 ${i + 1} 项',
      );
    }
  });
}