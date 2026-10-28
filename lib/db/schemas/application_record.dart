import 'package:isar_community/isar.dart';

part 'application_record.g.dart';

/// 投递状态枚举（与 Isar 整型字段映射）
enum ApplyStatus {
  /// 待投递
  pending,

  /// 已投递
  submitted,

  /// 面试中
  interviewing,

  /// 已挂
  rejected,
}

/// 投递状态的中文标签
const applyStatusLabels = <ApplyStatus, String>{
  ApplyStatus.pending: '待投递',
  ApplyStatus.submitted: '已投递',
  ApplyStatus.interviewing: '面试中',
  ApplyStatus.rejected: '已挂',
};

/// 岗位投递记录：投递状态 + 自定义备注（与 JobPosting 通过 jobId 关联）。
/// 所有数据仅保存在本机 Isar 数据库。
@collection
class ApplicationRecord {
  Id id = Isar.autoIncrement;

  /// 关联的岗位 Id（JobPosting.id，唯一）
  @Index(unique: true)
  late int jobId;

  /// 投递状态（ApplyStatus.index）
  @Index()
  late int status;

  /// 自定义文本备注
  late String note;

  /// 状态/备注最后更新时间
  @Index()
  late DateTime updatedAt;

  /// 创建时间
  late DateTime createdAt;
}