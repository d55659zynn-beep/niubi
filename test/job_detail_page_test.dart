import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/db/schemas/job_posting.dart';
import 'package:wangshen_app/pages/jobs/job_detail_page.dart';

/// 岗位详情页渲染测试：
/// 抓取的岗位可能没有完整 JD（详情页请求失败时 JD 为空字符串），
/// 详情页必须能安全渲染，不能红屏崩溃。
void main() {
  /// 构造一份“网页抓取风格”的岗位（字段可能为空）
  JobPosting makeJob({
    String description = '',
    String? deadline,
    String applyUrl = '',
    String city = '',
    String direction = '',
  }) {
    return JobPosting()
      ..id = 123456789
      ..uniqueKey = 'web:test'
      ..source = 'web'
      ..externalId = 'test'
      ..company = '测试公司'
      ..title = '测试岗位'
      ..city = city
      ..direction = direction
      ..deadline = deadline
      ..description = description
      ..applyUrl = applyUrl
      ..isFavorite = false
      ..reminderEnabled = false
      ..importedAt = DateTime.now();
  }

  testWidgets('空 JD 岗位详情页不崩溃，显示“暂无岗位详细描述”', (tester) async {
    await tester.pumpWidget(MaterialApp(home: JobDetailPage(job: makeJob())));
    await tester.pump(const Duration(milliseconds: 100));

    // 渲染过程不能抛异常（红屏）
    expect(tester.takeException(), isNull);
    expect(find.text('岗位详情'), findsOneWidget);
    expect(find.text('暂无岗位详细描述'), findsOneWidget);
    // 空字段兜底
    expect(find.text('未知城市'), findsOneWidget);
    expect(find.text('未分类'), findsOneWidget);
    expect(find.text('截止：未知'), findsOneWidget);
  });

  testWidgets('有完整 JD 时正常展示内容（含换行）', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: JobDetailPage(
          job: makeJob(
            description: '负责后端接口开发与维护\n\n熟悉 Java 与数据库',
            city: '深圳',
            direction: '后端',
            deadline: '2026-11-30',
            applyUrl: 'https://www.nowcoder.com/jobs/detail/1',
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
    expect(find.textContaining('负责后端接口开发'), findsOneWidget);
    expect(find.textContaining('熟悉 Java'), findsOneWidget);
    expect(find.text('深圳'), findsOneWidget);
    expect(find.text('截止：2026-11-30'), findsOneWidget);
  });

  testWidgets('投递链接为空：点击【打开投递页面】提示“暂无投递链接”，不崩溃',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: JobDetailPage(job: makeJob(applyUrl: ''))),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // 页面内容较长，先滚动到「打开投递页面」按钮
    await tester.scrollUntilVisible(
      find.text('打开投递页面'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('打开投递页面'), findsOneWidget);

    await tester.tap(find.text('打开投递页面'));
    await tester.pump(); // 显示 SnackBar 动画

    expect(tester.takeException(), isNull);
    expect(find.text('暂无投递链接'), findsOneWidget);
  });

  testWidgets('投递链接非法：点击提示“无法打开投递链接”，不崩溃', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: JobDetailPage(job: makeJob(applyUrl: '不是合法链接')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.scrollUntilVisible(
      find.text('打开投递页面'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('打开投递页面'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('无法打开投递链接'), findsOneWidget);
  });
}
