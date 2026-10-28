import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/isar_service.dart';
import 'package:wangshen_app/db/personal_profile_repo.dart';
import 'package:wangshen_app/db/schemas/personal_profile.dart';

import 'isar_test_helper.dart';

/// 个人信息数据层测试：本地 Isar 单条记录的保存 / 读取 / 覆盖。
void main() {
  late Directory tmpDir;

  setUpAll(() async {
    tmpDir = Directory.systemTemp.createTempSync('ws_profile_test');
    loadIsarNativeLib();
    await IsarService.instance.init(directoryOverride: tmpDir.path);
  });

  tearDownAll(() async {
    await IsarService.instance.isar.close();
    tmpDir.deleteSync(recursive: true);
  });

  test('未保存时返回 null', () async {
    expect(await PersonalProfileRepo.instance.get(), isNull);
  });

  test('保存后字段可完整读取', () async {
    final profile = PersonalProfileRepo.empty()
      ..name = '张三'
      ..phone = '13800138000'
      ..email = 'zhangsan@example.com'
      ..school = '示例大学'
      ..major = '物流管理'
      ..grade = '大二'
      ..education = '本科'
      ..intendedCity = '成都、武汉'
      ..availableTime = '随时到岗'
      ..resumePdfPath = '/tmp/resume.pdf';
    await PersonalProfileRepo.instance.save(profile);

    final saved = await PersonalProfileRepo.instance.get();
    expect(saved, isNotNull);
    expect(saved!.id, 1, reason: '固定单条记录');
    expect(saved.name, '张三');
    expect(saved.phone, '13800138000');
    expect(saved.email, 'zhangsan@example.com');
    expect(saved.school, '示例大学');
    expect(saved.major, '物流管理');
    expect(saved.grade, '大二');
    expect(saved.education, '本科');
    expect(saved.intendedCity, '成都、武汉');
    expect(saved.availableTime, '随时到岗');
    expect(saved.resumePdfPath, '/tmp/resume.pdf');
    expect(saved.updatedAt, isNotNull);
  });

  test('再次保存为覆盖更新，不会产生多条记录', () async {
    final saved = (await PersonalProfileRepo.instance.get())!;
    saved
      ..name = '李四'
      ..phone = '13900139000';
    await PersonalProfileRepo.instance.save(saved);

    final count =
        await IsarService.instance.isar.personalProfiles.count();
    expect(count, 1, reason: '个人信息只有一份');
    final re = await PersonalProfileRepo.instance.get();
    expect(re!.name, '李四');
  });
}