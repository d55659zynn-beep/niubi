import 'dart:io';

import 'package:html/parser.dart' as html_parser;

/// 无头浏览器 JD 抓取器（桌面端）。
///
/// 实习僧岗位详情页的 JD 是前端动态渲染（Nuxt 客户端渲染），
/// 纯 HTTP 抓取 SSR 页面拿不到 JD 正文。桌面端（macOS/Windows/Linux）
/// 通过调用本机 Chrome / Edge / Chromium 的 headless 模式渲染页面
/// （`--headless --dump-dom`），再从渲染后的 DOM 中提取 JD。
///
/// 移动端（iOS/Android）没有系统浏览器命令行，[available] 返回 false，
/// 由上层保持“JD 为空串 + 详情页暂无描述”的兜底逻辑，App 不崩溃。
class HeadlessJdFetcher {
  HeadlessJdFetcher._();
  static final HeadlessJdFetcher instance = HeadlessJdFetcher._();

  /// 单次渲染超时（毫秒级保护，避免 Chrome 卡死拖垮抓取）
  static const renderTimeout = Duration(seconds: 45);

  /// 是否桌面端（具备无头浏览器条件）
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  static const _browserUserAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
      'AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/126.0.0.0 Safari/537.36';

  String? _browserPath;
  bool _detected = false;

  /// 是否启用了无头浏览器（单元测试中可通过此开关关闭，避免真实启动浏览器）
  static bool enabled = true;

  /// 检测本机可用的无头浏览器（结果缓存）
  String? _findBrowser() {
    if (_detected) return _browserPath;
    _detected = true;
    if (!isDesktop || !enabled) return null;
    // flutter test 环境不启动真实浏览器（避免测试挂起）
    if (Platform.environment['FLUTTER_TEST'] == 'true') return null;

    final candidates = <String>[];
    if (Platform.isMacOS) {
      candidates.addAll(const [
        '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
        '/Applications/GoogleChrome.app/Contents/MacOS/Google Chrome',
        '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',
        '/Applications/Chromium.app/Contents/MacOS/Chromium',
      ]);
      // 兼容非标准安装路径/重命名：扫描 /Applications 下 Chrome/Edge/Chromium 应用
      candidates.addAll(_scanMacApplications());
    } else if (Platform.isWindows) {
      final programFiles =
          Platform.environment['PROGRAMFILES'] ?? r'C:\Program Files';
      final programFilesX86 =
          Platform.environment['PROGRAMFILES(X86)'] ?? r'C:\Program Files (x86)';
      final localAppData = Platform.environment['LOCALAPPDATA'] ?? '';
      candidates.addAll([
        '$programFiles\\Google\\Chrome\\Application\\chrome.exe',
        '$programFilesX86\\Google\\Chrome\\Application\\chrome.exe',
        '$programFiles\\Microsoft\\Edge\\Application\\msedge.exe',
        '$localAppData\\Google\\Chrome\\Application\\chrome.exe',
      ]);
    } else {
      candidates.addAll(const [
        '/usr/bin/google-chrome',
        '/usr/bin/chromium',
        '/usr/bin/chromium-browser',
      ]);
    }

    for (final path in candidates) {
      if (File(path).existsSync()) {
        _browserPath = path;
        return path;
      }
    }
    _browserPath = null;
    return null;
  }

  /// 扫描 /Applications 下的 Chrome / Edge / Chromium 可执行文件
  /// （兼容 GoogleChrome.app 这类非标准命名或自定义安装位置）
  static List<String> _scanMacApplications() {
    final result = <String>[];
    try {
      final appsDir = Directory('/Applications');
      if (!appsDir.existsSync()) return result;
      for (final entity in appsDir.listSync()) {
        final appName = entity.path.split('/').last.toLowerCase();
        if (!appName.contains('chrome') &&
            !appName.contains('edge') &&
            !appName.contains('chromium')) {
          continue;
        }
        final macosDir = Directory('${entity.path}/Contents/MacOS');
        if (!macosDir.existsSync()) continue;
        for (final exe in macosDir.listSync()) {
          final exeName = exe.path.split('/').last.toLowerCase();
          if (exeName.contains('chrome') ||
              exeName.contains('edge') ||
              exeName.contains('chromium')) {
            result.add(exe.path);
          }
        }
      }
    } catch (_) {
      // 扫描失败不影响后续兜底
    }
    return result;
  }

  /// 无头浏览器是否可用（桌面端且检测到 Chrome/Edge/Chromium）
  bool get available => _findBrowser() != null;

  /// 用无头浏览器渲染页面，返回渲染后的完整 HTML。
  /// 不可用 / 超时 / 失败均返回 null（上层按空 JD 兜底）。
  Future<String?> fetchRenderedHtml(String url) async {
    final browser = _findBrowser();
    if (browser == null) return null;
    try {
      // 独立临时 profile：避免读取用户浏览器数据导致启动缓慢/冲突
      final tempProfile =
          Directory.systemTemp.createTempSync('ws_headless_');
      try {
        final result = await Process.run(
          browser,
          [
            '--headless',
            '--disable-gpu',
            '--no-sandbox',
            '--disable-dev-shm-usage',
            '--no-first-run',
            '--no-default-browser-check',
            '--disable-background-networking',
            '--disable-extensions',
            '--disable-sync',
            '--user-data-dir=${tempProfile.path}',
            '--dump-dom',
            '--virtual-time-budget=6000',
            '--user-agent=$_browserUserAgent',
            url,
          ],
          stdoutEncoding: const SystemEncoding(),
          stderrEncoding: const SystemEncoding(),
        ).timeout(renderTimeout);
        if (result.exitCode != 0) return null;
        final html = result.stdout.toString();
        return html.isEmpty ? null : html;
      } finally {
        // 清理临时 profile，避免残留
        try {
          tempProfile.deleteSync(recursive: true);
        } catch (_) {}
      }
    } catch (_) {
      // 浏览器缺失/超时/权限等异常：返回 null，由上层兜底
      return null;
    }
  }

  /// 从渲染后的 HTML 中按 CSS 选择器提取 JD 文本（多元素按空行拼接）
  static String? extractDescription(String html, String selector) {
    try {
      final document = html_parser.parse(html);
      final parts = document
          .querySelectorAll(selector)
          .map((e) => e.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      if (parts.isEmpty) return null;
      return parts.join('\n\n');
    } catch (_) {
      return null;
    }
  }
}