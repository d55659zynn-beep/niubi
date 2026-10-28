import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import '../db/schemas/job_posting.dart';
import 'headless_jd_fetcher.dart';

/// 抓取站点配置（CSS 选择器）。
/// 换目标网站时调整这里的选择器即可，无需改动抓取流程。
class ScrapeSiteConfig {
  const ScrapeSiteConfig({
    required this.name,
    required this.listUrl,
    this.extraListUrls = const [],
    required this.cardSelector,
    required this.titleSelector,
    this.companySelector = '.company-name',
    this.citySelector,
    this.directionSelector,
    this.deadlineSelector,
    this.descriptionSelector,
    this.detailDescriptionSelector,
    this.linkSelector = 'a',
    this.infoItemSelector,
    this.focusKeywords = const [],
    this.useHeadlessDetail = false,
    this.headlessDetailSelector,
  });

  /// 站点标识（写入岗位 source 字段）
  final String name;

  /// 岗位列表页地址（首个）
  final String listUrl;

  /// 额外的列表页地址（如实习僧按关键词搜索的多页入口）
  final List<String> extraListUrls;

  /// 全部列表页地址（首个 + 额外，去重）
  List<String> get allListUrls {
    final urls = <String>[listUrl, ...extraListUrls];
    return urls.toSet().toList();
  }

  /// 单个岗位卡片的选择器
  final String cardSelector;

  /// 岗位名称选择器（必填）
  final String titleSelector;

  /// 公司名称选择器
  final String companySelector;

  /// 城市选择器（为空时从 [infoItemSelector] 的文本中推断）
  final String? citySelector;

  /// 岗位方向选择器（为空时从岗位名推断）
  final String? directionSelector;

  /// 截止日期选择器（为空时忽略）
  final String? deadlineSelector;

  /// 岗位描述选择器（为空时忽略，列表页通常没有完整 JD）
  final String? descriptionSelector;

  /// 详情页 JD 选择器（可匹配多个元素，按顺序拼接）。
  /// 列表页没有完整 JD 时，抓取器会逐个访问岗位详情页补全。
  final String? detailDescriptionSelector;

  /// 投递链接选择器（取 href）
  final String linkSelector;

  /// 卡片内的信息项选择器（用于城市推断，如牛客的 ".job-info-item"）
  final String? infoItemSelector;

  /// 聚焦关键词（如“物流/供应链”类岗位）：
  /// 标题或 JD 命中的岗位视为目标岗位；过滤后若为空则保留全部（避免空列表）。
  final List<String> focusKeywords;

  /// 是否使用无头浏览器渲染详情页后再提取 JD。
  /// 实习僧详情页 JD 为前端动态渲染，SSR 抓不到，需桌面端 Chrome headless 渲染。
  final bool useHeadlessDetail;

  /// 无头浏览器渲染后详情页的 JD 选择器（配合 [useHeadlessDetail]）
  final String? headlessDetailSelector;

  /// 物流管理专业聚焦关键词（所有平台共用）
  static const logisticsFocusKeywords = [
    '物流', '供应链', '仓储', '库存', '运输', '仓配', '履约',
    '采购', '供应链计划',
  ];

  /// 默认站点：牛客网 · 实习广场（服务端渲染，可直接解析）。
  ///
  /// 数据源说明：牛客没有可按 SSR 抓取的独立“职能/供应链”专区 URL
  /// （查询/分页参数接口受限），因此抓取实习广场列表后，
  /// 通过 [focusKeywords] 聚焦物流/供应链/采购/运营类岗位，
  /// 并在解析时按标题/JD 关键词自动打方向标签。
  static const nowcoder = ScrapeSiteConfig(
    name: 'nowcoder',
    listUrl: 'https://www.nowcoder.com/jobs/intern/center',
    cardSelector: '.job-card-item',
    titleSelector: '.job-name',
    companySelector: '.company-name',
    linkSelector: 'a[href*="/jobs/detail/"]',
    infoItemSelector: '.job-info-item',
    // 牛客岗位详情页：“岗位职责”“岗位要求”正文都在 .job-detail-word
    // 容器下的 .ptb-2.pre-line 中（两个元素按顺序拼接）
    detailDescriptionSelector: '.job-detail-word .ptb-2.pre-line',
    focusKeywords: logisticsFocusKeywords,
  );

  /// 实习僧：按物流/供应链等关键词搜索实习（Nuxt SSR，列表可解析）。
  /// 详情页 JD 为前端动态渲染，SSR 抓不到 → detailDescriptionSelector 留空，
  /// 由 JD 缺失兜底逻辑处理（岗位详情节显示“暂无岗位详细描述”）。
  static const shixiseng = ScrapeSiteConfig(
    name: 'shixiseng',
    listUrl: 'https://www.shixiseng.com/interns?keyword=物流',
    extraListUrls: [
      'https://www.shixiseng.com/interns?keyword=供应链',
      'https://www.shixiseng.com/interns?keyword=仓储',
      'https://www.shixiseng.com/interns?keyword=采购',
      'https://www.shixiseng.com/interns?keyword=运营',
    ],
    cardSelector: '.intern-item',
    titleSelector: '.intern-detail__job .title',
    companySelector: '.intern-detail__company a.title',
    citySelector: '.intern-detail__job .city',
    linkSelector: 'a[href*="/intern/"]',
    focusKeywords: logisticsFocusKeywords,
    // 实习僧详情页 JD 为前端动态渲染：桌面端用无头浏览器渲染后提取
    useHeadlessDetail: true,
    headlessDetailSelector: '.job-content .job_detail',
  );

  /// BOSS直聘：公开访问会被反爬验证页拦截（需要登录态/浏览器指纹），
  /// 保留配置以便抓取尝试；失败时由平台级隔离逻辑提示，不影响其他平台。
  static const boss = ScrapeSiteConfig(
    name: 'boss',
    listUrl:
        'https://www.zhipin.com/web/geek/job?query=供应链&city=100010000',
    cardSelector: '.job-card-wrapper',
    titleSelector: '.job-name',
    companySelector: '.company-name',
    linkSelector: 'a[href*="/job_detail/"]',
    focusKeywords: logisticsFocusKeywords,
  );
}

/// 一次抓取的结果。
class ScrapeResult {
  const ScrapeResult({required this.jobs, this.fromThrottle = false, this.error});

  /// 解析到的岗位（命中节流时为内存缓存）
  final List<JobPosting> jobs;

  /// 是否命中 30 分钟节流缓存（未发起网络请求）
  final bool fromThrottle;

  /// 错误信息；null 表示成功
  final String? error;

  bool get success => error == null;
}

/// 岗位网页抓取服务：
/// - 带浏览器 UA 请求招聘列表页，用 html 包解析岗位
/// - 30 分钟节流：窗口内重复调用不再发起网络请求（防止被封 IP）
/// - 岗位去重：岗位标题 + 公司名称 拼接做 sha256，生成稳定数字 Id
class JobScraper {
  JobScraper({
    http.Client? client,
    ScrapeSiteConfig? config,
    DateTime Function()? clock,
  })  : _client = client ?? http.Client(),
        _config = config ?? ScrapeSiteConfig.nowcoder,
        _now = clock ?? DateTime.now;

  /// 页面使用的单例。
  /// 可变：单元/Widget 测试中可替换为注入 MockClient 的实例，避免真实网络请求。
  static JobScraper instance = JobScraper();

  /// 节流窗口：30 分钟内不重复请求网页
  static const throttleDuration = Duration(minutes: 30);

  /// 模拟浏览器的 User-Agent
  static const browserUserAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
      'AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/126.0.0.0 Safari/537.36';

  final http.Client _client;
  final ScrapeSiteConfig _config;
  final DateTime Function() _now;

  // 30 分钟节流缓存（仅内存，不落库）
  DateTime? _lastAttemptAt;
  List<JobPosting>? _memoryJobs;
  String? _lastError;

  /// BOSS直聘登录 Cookie（由设置页导入后注入；仅本机 Isar 存储）
  String? _cookie;

  /// 注入登录 Cookie（BOSS直聘等需要登录态的平台）
  void setCookie(String? cookie) {
    _cookie = (cookie == null || cookie.trim().isEmpty) ? null : cookie.trim();
  }

  /// 当前是否携带 Cookie（供平台状态判断）
  bool get hasCookie => _cookie != null;

  ScrapeSiteConfig get config => _config;

  /// 抓取岗位。
  /// - 30 分钟内重复调用：直接返回内存结果，不发起请求
  /// - 成功：返回岗位列表（调用方负责写入 Isar）
  /// - 失败：返回 error，调用方应降级读取 Isar 本地缓存
  Future<ScrapeResult> fetchJobs() async {
    final now = _now();
    final last = _lastAttemptAt;
    if (last != null && now.difference(last) < throttleDuration) {
      // 30 分钟节流：不重复请求
      final cached = _memoryJobs;
      if (cached != null) {
        return ScrapeResult(jobs: cached, fromThrottle: true);
      }
      return ScrapeResult(
        jobs: const [],
        fromThrottle: true,
        error: _lastError ?? '30 分钟内已尝试抓取，暂不重复请求',
      );
    }

    // 无论成败都记录尝试时间：避免失败后频繁重试导致被封 IP
    _lastAttemptAt = now;
    try {
      final jobs = await _fetchFromWeb();
      _memoryJobs = jobs;
      _lastError = null;
      return ScrapeResult(jobs: jobs);
    } catch (e) {
      _memoryJobs = null;
      _lastError = _cleanError(e);
      return ScrapeResult(jobs: const [], error: _lastError);
    }
  }

  /// 详情页请求并发上限（防止短时间内大量并发触发网站风控）
  static const maxConcurrentDetailRequests = 2;

  /// 每次详情页请求后的间隔
  static const detailRequestInterval = Duration(milliseconds: 400);

  /// 无头浏览器 JD 补抓上限（启动浏览器较慢，避免拖慢整体抓取）
  static const maxHeadlessDetailJobs = 10;

  /// 浏览器请求头（列表页与详情页共用；有 Cookie 时附加）
  Map<String, String> get _browserHeaders => {
        'User-Agent': browserUserAgent,
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
        'Cookie': ?_cookie,
      };

  /// 发起网络请求并解析岗位（多个列表页 → 逐个访问详情页补全完整 JD）。
  /// 单个列表页失败不中断（继续其他列表页）；全部失败才抛异常。
  Future<List<JobPosting>> _fetchFromWeb() async {
    // 跨列表页按稳定 Id 去重（同一岗位出现在多个关键词搜索页时只保留一份）
    final jobs = <int, JobPosting>{};
    final urls = _config.allListUrls;

    var anySuccess = false;
    String? lastError;
    for (final urlStr in urls) {
      try {
        final url = Uri.parse(urlStr);
        final response = await _client.get(
          url,
          headers: _browserHeaders,
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode != 200) {
          throw Exception('网页请求失败（HTTP ${response.statusCode}）');
        }
        final pageJobs = parseJobs(
          response.body,
          config: _config,
          baseUri: url,
        );
        for (final job in pageJobs) {
          jobs[job.id] = job;
        }
        anySuccess = true;
      } catch (e) {
        // 单个列表页失败：记录原因，继续抓取其他列表页
        lastError = _cleanError(e);
      }
      // 多个列表页之间留出间隔，降低频繁请求的风控风险
      if (urls.length > 1) {
        await Future<void>.delayed(detailRequestInterval);
      }
    }

    if (!anySuccess || jobs.isEmpty) {
      // 保留具体失败原因（如 HTTP 403），便于页面提示用户
      throw Exception(lastError ?? '页面中未解析到岗位，请检查抓取站点配置');
    }
    final list = jobs.values.toList();

    // 列表页没有完整 JD：逐个访问岗位详情页补全岗位描述
    await _fillDescriptions(list);
    // 聚焦过滤：保留物流/供应链/采购/运营类岗位（为空则保留全部）
    return _applyFocusFilter(list, _config);
  }

  /// 为岗位补全详情页 JD：
  /// - HTTP 模式：并发限流（最多 [maxConcurrentDetailRequests] 个同时请求），
  ///   每次请求完成后间隔 [detailRequestInterval]，防止触发网站风控
  /// - 无头浏览器模式（实习僧等动态渲染页面）：桌面端用 Chrome headless
  ///   渲染后提取 JD，数量限制 [maxHeadlessDetailJobs]，失败保留空字符串
  /// - 单个详情页失败时 JD 保留空字符串，不中断整体抓取
  Future<void> _fillDescriptions(List<JobPosting> jobs) async {
    final selector = _config.detailDescriptionSelector;
    final headlessSelector = _config.headlessDetailSelector;
    final useHeadless = _config.useHeadlessDetail &&
        headlessSelector != null &&
        headlessSelector.isNotEmpty &&
        HeadlessJdFetcher.isDesktop &&
        HeadlessJdFetcher.instance.available;

    // 既没有 HTTP 选择器、也没有无头浏览器条件 → 跳过（JD 空兜底）
    if ((selector == null || selector.isEmpty) && !useHeadless) return;

    var targets = jobs.where((j) => j.applyUrl.isNotEmpty).toList();
    if (targets.isEmpty) return;
    // 无头浏览器逐岗位启动较慢：限制补抓数量（HTTP 模式不限）
    final useHeadlessMode = selector == null || selector.isEmpty;
    if (useHeadlessMode && useHeadless) {
      targets = targets.take(maxHeadlessDetailJobs).toList();
    }

    var next = 0;
    // 无头渲染熔断：一次超时/失败后本次抓取不再重试，避免每个岗位都等待超时
    var headlessBroken = false;
    Future<void> worker() async {
      while (true) {
        final index = next++;
        if (index >= targets.length) return;
        final job = targets[index];
        try {
          if (useHeadlessMode) {
            if (headlessBroken) {
              job.description = '';
            } else {
              // 无头浏览器渲染动态页面后提取 JD
              final html = await HeadlessJdFetcher.instance
                  .fetchRenderedHtml(job.applyUrl);
              if (html == null) {
                headlessBroken = true;
                job.description = '';
              } else {
                job.description = HeadlessJdFetcher.extractDescription(
                        html, headlessSelector!) ??
                    '';
              }
            }
          } else {
            job.description = await _fetchJobDescription(job.applyUrl);
          }
        } catch (_) {
          // 详情页请求失败：JD 保留空字符串（不覆盖、不抛异常），
          // 允许用户进入详情页时看到“暂无岗位详细描述”提示
          job.description = '';
        }
        // 用 JD 文本补充职能方向标签（物流/供应链/运营/采购等）
        _applyJdTag(job);
        // 请求间隔：降低短时间内的访问频率
        await Future<void>.delayed(
          useHeadlessMode
              ? const Duration(milliseconds: 300)
              : detailRequestInterval,
        );
      }
    }

    final workerCount = targets.length < maxConcurrentDetailRequests
        ? targets.length
        : maxConcurrentDetailRequests;
    await Future.wait(List.generate(workerCount, (_) => worker()));
  }

  /// 请求单个岗位详情页并提取完整 JD（岗位职责 + 岗位要求拼接）。
  /// 失败时抛出异常，由调用方兜底为空字符串。
  Future<String> _fetchJobDescription(String detailUrl) async {
    final response = await _client.get(
      Uri.parse(detailUrl),
      headers: _browserHeaders,
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('详情页请求失败（HTTP ${response.statusCode}）');
    }
    final document = html_parser.parse(response.body);
    final parts = document
        .querySelectorAll(_config.detailDescriptionSelector!)
        .map((e) => _cleanText(e.text, collapseWhitespace: false))
        .where((t) => t.isNotEmpty)
        .toList();
    return parts.join('\n\n');
  }

  /// 从 HTML 文本解析岗位列表（公开静态方法，便于单元测试）。
  static List<JobPosting> parseJobs(
    String htmlText, {
    required ScrapeSiteConfig config,
    required Uri baseUri,
  }) {
    final document = html_parser.parse(htmlText);
    final cards = document.querySelectorAll(config.cardSelector);
    // 用稳定 Id 去重：同一页面重复出现的岗位以后出现的为准
    final jobs = <int, JobPosting>{};

    for (final card in cards) {
      final title = _textOf(card, config.titleSelector);
      if (title.isEmpty) continue;

      final company = _textOf(card, config.companySelector);
      final href = card
              .querySelector(config.linkSelector)
              ?.attributes['href']
              ?.trim() ??
          '';
      final applyUrl = href.isEmpty ? '' : baseUri.resolve(href).toString();

      // 信息项文本（用于推断城市，如“深圳 / 4天/周 / 本科”）
      final infoTexts = config.infoItemSelector == null
          ? const <String>[]
          : card
              .querySelectorAll(config.infoItemSelector!)
              .map((e) => e.text.trim())
              .where((t) => t.isNotEmpty)
              .toList();

      final city = _firstNonEmpty(_textOf(card, config.citySelector), () {
        return _inferCity(infoTexts);
      });
      final direction =
          _firstNonEmpty(_textOf(card, config.directionSelector), () {
        return inferDirection(title);
      });
      final deadline = normalizeDeadline(
        _textOf(card, config.deadlineSelector ?? ''),
      );

      final hash = stableHash(title, company);
      final id = stableIdFromHash(hash);
      jobs[id] = JobPosting()
        ..id = id
        ..uniqueKey = 'web:$hash'
        ..source = config.name
        ..externalId = hash
        ..company = company.isEmpty ? '未知公司' : company
        ..title = title
        ..city = city
        ..direction = direction
        ..deadline = deadline
        ..description = _textOf(card, config.descriptionSelector ?? '')
        ..applyUrl = applyUrl
        ..isFavorite = false
        ..reminderEnabled = false
        ..importedAt = DateTime.now();
    }
    return jobs.values.toList();
  }

  /// 去重哈希：岗位标题 + 公司名称 拼接后做 sha256。
  static String stableHash(String title, String company) =>
      sha256.convert(utf8.encode('$title$company')).toString();

  /// 由 sha256 哈希生成 Isar 可用的数字 Id。
  /// 取前 12 位十六进制（48 位，避免 int64 溢出），0 不是合法 Isar Id。
  static int stableIdFromHash(String hash) {
    if (hash.length < 12) {
      throw ArgumentError('哈希长度不足：$hash');
    }
    final id = int.parse(hash.substring(0, 12), radix: 16);
    return id == 0 ? 1 : id;
  }

  /// 截止日期标准化：从文本中提取 YYYY-MM-DD，找不到返回 null
  static String? normalizeDeadline(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    final m = RegExp(r'(\d{4})\s*[-/年.]\s*(\d{1,2})\s*[-/月.]\s*(\d{1,2})')
        .firstMatch(t);
    if (m == null) return null;
    final month = m.group(2)!.padLeft(2, '0');
    final day = m.group(3)!.padLeft(2, '0');
    return '${m.group(1)}-$month-$day';
  }

  /// 从卡片信息项文本推断城市（命中常见城市名即返回）
  static String _inferCity(List<String> infoTexts) {
    const knownCities = [
      '北京', '上海', '广州', '深圳', '杭州', '南京', '武汉', '成都',
      '西安', '苏州', '长沙', '郑州', '重庆', '合肥', '天津', '青岛',
      '厦门', '大连', '珠海', '无锡', '宁波', '济南', '福州', '东莞',
      '佛山', '南昌', '昆明', '长春', '沈阳', '哈尔滨', '石家庄', '太原',
      '南宁', '贵阳', '兰州', '乌鲁木齐', '呼和浩特', '海口', '三亚',
      '香港', '澳门', '台北', '全国', '远程',
    ];
    for (final text in infoTexts) {
      for (final city in knownCities) {
        if (text.contains(city)) return city;
      }
    }
    return '';
  }

  /// 从岗位标题 / JD 文本推断方向标签（未命中返回空串）。
  /// 职能类关键词（物流/供应链、运营、采购等）在前，技术类在后，
  /// 保证物流管理专业关注的岗位优先命中对应标签。
  static String inferDirection(String text) {
    const rules = <String, List<String>>{
      // 物流管理专业重点标签
      '物流/供应链': [
        '物流', '供应链', '仓储', '库存', '运输', '仓配', '履约', '供应链计划',
      ],
      '运营': ['运营', '用户增长', '活动策划', '社群'],
      '采购': ['采购', '寻源', '供应商管理'],
      '市场': ['市场', '营销', '品牌', '商务'],
      '财务': ['财务', '会计', '审计', '资金管理'],
      '人力': ['人力', 'HR', '招聘', '人事'],
      '产品': ['产品', 'PM'],
      '后端': ['后端', 'Java', 'Go', 'C++', 'PHP', 'Python开发', '服务端'],
      '前端': ['前端', 'Web', 'React', 'Vue', 'H5'],
      '客户端': ['客户端', 'Android', 'iOS', 'Flutter'],
      '算法': ['算法', '机器学习', '深度学习', 'AI', 'NLP', '推荐'],
      '数据': ['数据', '数据分析', '数据挖掘', 'BI'],
      '测试': ['测试', 'QA'],
      '运维': ['运维', 'SRE', 'DevOps', '安全'],
      '设计': ['设计', 'UI', 'UX'],
      '嵌入式': ['嵌入式', '硬件', '驱动'],
    };
    final lower = text.toLowerCase();
    for (final entry in rules.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword.toLowerCase())) return entry.key;
      }
    }
    return '';
  }

  /// JD 抓取完成后用 JD 文本补充打标签：
  /// - 标题已经识别出方向时不再覆盖（避免 JD 里的技术词覆盖职能标签）
  /// - 标题识别不出方向时，JD 命中关键词则自动补上标签
  static void _applyJdTag(JobPosting job) {
    if (job.direction.isNotEmpty) return;
    final tag = inferDirection(job.description);
    if (tag.isNotEmpty) job.direction = tag;
  }

  /// 聚焦过滤：只保留标题或 JD 命中 [ScrapeSiteConfig.focusKeywords] 的岗位。
  /// 若过滤后为空（当天列表没有目标岗位），保留全部岗位，避免页面空白。
  static List<JobPosting> _applyFocusFilter(
    List<JobPosting> jobs,
    ScrapeSiteConfig config,
  ) {
    final keywords = config.focusKeywords;
    if (keywords.isEmpty) return jobs;
    final focused = jobs
        .where((j) => keywords.any('${j.title}${j.description}'.contains))
        .toList();
    return focused.isNotEmpty ? focused : jobs;
  }

  /// 取选择器对应元素的文本（选择器为空/找不到返回空串）
  static String _textOf(dynamic element, String? selector) {
    if (selector == null || selector.isEmpty) return '';
    final found = element.querySelector(selector);
    if (found == null) return '';
    return _cleanText(found.text);
  }

  /// 清理网页文本（公开便于测试）：
  /// - 去除字体图标/私用区字符（U+E000–U+F8FF，如实习僧页面中的图标字体）
  /// - 去除零宽等不可见字符
  /// - [collapseWhitespace] 为 true 时把换行/连续空白压成单个空格（单行字段用）
  static String _cleanText(String raw, {bool collapseWhitespace = true}) {
    final sb = StringBuffer();
    for (final rune in raw.runes) {
      // 字体图标私用区字符（如实习僧的  类字符）
      if (rune >= 0xE000 && rune <= 0xF8FF) continue;
      // 零宽字符 / BOM
      if (rune == 0x200B ||
          rune == 0x200C ||
          rune == 0x200D ||
          rune == 0xFEFF) {
        continue;
      }
      // 控制字符（保留换行与制表）
      if (rune < 0x20 && rune != 0x0A && rune != 0x09) continue;
      sb.writeCharCode(rune);
    }
    var text = sb.toString();
    if (collapseWhitespace) {
      text = text.replaceAll(RegExp(r'\s+'), ' ');
    } else {
      // JD 保留换行，仅规整多余空行
      text = text
          .replaceAll(RegExp(r'[ \t]+\n'), '\n')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n');
    }
    return text.trim();
  }

  static String _firstNonEmpty(String value, String Function() fallback) =>
      value.isNotEmpty ? value : fallback();

  /// 把异常信息清理成简短提示
  static String _cleanError(Object e) {
    var msg = e.toString();
    if (msg.startsWith('Exception: ')) msg = msg.substring(11);
    // 网络异常信息可能很长，截断显示
    if (msg.length > 120) msg = '${msg.substring(0, 120)}…';
    return msg;
  }
}