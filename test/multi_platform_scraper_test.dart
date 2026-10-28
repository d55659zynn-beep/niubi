import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wangshen_app/services/job_scraper.dart';
import 'package:wangshen_app/services/multi_platform_scraper.dart';

/// 多平台抓取编排测试：三平台合并、单平台失败隔离、独立节流。
void main() {
  const utf8Headers = {'content-type': 'text/html; charset=utf-8'};

  // 牛客结构的岗位列表 HTML
  const nowcoderHtml = '''
<html><body>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/1" class="job-message-boxs"><span class="job-name">牛客供应链实习生</span></a>
  <a href="/enterprise/1" class="company-message-box"><span class="company-name">牛客公司</span></a>
</div></div>
</body></html>
''';

  // 实习僧结构的岗位列表 HTML（图标字体字符应被清洗）
  const shixisengHtml = '''
<html><body>
<div class="intern-item">
  <div class="intern-detail">
    <div class="intern-detail__job">
      <p><a href="https://www.shixiseng.com/intern/inn_1" class="title">实习僧供应链实习生&#xf8c5;</a></p>
      <span class="city">贵阳</span>
    </div>
    <div class="intern-detail__company">
      <p><a class="title">实习僧公司</a></p>
    </div>
  </div>
</div>
</body></html>
''';

  /// 按请求域名返回对应平台的 HTML；BOSS 返回 403 模拟反爬拦截
  MockClient platformClient() => MockClient((request) async {
        final host = request.url.host;
        if (host.contains('nowcoder')) {
          return http.Response(nowcoderHtml, 200, headers: utf8Headers);
        }
        if (host.contains('shixiseng')) {
          return http.Response(shixisengHtml, 200, headers: utf8Headers);
        }
        return http.Response('blocked by anti-crawler', 403);
      });

  /// 构造三平台抓取器（共享同一 mock client）
  MultiPlatformScraper makeMulti() => MultiPlatformScraper.withScrapers([
        JobScraper(
          client: platformClient(),
          clock: () => DateTime(2026, 10, 28, 12, 0),
        ),
        JobScraper(
          client: platformClient(),
          config: ScrapeSiteConfig.shixiseng,
          clock: () => DateTime(2026, 10, 28, 12, 0),
        ),
        JobScraper(
          client: platformClient(),
          config: ScrapeSiteConfig.boss,
          clock: () => DateTime(2026, 10, 28, 12, 0),
        ),
      ]);

  test('三平台合并抓取：成功平台数据合并，失败平台隔离', () async {
    final result = await makeMulti().fetchAll();

    // 牛客 + 实习僧成功，BOSS 失败
    expect(result.jobs.length, greaterThanOrEqualTo(2));
    expect(
      result.jobs.map((j) => j.source).toSet(),
      containsAll(<String>['nowcoder', 'shixiseng']),
    );

    expect(result.platformErrors.keys, contains('boss'));
    expect(result.platformErrors.length, 1);
    expect(result.platformErrors['boss'], contains('HTTP 403'));
  });

  test('各平台独立 30 分钟节流：二次抓取不重复请求', () async {
    var requestCount = 0;
    var now = DateTime(2026, 10, 28, 12, 0);

    MockClient countingClient() => MockClient((request) async {
          requestCount++;
          final host = request.url.host;
          if (host.contains('nowcoder')) {
            return http.Response(nowcoderHtml, 200, headers: utf8Headers);
          }
          if (host.contains('shixiseng')) {
            return http.Response(shixisengHtml, 200, headers: utf8Headers);
          }
          return http.Response('blocked', 403);
        });

    final multi = MultiPlatformScraper.withScrapers([
      JobScraper(client: countingClient(), clock: () => now),
      JobScraper(
        client: countingClient(),
        config: ScrapeSiteConfig.shixiseng,
        clock: () => now,
      ),
      JobScraper(
        client: countingClient(),
        config: ScrapeSiteConfig.boss,
        clock: () => now,
      ),
    ]);

    await multi.fetchAll();
    final firstRound = requestCount;
    expect(firstRound, greaterThan(0));

    // 节流窗口内再次抓取：所有平台都不应重复请求
    await multi.fetchAll();
    expect(requestCount, firstRound, reason: '30 分钟内不应重复请求');

    // 超过 30 分钟后允许再次请求
    now = now.add(const Duration(minutes: 31));
    await multi.fetchAll();
    expect(requestCount, greaterThan(firstRound));
  });

  test('来源平台中文名映射', () {
    expect(MultiPlatformScraper.labelOf('nowcoder'), '牛客');
    expect(MultiPlatformScraper.labelOf('shixiseng'), '实习僧');
    expect(MultiPlatformScraper.labelOf('boss'), 'BOSS直聘');
    expect(MultiPlatformScraper.labelOf('demo'), '导入');
  });
}