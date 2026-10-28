import 'package:isar_community/isar.dart';

import 'isar_service.dart';
import 'schemas/form_mapping.dart';

/// 网站表单映射的数据访问层：按 host 保存/读取/删除绑定规则。
/// 每个招聘网站（host）一套独立规则，全部保存在本机。
class FormMappingRepo {
  FormMappingRepo._();
  static final FormMappingRepo instance = FormMappingRepo._();

  /// 获取某个网站的全部映射规则（没有则返回空列表）
  Future<List<FieldMapRule>> getRules(String host) async {
    final isar = IsarService.instance.isar;
    final mapping =
        await isar.formMappings.filter().hostEqualTo(host).findFirst();
    return mapping?.rules ?? [];
  }

  /// 保存一条绑定规则（同选择器覆盖旧规则）
  Future<void> saveRule(String host, FieldMapRule rule) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      var mapping =
          await isar.formMappings.filter().hostEqualTo(host).findFirst();
      mapping ??= FormMapping()
        ..host = host
        ..rules = <FieldMapRule>[]
        ..updatedAt = DateTime.now();
      // 同选择器替换，避免重复积累
      final idx = mapping.rules.indexWhere(
        (r) => r.cssSelector == rule.cssSelector,
      );
      if (idx >= 0) {
        mapping.rules[idx] = rule;
      } else {
        mapping.rules.add(rule);
      }
      mapping.updatedAt = DateTime.now();
      await isar.formMappings.put(mapping);
    });
  }

  /// 删除一条绑定规则
  Future<void> deleteRule(String host, String cssSelector) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final mapping =
          await isar.formMappings.filter().hostEqualTo(host).findFirst();
      if (mapping == null) return;
      mapping.rules.removeWhere((r) => r.cssSelector == cssSelector);
      mapping.updatedAt = DateTime.now();
      await isar.formMappings.put(mapping);
    });
  }
}