import '../db/app_setting_repo.dart';
import '../db/schemas/job_posting.dart';
import 'job_scraper.dart';

/// 多平台抓取结果
class MultiScrapeResult {
  const MultiScrapeResult({required this.jobs, required this.platformErrors});

  /// 合并后的岗位（写入 Isar 时按稳定 Id 去重）
  final List<JobPosting> jobs;

  /// 平台 key → 错误信息（仅记录真正发起抓取失败的平台）
  final Map<String, String> platformErrors;

  bool get success => platformErrors.isEmpty;
  bool get hasJobs => jobs.isNotEmpty;
}

/// 多招聘平台抓取编排：牛客 / 实习僧 / BOSS直聘。
///
/// - 每个平台使用独立的 [JobScraper] 实例 → 各自 30 分钟节流计时互不影响
/// - 平台间串行抓取（降低并发请求量，减少网站风控风险）
/// - 单平台失败只记录错误、不中断其他平台，保证 App 不崩溃
class MultiPlatformScraper {
  MultiPlatformScraper._()
      : _scrapers = [
          JobScraper(), // 牛客
          JobScraper(config: ScrapeSiteConfig.shixiseng), // 实习僧
          JobScraper(config: ScrapeSiteConfig.boss), // BOSS直聘
        ];

  /// 测试用构造：注入 mock 抓取器
  MultiPlatformScraper.withScrapers(this._scrapers);

  /// 页面使用的单例（可变：测试中可替换避免真实网络请求）
  static MultiPlatformScraper instance = MultiPlatformScraper._();

  /// 各平台独立抓取实例
  final List<JobScraper> _scrapers;

  /// 平台 key → 中文名（岗位卡片标记 / 筛选按钮）
  static const platformLabels = <String, String>{
    'nowcoder': '牛客',
    'shixiseng': '实习僧',
    'boss': 'BOSS直聘',
  };

  /// 筛选面板展示的平台顺序
  static const allPlatformKeys = ['nowcoder', 'shixiseng', 'boss'];

  /// 来源平台中文名；未知来源（如本地 JSON 导入）返回「导入」
  static String labelOf(String source) => platformLabels[source] ?? '导入';

  /// 抓取全部平台（串行，失败隔离）
  Future<MultiScrapeResult> fetchAll() async {
    final jobs = <JobPosting>[];
    final errors = <String, String>{};

    // 读取本机保存的 BOSS直聘 Cookie（导入后随请求发送；仅本机 Isar）
    String bossCookie = '';
    try {
      bossCookie = (await AppSettingRepo.instance.get()).bossCookie;
    } catch (_) {
      // 数据库未就绪（测试环境）时忽略
    }

    for (final scraper in _scrapers) {
      final name = scraper.config.name;
      // BOSS直聘需要登录 Cookie 才有机会绕过安全验证页
      if (name == 'boss') {
        scraper.setCookie(bossCookie);
      }
      try {
        final result = await scraper.fetchJobs();
        if (result.success) {
          jobs.addAll(result.jobs);
        } else if (!result.fromThrottle) {
          // 节流窗口内的“跳过”不算失败，避免误导用户
          final baseError = result.error ?? '抓取失败';
          errors[name] = (name == 'boss' && bossCookie.isNotEmpty)
              ? '$baseError（登录 Cookie 可能已失效，请到设置页重新导入）'
              : baseError;
        }
      } catch (e) {
        // 单平台异常隔离：记录后继续其他平台
        errors[name] = '$e';
      }
    }

    return MultiScrapeResult(jobs: jobs, platformErrors: errors);
  }
}