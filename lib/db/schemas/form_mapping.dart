import 'package:isar_community/isar.dart';

part 'form_mapping.g.dart';

/// 某个招聘网站的表单映射（每个 host 一套独立规则）
@collection
class FormMapping {
  Id id = Isar.autoIncrement;

  /// 网站主机名，如 campus.example.com
  @Index(unique: true, replace: true)
  late String host;

  late List<FieldMapRule> rules;

  late DateTime updatedAt;
}

/// 单个输入框与本地简历字段的绑定
@embedded
class FieldMapRule {
  /// CSS 选择器，由可视化点选生成
  late String cssSelector;

  /// 对应 [ResumeFieldKeys] 或 custom:键名
  late String resumeFieldKey;

  /// input / textarea / select，填充时按类型处理
  late String inputType;
}
