import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/app.dart';
import 'package:wangshen_app/services/job_scraper.dart';
import 'package:wangshen_app/services/multi_platform_scraper.dart';

/// 测试用 stub：直接返回成功空结果，不发网络请求、不触发失败弹窗
class _StubScraper extends JobScraper {
  _StubScraper(ScrapeSiteConfig config) : super(config: config);

  @override
  Future<ScrapeResult> fetchJobs() async => const ScrapeResult(jobs: []);
}

void main() {
  testWidgets('首页展示岗位与简历导航', (tester) async {
    // 测试环境替换多平台抓取器，避免进入岗位页时发起真实网页请求
    MultiPlatformScraper.instance = MultiPlatformScraper.withScrapers([
      _StubScraper(ScrapeSiteConfig.nowcoder),
      _StubScraper(ScrapeSiteConfig.shixiseng),
      _StubScraper(ScrapeSiteConfig.boss),
    ]);

    await tester.pumpWidget(const WangshenApp());
    expect(find.text('岗位'), findsWidgets);
    expect(find.text('简历'), findsWidgets);

    // 等待进入岗位页触发的异步抓取流程结束，避免遗留未完成的异步任务
    await tester.pumpAndSettle();
  });
}