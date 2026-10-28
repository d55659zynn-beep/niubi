import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/schemas/form_mapping.dart';
import 'package:wangshen_app/db/schemas/resume_template.dart';
import 'package:wangshen_app/services/fill_config_builder.dart';

/// FillConfigBuilder 单元测试（纯 Dart，无需数据库）：
/// 验证简历值 → 网页填充配置的转换规则。
void main() {
  /// 构造一份测试简历（Isar 的 late 字段需要全部赋值）
  ResumeTemplate makeResume() => ResumeTemplate()
    ..templateName = '测试模板'
    ..isActive = true
    ..personName = '张三'
    ..phone = '13800138000'
    ..email = 'zhangsan@example.com'
    ..school = '示例大学'
    ..major = '计算机科学与技术'
    ..education = '本科'
    ..skills = 'Java、Spring'
    ..internships = [
      ResumeExperience()
        ..title = '后端开发实习生'
        ..org = '示例科技'
        ..timeRange = '2025.06-2025.09'
        ..content = '参与接口开发',
    ]
    ..projects = []
    ..customFields = [
      CustomField()
        ..key = '毕业时间'
        ..value = '2026.06',
    ]
    ..updatedAt = DateTime.now();

  /// 构造一条映射规则
  FieldMapRule rule(String selector, String key, [String type = 'input']) =>
      FieldMapRule()
        ..cssSelector = selector
        ..resumeFieldKey = key
        ..inputType = type;

  test('标准字段映射：选择器与值正确对应', () {
    final items = FillConfigBuilder.build(makeResume(), [
      rule('#name', ResumeFieldKeys.personName),
      rule('#phone', ResumeFieldKeys.phone),
      rule('textarea#skills', ResumeFieldKeys.skills, 'textarea'),
    ]);

    expect(items.length, 3);
    expect(items[0]['selector'], '#name');
    expect(items[0]['value'], '张三');
    expect(items[1]['value'], '13800138000');
    expect(items[2]['value'], 'Java、Spring');
    expect(items[2]['type'], 'textarea');
  });

  test('空值字段跳过（不覆盖网页已有内容）', () {
    final resume = makeResume()..major = '';
    final items = FillConfigBuilder.build(resume, [
      rule('#major', ResumeFieldKeys.major), // 空值 → 跳过
      rule('#name', ResumeFieldKeys.personName),
    ]);

    expect(items.length, 1);
    expect(items.single['selector'], '#name');
  });

  test('自定义字段与实习经历文本合成', () {
    final items = FillConfigBuilder.build(makeResume(), [
      rule('#grad-date', 'custom:毕业时间'),
      rule('textarea#internship', ResumeFieldKeys.internships, 'textarea'),
    ]);

    expect(items.length, 2);
    // 自定义字段按 custom:键名 取值
    expect(items[0]['value'], '2026.06');
    // 经历合成文本包含标题/单位/时间/内容
    final expText = items[1]['value']!;
    expect(expText, contains('后端开发实习生'));
    expect(expText, contains('示例科技'));
    expect(expText, contains('2025.06-2025.09'));
    expect(expText, contains('参与接口开发'));
  });

  test('无映射规则时返回空列表', () {
    expect(FillConfigBuilder.build(makeResume(), []), isEmpty);
  });

  test('简历中不存在的自定义字段被跳过', () {
    final items = FillConfigBuilder.build(makeResume(), [
      rule('#unknown', 'custom:不存在的字段'),
      rule('#name', ResumeFieldKeys.personName),
    ]);
    expect(items.length, 1);
  });
}