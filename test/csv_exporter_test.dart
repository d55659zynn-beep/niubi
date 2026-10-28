import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/schemas/application_record.dart';
import 'package:wangshen_app/db/schemas/job_posting.dart';
import 'package:wangshen_app/services/csv_exporter.dart';

/// CSV 导出测试：表头、BOM、字段转义、投递状态与备注。
void main() {
  JobPosting makeJob({
    required int id,
    String title = '供应链实习生',
    String company = '示例公司',
    String city = '成都',
    String direction = '物流/供应链',
    String source = 'nowcoder',
  }) {
    return JobPosting()
      ..id = id
      ..uniqueKey = 'test:$id'
      ..source = source
      ..externalId = '$id'
      ..company = company
      ..title = title
      ..city = city
      ..direction = direction
      ..deadline = null
      ..description = ''
      ..applyUrl = 'https://example.com/$id'
      ..isFavorite = false
      ..reminderEnabled = false
      ..importedAt = DateTime.now();
  }

  ApplicationRecord makeRecord({
    required int jobId,
    required ApplyStatus status,
    String note = '',
  }) {
    final now = DateTime.now();
    return ApplicationRecord()
      ..jobId = jobId
      ..status = status.index
      ..note = note
      ..updatedAt = now
      ..createdAt = now;
  }

  test('CSV 包含 UTF-8 BOM 与完整表头', () {
    final csv = CsvExporter.buildCsv([]);
    expect(csv.startsWith('\uFEFF'), isTrue, reason: '需要 BOM 供 Excel 识别');
    for (final header in CsvExporter.headers) {
      expect(csv, contains(header));
    }
    expect(CsvExporter.headers.length, 8);
  });

  test('岗位数据 + 投递状态/备注导出为 CSV 行', () {
    final job = makeJob(id: 1);
    final record = makeRecord(
      jobId: 1,
      status: ApplyStatus.interviewing,
      note: '面试中',
    );
    final csv = CsvExporter.buildCsv([job], records: {1: record});
    expect(csv, contains('牛客')); // 平台来源中文名
    expect(csv, contains('示例公司'));
    expect(csv, contains('供应链实习生'));
    expect(csv, contains('成都'));
    expect(csv, contains('物流/供应链'));
    expect(csv, contains('https://example.com/1'));
    expect(csv, contains('面试中'));
    expect(csv, contains('面试中')); // 状态列
  });

  test('未标记投递状态的岗位状态与备注为空', () {
    final csv = CsvExporter.buildCsv([makeJob(id: 2)]);
    // 行末两个字段为空：,"",""
    expect(csv, contains(',"",""'));
  });

  test('CSV 字段转义：引号与换行', () {
    final job = makeJob(id: 3, title: '岗位"高级"版', company: '公司\n名称');
    final csv = CsvExporter.buildCsv([job]);
    expect(csv, contains('"岗位""高级""版"'));
    expect(csv, contains('"公司 名称"'), reason: '换行被替换为空格');
  });
}