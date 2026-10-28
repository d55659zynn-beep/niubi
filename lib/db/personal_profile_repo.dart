import 'isar_service.dart';
import 'schemas/personal_profile.dart';

/// 个人网申信息数据层：单条记录（id 固定为 1），仅写本机 Isar。
class PersonalProfileRepo {
  PersonalProfileRepo._();
  static final PersonalProfileRepo instance = PersonalProfileRepo._();

  /// 读取已保存的个人信息；未填写过返回 null
  Future<PersonalProfile?> get() async {
    final isar = IsarService.instance.isar;
    return isar.personalProfiles.get(1);
  }

  /// 保存个人信息（固定 id=1，覆盖更新）
  Future<void> save(PersonalProfile profile) async {
    final isar = IsarService.instance.isar;
    profile
      ..id = 1
      ..updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.personalProfiles.put(profile);
    });
  }

  /// 构造空信息对象（Isar 的 late 字段必须显式初始化）
  static PersonalProfile empty() => PersonalProfile()
    ..name = ''
    ..phone = ''
    ..email = ''
    ..school = ''
    ..major = ''
    ..grade = ''
    ..education = ''
    ..intendedCity = ''
    ..availableTime = ''
    ..updatedAt = DateTime.now();
}