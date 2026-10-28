import 'package:isar_community/isar.dart';

part 'resume_template.g.dart';

/// 简历模板（多套，仅本机存储，不上传）
@collection
class ResumeTemplate {
  Id id = Isar.autoIncrement;

  /// 模板名称，用于切换
  late String templateName;

  /// 当前激活的模板（同时只应有一套为 true）
  @Index()
  late bool isActive;

  late String personName;
  late String phone;
  late String email;
  late String school;
  late String major;

  /// 学历，如 本科 / 硕士
  late String education;

  late List<ResumeExperience> internships;
  late List<ResumeExperience> projects;

  /// 技能纯文本，便于表单填充
  late String skills;

  late List<CustomField> customFields;

  /// 本机 PDF 路径，可空
  String? pdfLocalPath;

  late DateTime updatedAt;
}

/// 实习/项目经历
@embedded
class ResumeExperience {
  late String title;
  late String org;
  late String timeRange;
  late String content;
}

/// 用户自定义字段
@embedded
class CustomField {
  late String key;
  late String value;
}

/// 映射配置使用的稳定字段键（网页填充时按这些 key 取值）
class ResumeFieldKeys {
  static const personName = 'personName';
  static const phone = 'phone';
  static const email = 'email';
  static const school = 'school';
  static const major = 'major';
  static const education = 'education';
  static const skills = 'skills';
  static const internships = 'internships';
  static const projects = 'projects';

  static const labels = <String, String>{
    personName: '姓名',
    phone: '电话',
    email: '邮箱',
    school: '学校',
    major: '专业',
    education: '学历',
    skills: '技能',
    internships: '实习经历',
    projects: '项目经历',
  };
}
