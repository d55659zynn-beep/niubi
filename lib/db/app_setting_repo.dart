import 'isar_service.dart';
import 'schemas/app_setting.dart';

/// 应用设置数据层（单条记录，id=1）：
/// 推送开关、BOSS直聘 Cookie。仅本机 Isar 存储，不上传外部服务器。
class AppSettingRepo {
  AppSettingRepo._();
  static final AppSettingRepo instance = AppSettingRepo._();

  /// 读取设置；首次访问自动创建默认设置（推送默认关闭）
  Future<AppSetting> get() async {
    final isar = IsarService.instance.isar;
    var setting = await isar.appSettings.get(1);
    if (setting == null) {
      setting = _defaultSetting();
      await isar.writeTxn(() async {
        await isar.appSettings.put(setting!);
      });
    }
    return setting;
  }

  static AppSetting _defaultSetting() => AppSetting()
    ..pushEnabled = false
    ..bossCookie = ''
    ..updatedAt = DateTime.now();

  /// 更新推送开关
  Future<void> setPushEnabled(bool enabled) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final setting = await isar.appSettings.get(1) ?? _defaultSetting();
      setting
        ..pushEnabled = enabled
        ..updatedAt = DateTime.now();
      await isar.appSettings.put(setting);
    });
  }

  /// 保存 BOSS直聘登录 Cookie（为空表示清除）
  Future<void> setBossCookie(String cookie) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final setting = await isar.appSettings.get(1) ?? _defaultSetting();
      setting
        ..bossCookie = cookie.trim()
        ..bossCookieUpdatedAt = cookie.trim().isEmpty ? null : DateTime.now()
        ..updatedAt = DateTime.now();
      await isar.appSettings.put(setting);
    });
  }
}