import 'package:isar_community/isar.dart';

part 'app_setting.g.dart';

/// 应用设置（单条记录，id 固定为 1）。
/// 推送开关、BOSS直聘登录 Cookie 等均仅存本机 Isar，不上传外部服务器。
@collection
class AppSetting {
  /// 固定使用 1，全局只有一份设置
  Id id = 1;

  /// 岗位更新推送提醒开关
  late bool pushEnabled;

  /// BOSS直聘登录 Cookie（用户手动导入，仅本机保存）
  late String bossCookie;

  /// Cookie 导入时间（用于提示过期）
  DateTime? bossCookieUpdatedAt;

  /// 最后更新时间
  late DateTime updatedAt;
}