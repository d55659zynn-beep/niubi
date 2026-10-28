import 'package:isar_community/isar.dart';

part 'job_posting.g.dart';

/// 岗位（由电脑端爬虫 JSON 导入，仅保存在本机）
@collection
class JobPosting {
  Id id = Isar.autoIncrement;

  /// 去重键：来源 + 爬虫侧 id
  @Index(unique: true, replace: true)
  late String uniqueKey;

  /// 爬虫来源站点标识，如 nowcoder / boss
  @Index()
  late String source;

  /// 爬虫导出文件里的原始 id
  late String externalId;

  @Index()
  late String company;

  late String title;

  @Index()
  late String city;

  /// 岗位方向，如 后端 / 前端 / 算法
  @Index()
  late String direction;

  /// 截止日期，格式 YYYY-MM-DD，可空
  @Index()
  String? deadline;

  late String description;

  /// 企业招聘投递页，仅用于本机 WebView 打开
  late String applyUrl;

  @Index()
  late bool isFavorite;

  late DateTime importedAt;

  /// 是否已为该岗位安排本地截止提醒
  late bool reminderEnabled;
}
