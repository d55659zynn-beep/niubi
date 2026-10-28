import '../db/schemas/form_mapping.dart';
import '../db/schemas/resume_template.dart';

/// 填充配置构建器：把激活简历模板的值 + 网站的映射规则，
/// 合成为 JS 填充脚本需要的 [{selector, value, type}] 列表。
/// 空值的字段跳过（避免把已有内容清空）。
class FillConfigBuilder {
  FillConfigBuilder._();

  /// 一条填充项（selector 选择器 + 要填的值 + 控件类型）
  static Map<String, String> _item(FieldMapRule rule, String value) => {
        'selector': rule.cssSelector,
        'value': value,
        'type': rule.inputType,
      };

  /// 把实习经历列表合成一段纯文本（多行），便于表单填充
  static String _internshipText(List<ResumeExperience> list) => list
      .map((e) => [
            if (e.title.isNotEmpty) e.title,
            if (e.org.isNotEmpty) e.org,
            if (e.timeRange.isNotEmpty) e.timeRange,
            if (e.content.isNotEmpty) e.content,
          ].join(' · '))
      .join('\n');

  /// 构建填充项列表；简历字段不存在或为空时跳过该映射。
  static List<Map<String, String>> build(
    ResumeTemplate resume,
    List<FieldMapRule> rules,
  ) {
    // 简历字段键 → 实际值
    final values = <String, String>{
      ResumeFieldKeys.personName: resume.personName,
      ResumeFieldKeys.phone: resume.phone,
      ResumeFieldKeys.email: resume.email,
      ResumeFieldKeys.school: resume.school,
      ResumeFieldKeys.major: resume.major,
      ResumeFieldKeys.education: resume.education,
      ResumeFieldKeys.skills: resume.skills,
      ResumeFieldKeys.internships: _internshipText(resume.internships),
      ResumeFieldKeys.projects: _internshipText(resume.projects),
    };
    // 自定义字段：custom:字段名
    for (final f in resume.customFields) {
      values['custom:${f.key}'] = f.value;
    }

    final items = <Map<String, String>>[];
    for (final rule in rules) {
      final value = values[rule.resumeFieldKey];
      if (value == null || value.isEmpty) continue; // 空值不覆盖网页已有内容
      items.add(_item(rule, value));
    }
    return items;
  }
}