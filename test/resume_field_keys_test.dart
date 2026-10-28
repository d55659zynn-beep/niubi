import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/schemas/resume_template.dart';

/// 简历字段键测试：映射绑定弹窗依赖这些稳定键与中文标签，
/// 确保字段键、标签一一对应且与简历表单字段一致。
void main() {
  test('ResumeFieldKeys.labels 覆盖全部 9 个标准字段', () {
    const expectedKeys = [
      ResumeFieldKeys.personName,
      ResumeFieldKeys.phone,
      ResumeFieldKeys.email,
      ResumeFieldKeys.school,
      ResumeFieldKeys.major,
      ResumeFieldKeys.education,
      ResumeFieldKeys.skills,
      ResumeFieldKeys.internships,
      ResumeFieldKeys.projects,
    ];

    expect(ResumeFieldKeys.labels.length, expectedKeys.length);
    for (final key in expectedKeys) {
      expect(
        ResumeFieldKeys.labels.containsKey(key),
        isTrue,
        reason: '缺少字段键 $key 的中文标签',
      );
      expect(ResumeFieldKeys.labels[key]!.trim(), isNotEmpty);
    }
  });

  test('labels 没有多余或重复的字段键', () {
    final values = ResumeFieldKeys.labels.values.toSet();
    expect(values.length, ResumeFieldKeys.labels.length, reason: '中文标签不应重复');
  });
}