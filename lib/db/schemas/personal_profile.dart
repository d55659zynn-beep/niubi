import 'package:isar_community/isar.dart';

part 'personal_profile.g.dart';

/// 个人网申信息（单条记录，仅保存在本机 Isar，绝不上传服务器）。
/// 用于网申自动填表：进入投递页后由 JS 注入自动填充表单。
@collection
class PersonalProfile {
  /// 固定使用 1，保证全局只有一份个人信息
  Id id = 1;

  /// 姓名
  late String name;

  /// 手机号
  late String phone;

  /// 邮箱
  late String email;

  /// 学校
  late String school;

  /// 专业
  late String major;

  /// 年级（如：大二 / 2027 届）
  late String grade;

  /// 学历（本科 / 硕士）
  late String education;

  /// 意向城市（多个可用顿号分隔）
  late String intendedCity;

  /// 可到岗时间（如：随时到岗 / 2026年7月）
  late String availableTime;

  /// 本机 PDF 简历路径（可空）
  String? resumePdfPath;

  /// 更新时间
  late DateTime updatedAt;
}