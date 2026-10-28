import 'package:isar_community/isar.dart';

import 'isar_service.dart';
import 'schemas/application_record.dart';

/// 投递记录数据层：投递状态 + 备注，按 jobId 与岗位关联。
/// 仅本机 Isar 存储，不上传外部服务器。
class ApplicationRepo {
  ApplicationRepo._();
  static final ApplicationRepo instance = ApplicationRepo._();

  /// 查询单个岗位的投递记录
  Future<ApplicationRecord?> getByJobId(int jobId) async {
    final isar = IsarService.instance.isar;
    return isar.applicationRecords
        .filter()
        .jobIdEqualTo(jobId)
        .findFirst();
  }

  /// 查询全部投递记录（台账页）
  Future<List<ApplicationRecord>> getAll() async {
    final isar = IsarService.instance.isar;
    return isar.applicationRecords
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
  }

  /// 全部记录 → Map(岗位Id → 记录)，供列表页关联展示
  Future<Map<int, ApplicationRecord>> getAllMap() async {
    final records = await getAll();
    return {for (final r in records) r.jobId: r};
  }

  /// 保存/更新投递记录（同岗位只保留一条）。
  /// [status] 为 [ApplyStatus] 枚举，[note] 为自定义备注。
  Future<void> upsert({
    required int jobId,
    required ApplyStatus status,
    required String note,
  }) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final existing = await isar.applicationRecords
          .filter()
          .jobIdEqualTo(jobId)
          .findFirst();
      final now = DateTime.now();
      final record = existing ?? (ApplicationRecord()..createdAt = now);
      record
        ..jobId = jobId
        ..status = status.index
        ..note = note
        ..updatedAt = now;
      await isar.applicationRecords.put(record);
    });
  }

  /// 删除岗位的投递记录（清除标记）
  Future<void> deleteByJobId(int jobId) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      final existing = await isar.applicationRecords
          .filter()
          .jobIdEqualTo(jobId)
          .findFirst();
      if (existing != null) {
        await isar.applicationRecords.delete(existing.id);
      }
    });
  }
}