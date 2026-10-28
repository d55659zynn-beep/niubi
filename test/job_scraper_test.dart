import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wangshen_app/services/job_scraper.dart';

/// 网页岗位抓取服务单元测试：
/// 覆盖 sha256 去重 Id、HTML 解析、30 分钟节流、失败降级、浏览器 UA。
void main() {
  /// 牛客结构（简化版）的岗位列表页 HTML
  const testHtml = '''
<html><body>
<div class="job-card-item">
  <div class="line-one">
    <a href="https://www.nowcoder.com/jobs/detail/451770?deliverSource=1" class="job-message-boxs">
      <span class="job-name">嵌入式软件开发实习生</span>
      <span class="job-salary">300-600元/天</span>
      <div class="job-info-list">
        <div class="job-info-item">深圳</div>
        <div class="job-info-item">4天/周</div>
        <div class="job-info-item">本科</div>
      </div>
    </a>
    <a href="https://www.nowcoder.com/enterprise/2350" class="company-message-box">
      <span class="company-name">元戎启行</span>
    </a>
  </div>
</div>
<div class="job-card-item">
  <div class="line-one">
    <a href="/jobs/detail/451771" class="job-message-boxs">
      <span class="job-name">Java后端开发实习生</span>
      <div class="job-info-list">
        <div class="job-info-item">北京</div>
      </div>
    </a>
    <a href="/enterprise/100" class="company-message-box">
      <span class="company-name">示例科技</span>
    </a>
  </div>
</div>
</body></html>
''';

  const utf8Headers = {'content-type': 'text/html; charset=utf-8'};

  /// 牛客岗位详情页（简化版）：JD 在 .job-detail-word 下的 .ptb-2.pre-line
  const detailHtml = '''
<html><body>
<div class="card job-detail-word">
  <div class="job-detail-infos">
    <div class="fw-5">岗位职责</div>
    <div class="ptb-2 pre-line">负责后端接口开发与维护，完成需求评审。</div>
    <div class="fw-5">岗位要求</div>
    <div class="ptb-2 pre-line">熟悉 Java 与数据库，每周到岗 4 天。</div>
  </div>
</div>
</body></html>
''';

  /// 4 个岗位的列表页 HTML（用于并发限流测试）
  final testHtml4 = testHtml.replaceFirst('</body>', '''
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/451772" class="job-message-boxs"><span class="job-name">岗位C</span></a>
  <a href="/enterprise/1" class="company-message-box"><span class="company-name">公司C</span></a>
</div></div>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/451773" class="job-message-boxs"><span class="job-name">岗位D</span></a>
  <a href="/enterprise/2" class="company-message-box"><span class="company-name">公司D</span></a>
</div></div>
</body>''');

  /// 构造一个成功返回 [testHtml] 的 Mock client
  MockClient okClient({void Function(http.Request)? onRequest}) {
    return MockClient((request) async {
      onRequest?.call(request);
      return http.Response(testHtml, 200, headers: utf8Headers);
    });
  }

  group('岗位去重 Id（sha256）', () {
    test('相同标题+公司 → 相同哈希与相同数字 Id', () {
      final h1 = JobScraper.stableHash('后端开发实习生', '示例科技');
      final h2 = JobScraper.stableHash('后端开发实习生', '示例科技');
      expect(h1, h2);
      expect(h1.length, 64); // sha256 hex

      final id1 = JobScraper.stableIdFromHash(h1);
      final id2 = JobScraper.stableIdFromHash(h2);
      expect(id1, id2);
      expect(id1, isNot(0), reason: '0 不是合法 Isar Id');
    });

    test('不同岗位 → 不同 Id', () {
      final a = JobScraper.stableHash('后端开发实习生', '示例科技');
      final b = JobScraper.stableHash('前端开发实习生', '示例科技');
      final c = JobScraper.stableHash('后端开发实习生', '另一家公司');
      expect(a, isNot(b));
      expect(a, isNot(c));
      expect(JobScraper.stableIdFromHash(a),
          isNot(JobScraper.stableIdFromHash(b)));
    });

    test('哈希长度不足时抛 ArgumentError', () {
      expect(() => JobScraper.stableIdFromHash('abc'), throwsArgumentError);
    });
  });

  group('HTML 解析', () {
    test('解析出岗位字段：标题/公司/城市/方向/投递链接', () {
      final jobs = JobScraper.parseJobs(
        testHtml,
        config: ScrapeSiteConfig.nowcoder,
        baseUri: Uri.parse('https://www.nowcoder.com/jobs/intern/center'),
      );
      expect(jobs.length, 2);

      final first = jobs.firstWhere((j) => j.title.contains('嵌入式'));
      expect(first.company, '元戎启行');
      expect(first.city, '深圳');
      expect(first.direction, '嵌入式');
      expect(first.applyUrl, startsWith('https://www.nowcoder.com/jobs/detail/451770'));
      expect(first.source, 'nowcoder');
      expect(first.uniqueKey, startsWith('web:'));
      expect(first.isFavorite, isFalse);
    });

    test('相对链接被转换为绝对 URL', () {
      final jobs = JobScraper.parseJobs(
        testHtml,
        config: ScrapeSiteConfig.nowcoder,
        baseUri: Uri.parse('https://www.nowcoder.com/jobs/intern/center'),
      );
      final second = jobs.firstWhere((j) => j.title.contains('Java'));
      expect(second.applyUrl, 'https://www.nowcoder.com/jobs/detail/451771');
    });

    test('同一页面重复岗位按稳定 Id 去重', () {
      // 把第一个卡片重复一次
      final repeated = testHtml.replaceFirst(
        '</body>',
        '<div class="job-card-item"><div class="line-one">'
            '<a href="/jobs/detail/451770" class="job-message-boxs">'
            '<span class="job-name">嵌入式软件开发实习生</span></a>'
            '<a href="/enterprise/2350" class="company-message-box">'
            '<span class="company-name">元戎启行</span></a>'
            '</div></div></body>',
      );
      final jobs = JobScraper.parseJobs(
        repeated,
        config: ScrapeSiteConfig.nowcoder,
        baseUri: Uri.parse('https://www.nowcoder.com/jobs/intern/center'),
      );
      expect(jobs.length, 2, reason: '重复岗位不应重复计数');
    });

    test('自定义选择器配置可解析其他结构的页面', () {
      const customHtml = '''
<html><body>
<ul>
  <li class="post">
    <h3 class="p-title">算法实习生</h3>
    <p class="p-company">某研究院</p>
    <span class="p-city">杭州</span>
    <a href="/apply/algorithm">投递</a>
  </li>
</ul>
</body></html>
''';
      const config = ScrapeSiteConfig(
        name: 'custom',
        listUrl: 'https://jobs.example.com/list',
        cardSelector: '.post',
        titleSelector: '.p-title',
        companySelector: '.p-company',
        citySelector: '.p-city',
        linkSelector: 'a',
      );
      final jobs = JobScraper.parseJobs(
        customHtml,
        config: config,
        baseUri: Uri.parse('https://jobs.example.com/list'),
      );
      expect(jobs.length, 1);
      expect(jobs.single.title, '算法实习生');
      expect(jobs.single.company, '某研究院');
      expect(jobs.single.city, '杭州');
      expect(jobs.single.direction, '算法'); // 从标题推断
      expect(jobs.single.applyUrl, 'https://jobs.example.com/apply/algorithm');
    });
  });

  group('边界与工具函数', () {
    test('normalizeDeadline：识别常见日期写法', () {
      expect(JobScraper.normalizeDeadline('2026-11-30'), '2026-11-30');
      expect(JobScraper.normalizeDeadline('截止：2026/11/30'), '2026-11-30');
      expect(JobScraper.normalizeDeadline('2026年11月3日'), '2026-11-03');
      expect(JobScraper.normalizeDeadline(''), isNull);
      expect(JobScraper.normalizeDeadline('长期有效'), isNull);
    });
  });

  group('详情页 JD 抓取', () {
    test('列表抓取后逐个请求详情页，JD 写入 description', () async {
      final detailUrls = <String>[];
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            detailUrls.add(request.url.toString());
            return http.Response(detailHtml, 200, headers: utf8Headers);
          }
          return http.Response(testHtml, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );

      final result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.jobs.length, 2);
      expect(detailUrls.length, 2, reason: '每个岗位都应请求一次详情页');

      final first = result.jobs.firstWhere((j) => j.title.contains('嵌入式'));
      expect(first.description, contains('负责后端接口开发与维护'));
      expect(first.description, contains('熟悉 Java 与数据库'));
      // 岗位职责 + 岗位要求以空行拼接
      expect(first.description, contains('\n\n'));
    });

    test('详情页请求失败时 JD 为空字符串，不影响列表结果', () async {
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            return http.Response('server error', 500);
          }
          return http.Response(testHtml, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );

      final result = await scraper.fetchJobs();
      expect(result.success, isTrue, reason: '详情页失败不应导致整体抓取失败');
      expect(result.jobs.length, 2);
      expect(result.jobs.every((j) => j.description == ''), isTrue);
    });

    test('详情页请求并发不超过 2，请求之间有间隔延时', () async {
      var inFlight = 0;
      var maxInFlight = 0;
      var detailCount = 0;
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            inFlight++;
            detailCount++;
            if (inFlight > maxInFlight) maxInFlight = inFlight;
            // 模拟网络延迟，便于观察并发数
            await Future<void>.delayed(const Duration(milliseconds: 60));
            inFlight--;
            return http.Response(detailHtml, 200, headers: utf8Headers);
          }
          return http.Response(testHtml4, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );

      final sw = Stopwatch()..start();
      await scraper.fetchJobs();
      sw.stop();

      expect(detailCount, 4, reason: '4 个岗位各请求一次详情页');
      expect(maxInFlight, lessThanOrEqualTo(2), reason: '最多 2 个并发详情请求');
      // 2 个 worker 各处理 2 个岗位，每个请求后有 400ms 间隔：
      // 总耗时必然大于单轮延迟（宽松断言，避免机器调度误差）
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(700),
          reason: '详情请求之间应有间隔延时');
    });

    test('30 分钟节流内不再发起列表或详情请求', () async {
      var listRequests = 0;
      var detailRequests = 0;
      final now = DateTime(2026, 10, 28, 12, 0);
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            detailRequests++;
            return http.Response(detailHtml, 200, headers: utf8Headers);
          }
          listRequests++;
          return http.Response(testHtml, 200, headers: utf8Headers);
        }),
        clock: () => now,
      );

      await scraper.fetchJobs();
      expect(listRequests, 1);
      expect(detailRequests, 2);

      // 节流窗口内再次触发：列表和详情都不请求
      final second = await scraper.fetchJobs();
      expect(second.fromThrottle, isTrue);
      expect(listRequests, 1, reason: '节流内不应重复请求列表页');
      expect(detailRequests, 2, reason: '节流内不应重复请求详情页');
    });
  });

  group('30 分钟节流缓存', () {
    test('30 分钟内重复调用不重复发起请求，返回内存缓存', () async {
      var requestCount = 0;
      var now = DateTime(2026, 10, 28, 12, 0);
      final scraper = JobScraper(
        // 只统计列表页请求（详情页请求属于列表抓取的一部分）
        client: okClient(onRequest: (request) {
          if (!request.url.path.contains('/detail/')) requestCount++;
        }),
        clock: () => now,
      );

      // 第一次：发起请求
      var result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.fromThrottle, isFalse);
      expect(result.jobs.length, 2);
      expect(requestCount, 1);

      // 5 分钟后再触发：命中节流，不发请求
      now = now.add(const Duration(minutes: 5));
      result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.fromThrottle, isTrue);
      expect(result.jobs.length, 2);
      expect(requestCount, 1, reason: '30 分钟内不应重复请求');

      // 29 分钟边界内仍不请求
      now = now.add(const Duration(minutes: 24));
      await scraper.fetchJobs();
      expect(requestCount, 1);

      // 超过 30 分钟后允许再次请求
      now = now.add(const Duration(minutes: 2));
      await scraper.fetchJobs();
      expect(requestCount, 2);
    });

    test('失败后 30 分钟内也不会重复请求（防封 IP）', () async {
      var requestCount = 0;
      var now = DateTime(2026, 10, 28, 12, 0);
      final scraper = JobScraper(
        client: MockClient((_) async {
          requestCount++;
          return http.Response('server error', 500);
        }),
        clock: () => now,
      );

      final first = await scraper.fetchJobs();
      expect(first.success, isFalse);
      expect(first.error, contains('HTTP 500'));

      now = now.add(const Duration(minutes: 10));
      final second = await scraper.fetchJobs();
      expect(second.success, isFalse);
      expect(second.fromThrottle, isTrue);
      expect(requestCount, 1, reason: '失败后 30 分钟内不应重试请求');
    });
  });

  group('网络请求与降级', () {
    test('请求携带浏览器 UA 头', () async {
      String? ua;
      final scraper = JobScraper(
        client: okClient(onRequest: (request) {
          ua = request.headers['User-Agent'];
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      await scraper.fetchJobs();
      expect(ua, contains('Mozilla/5.0'));
      expect(ua, contains('Chrome'));
    });

    test('HTTP 错误码 → 抓取失败（调用方降级读本地缓存）', () async {
      final scraper = JobScraper(
        client: MockClient((_) async => http.Response('not found', 404)),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isFalse);
      expect(result.jobs, isEmpty);
      expect(result.error, contains('404'));
    });

    test('网络异常 → 抓取失败且错误信息可读', () async {
      final scraper = JobScraper(
        client: MockClient((_) async => throw http.ClientException('网络不可达')),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isFalse);
      expect(result.jobs, isEmpty);
      expect(result.error, isNotNull);
      expect(result.error!.length, lessThanOrEqualTo(121));
    });

    test('页面解析不到岗位 → 视为抓取失败', () async {
      final scraper = JobScraper(
        client: MockClient(
          (_) async => http.Response(
            '<html><body>没有岗位</body></html>',
            200,
            headers: utf8Headers,
          ),
        ),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isFalse);
      expect(result.error, contains('未解析到岗位'));
    });
  });

  group('方向标签识别（物流/供应链等职能标签）', () {
    test('物流/供应链关键词自动打标签', () {
      expect(JobScraper.inferDirection('供应链管理实习生'), '物流/供应链');
      expect(JobScraper.inferDirection('物流专员'), '物流/供应链');
      expect(JobScraper.inferDirection('仓储运营助理'), '物流/供应链');
      expect(JobScraper.inferDirection('运输调度实习生'), '物流/供应链');
      expect(JobScraper.inferDirection('仓配履约实习生'), '物流/供应链');
      expect(JobScraper.inferDirection('供应链计划实习生'), '物流/供应链');
    });

    test('其他职能标签：运营/采购/市场/财务/人力', () {
      expect(JobScraper.inferDirection('运营实习生'), '运营');
      expect(JobScraper.inferDirection('采购助理'), '采购');
      expect(JobScraper.inferDirection('市场管培生'), '市场');
      expect(JobScraper.inferDirection('财务实习生'), '财务');
      expect(JobScraper.inferDirection('HR实习生'), '人力');
      expect(JobScraper.inferDirection('产品实习生'), '产品');
    });

    test('原有技术方向标签保留', () {
      expect(JobScraper.inferDirection('后端开发实习生'), '后端');
      expect(JobScraper.inferDirection('嵌入式软件开发实习生'), '嵌入式');
      expect(JobScraper.inferDirection('算法实习生'), '算法');
    });
  });

  group('聚焦过滤与 JD 补充打标', () {
    // 两个岗位：供应链 + 技术岗
    const focusListHtml = '''
<html><body>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/9001" class="job-message-boxs"><span class="job-name">供应链管理实习生</span></a>
  <a href="/enterprise/1" class="company-message-box"><span class="company-name">物流科技</span></a>
</div></div>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/9002" class="job-message-boxs"><span class="job-name">Java后端开发实习生</span></a>
  <a href="/enterprise/2" class="company-message-box"><span class="company-name">科技公司</span></a>
</div></div>
</body></html>
''';

    test('聚焦过滤：只保留物流/供应链相关岗位', () async {
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            return http.Response(detailHtml, 200, headers: utf8Headers);
          }
          return http.Response(focusListHtml, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.jobs.length, 1, reason: '技术岗位被聚焦过滤掉');
      expect(result.jobs.single.title, '供应链管理实习生');
      expect(result.jobs.single.direction, '物流/供应链');
    });

    test('聚焦过滤：没有目标岗位时保留全部（页面不空）', () async {
      const techOnlyHtml = '''
<html><body>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/9002" class="job-message-boxs"><span class="job-name">Java后端开发实习生</span></a>
  <a href="/enterprise/2" class="company-message-box"><span class="company-name">科技公司</span></a>
</div></div>
</body></html>
''';
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            return http.Response(detailHtml, 200, headers: utf8Headers);
          }
          return http.Response(techOnlyHtml, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.jobs.length, 1, reason: '聚焦为空时不应返回空列表');
    });

    test('JD 关键词补充打标签（标题无方向词时）', () async {
      const noTagHtml = '''
<html><body>
<div class="job-card-item"><div class="line-one">
  <a href="/jobs/detail/9003" class="job-message-boxs"><span class="job-name">实习助理</span></a>
  <a href="/enterprise/3" class="company-message-box"><span class="company-name">某公司</span></a>
</div></div>
</body></html>
''';
      const jdHtml = '''
<html><body>
<div class="card job-detail-word">
  <div class="ptb-2 pre-line">负责物流配送协调与仓储库存盘点。</div>
</div>
</body></html>
''';
      final scraper = JobScraper(
        client: MockClient((request) async {
          if (request.url.path.contains('/detail/')) {
            return http.Response(jdHtml, 200, headers: utf8Headers);
          }
          return http.Response(noTagHtml, 200, headers: utf8Headers);
        }),
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.jobs.single.direction, '物流/供应链',
          reason: 'JD 命中物流关键词应自动打标签');
    });
  });

  group('实习僧平台解析', () {
    // 实习僧搜索页结构（标题含图标字体私用区字符）
    const shixisengHtml = '''
<html><body>
<div class="intern-item">
  <div class="intern-detail">
    <div class="intern-detail__job">
      <p><a href="https://www.shixiseng.com/intern/inn_1" class="title">供应链实习&#xf8c5;</a></p>
      <span class="city">贵阳</span>
    </div>
    <div class="intern-detail__company">
      <p><a class="title">赛峰中国</a></p>
    </div>
  </div>
</div>
</body></html>
''';

    test('解析实习僧岗位：图标字体字符被清洗、字段正确', () {
      final jobs = JobScraper.parseJobs(
        shixisengHtml,
        config: ScrapeSiteConfig.shixiseng,
        baseUri: Uri.parse('https://www.shixiseng.com/interns?keyword=供应链'),
      );
      expect(jobs.length, 1);
      final job = jobs.single;
      expect(job.title, '供应链实习', reason: '私用区图标字符应被清洗');
      expect(job.company, '赛峰中国');
      expect(job.city, '贵阳');
      expect(job.direction, '物流/供应链');
      expect(job.source, 'shixiseng');
      expect(job.applyUrl, 'https://www.shixiseng.com/intern/inn_1');
    });

    test('实习僧多关键词搜索页：同一岗位跨页去重', () async {
      final scraper = JobScraper(
        client: MockClient((_) async {
          // 5 个关键词列表页都返回同一岗位，模拟跨页重复
          return http.Response(shixisengHtml, 200, headers: utf8Headers);
        }),
        config: ScrapeSiteConfig.shixiseng,
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      final result = await scraper.fetchJobs();
      expect(result.success, isTrue);
      expect(result.jobs.length, 1, reason: '跨关键词搜索页同一岗位应去重');
    });
  });

  group('BOSS直聘 Cookie 支持', () {
    test('注入 Cookie 后请求头携带 Cookie', () async {
      String? capturedCookie;
      final scraper = JobScraper(
        client: MockClient((request) async {
          capturedCookie = request.headers['Cookie'];
          return http.Response(testHtml, 200, headers: utf8Headers);
        }),
        config: ScrapeSiteConfig.boss,
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      scraper.setCookie('__zp_stoken__=abc123; lastCity=100010000');
      await scraper.fetchJobs();
      expect(capturedCookie, contains('__zp_stoken__=abc123'));
      expect(scraper.hasCookie, isTrue);
    });

    test('未注入 Cookie 时请求头不包含 Cookie', () async {
      String? capturedCookie = 'initial';
      final scraper = JobScraper(
        client: MockClient((request) async {
          capturedCookie = request.headers['Cookie'];
          return http.Response(testHtml, 200, headers: utf8Headers);
        }),
        config: ScrapeSiteConfig.boss,
        clock: () => DateTime(2026, 10, 28, 12, 0),
      );
      await scraper.fetchJobs();
      expect(capturedCookie, isNull);
      expect(scraper.hasCookie, isFalse);
    });

    test('清除 Cookie（传入空串）', () {
      final scraper = JobScraper(config: ScrapeSiteConfig.boss);
      scraper.setCookie('cookie=1');
      expect(scraper.hasCookie, isTrue);
      scraper.setCookie('');
      expect(scraper.hasCookie, isFalse);
    });
  });
}