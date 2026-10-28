import '../db/schemas/application_record.dart';
import '../db/schemas/job_posting.dart';
import 'multi_platform_scraper.dart';

/// 岗位列表 CSV 导出工具。
/// 仅读取本地 Isar 缓存数据（不触发爬虫抓取），生成带 UTF-8 BOM 的 CSV。
class CsvExporter {
  CsvExporter._();

  /// CSV 表头（与需求字段一致）
  static const headers = [
    '平台来源',
    '公司',
    '岗位名称',
    '城市',
    '岗位标签',
    '投递链接',
    '投递状态',
    '备注',
  ];

  /// 把岗位列表 + 投递记录转换为 CSV 文本。
  /// [records] 为 jobId → 投递记录（可为空，表示未标记）。
  static String buildCsv(
    List<JobPosting> jobs, {
    Map<int, ApplicationRecord> records = const {},
  }) {
    final sb = StringBuffer();
    // UTF-8 BOM：保证 Excel 直接打开不乱码
    sb.write('\uFEFF');
    sb.writeln(headers.map(_escape).join(','));
    for (final job in jobs) {
      final record = records[job.id];
      final status = record == null
          ? ''
          : (applyStatusLabels[ApplyStatus.values[
                  record.status.clamp(0, ApplyStatus.values.length - 1)]] ??
              '');
      final note = record?.note ?? '';
      final row = [
        MultiPlatformScraper.labelOf(job.source),
        job.company,
        job.title,
        job.city,
        job.direction,
        job.applyUrl,
        status,
        note,
      ];
      sb.writeln(row.map(_escape).join(','));
    }
    return sb.toString();
  }

  /// CSV 字段转义（双引号包裹，内部双引号双写）
  static String _escape(String value) {
    final text = value.replaceAll('\r\n', ' ').replaceAll('\n', ' ');
    return '"${text.replaceAll('"', '""')}"';
  }
}