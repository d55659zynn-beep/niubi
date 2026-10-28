import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/app_setting_repo.dart';
import 'package:wangshen_app/db/isar_service.dart';

import 'isar_test_helper.dart';

/// 应用设置数据层测试：推送开关、BOSS直聘 Cookie 本地持久化。
void main() {
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('ws_setting_test');
    loadIsarNativeLib();
    await IsarService.instance.init(directoryOverride: tmpDir.path);
  });

  tearDownAll(() async {
    await IsarService.instance.isar.close();
    tmpDir.deleteSync(recursive: true);
  });

  test('默认设置：推送关闭、Cookie 为空', () async {
    final setting = await AppSettingRepo.instance.get();
    expect(setting.pushEnabled, isFalse);
    expect(setting.bossCookie, isEmpty);
    expect(setting.bossCookieUpdatedAt, isNull);
  });

  test('开启推送开关后读取保持一致', () async {
    await AppSettingRepo.instance.setPushEnabled(true);
    final setting = await AppSettingRepo.instance.get();
    expect(setting.pushEnabled, isTrue);
  });

  test('保存 BOSS Cookie 后读取一致', () async {
    await AppSettingRepo.instance.setBossCookie('__zp_stoken__=abc;');
    final setting = await AppSettingRepo.instance.get();
    expect(setting.bossCookie, '__zp_stoken__=abc;');
    expect(setting.bossCookieUpdatedAt, isNotNull);
  });

  test('清除 BOSS Cookie', () async {
    await AppSettingRepo.instance.setBossCookie('  ');
    final setting = await AppSettingRepo.instance.get();
    expect(setting.bossCookie, isEmpty);
    expect(setting.bossCookieUpdatedAt, isNull);
  });
}