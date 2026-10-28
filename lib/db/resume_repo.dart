import 'package:isar_community/isar.dart';

import 'isar_service.dart';
import 'schemas/resume_template.dart';

/// 简历模板的数据访问层：查询 / 保存 / 删除 / 激活切换。
/// 所有数据只写本机 Isar，不涉及任何网络。
class ResumeRepo {
  ResumeRepo._();
  static final ResumeRepo instance = ResumeRepo._();

  /// 查询全部模板，最近更新的在前
  Future<List<ResumeTemplate>> getAll() async {
    final isar = IsarService.instance.isar;
    return isar.resumeTemplates.where().sortByUpdatedAtDesc().findAll();
  }

  /// 当前激活的模板（没有则为 null）
  Future<ResumeTemplate?> getActive() async {
    final isar = IsarService.instance.isar;
    return isar.resumeTemplates.filter().isActiveEqualTo(true).findFirst();
  }

  /// 新建空模板（默认不激活，由用户手动激活）
  Future<ResumeTemplate> create(String name) async {
    final isar = IsarService.instance.isar;
    // 注意：Isar 的 late 列表字段必须显式初始化，否则写入时会抛
    // LateInitializationError（内嵌列表序列化需要）
    final tpl = ResumeTemplate()
      ..templateName = name
      ..isActive = false
      ..personName = ''
      ..phone = ''
      ..email = ''
      ..school = ''
      ..major = ''
      ..education = ''
      ..skills = ''
      ..internships = <ResumeExperience>[]
      ..projects = <ResumeExperience>[]
      ..customFields = <CustomField>[]
      ..updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.resumeTemplates.put(tpl);
    });
    return tpl;
  }

  /// 保存整份模板（含内嵌的实习/项目经历、自定义字段）
  Future<void> save(ResumeTemplate tpl) async {
    final isar = IsarService.instance.isar;
    tpl.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.resumeTemplates.put(tpl);
    });
  }

  /// 删除模板；若删除的是激活模板，则把最近更新的一条转为激活
  Future<void> delete(ResumeTemplate tpl) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      await isar.resumeTemplates.delete(tpl.id);
      if (tpl.isActive) {
        final rest = await isar.resumeTemplates
            .where()
            .sortByUpdatedAtDesc()
            .findAll();
        if (rest.isNotEmpty) {
          rest.first.isActive = true;
          await isar.resumeTemplates.put(rest.first);
        }
      }
    });
  }

  /// 切换激活模板：先全部置为非激活，再把目标置为激活
  Future<void> setActive(ResumeTemplate target) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final all = await isar.resumeTemplates.where().findAll();
      for (final t in all) {
        t.isActive = t.id == target.id;
        await isar.resumeTemplates.put(t);
      }
    });
  }
}