import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../db/personal_profile_repo.dart';
import '../../db/schemas/job_posting.dart';
import '../../db/schemas/personal_profile.dart';
import '../../services/autofill_scripts.dart';
import '../../services/js_result_parser.dart';

/// 网申自动填表页：
/// 打开岗位投递页并注入 JS，用本机保存的个人信息自动填写网申表单。
///
/// 平台说明：内嵌 WebView 在 macOS 桌面渲染器上会崩溃，因此仅
/// Android/iOS（含 iPhone 真机）启用自动填表；桌面端显示引导提示并提供
/// “用系统浏览器打开”，全程不会创建 WebViewController，保证 App 不崩溃。
class AutoFillPage extends StatefulWidget {
  const AutoFillPage({super.key, required this.job});

  final JobPosting job;

  @override
  State<AutoFillPage> createState() => _AutoFillPageState();
}

class _AutoFillPageState extends State<AutoFillPage> {
  /// WebView 控制器（仅手机端创建；桌面端保持 null）
  WebViewController? _controller;

  PersonalProfile? _profile;
  var _loading = true;
  var _autoFilling = false;

  /// 状态提示（自动填表结果 / 引导文案）
  String? _status;

  /// 桌面端不支持内嵌 WebView
  bool get _isDesktop => !(Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 读取本机保存的个人信息
    try {
      _profile = await PersonalProfileRepo.instance.get();
    } catch (_) {
      _profile = null;
    }
    if (!mounted) return;

    if (!_isDesktop) {
      _initWebView();
    }
    setState(() => _loading = false);
  }

  /// 初始化 WebView 并加载投递页（仅手机端）
  void _initWebView() {
    final url = widget.job.applyUrl.trim();
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      setState(() => _status = '投递链接无效，请手动填写');
      return;
    }
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => _autoFill(),
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) return;
            if (!mounted) return;
            setState(() => _status = '页面加载失败，请手动填写或重试');
          },
        ),
      )
      ..loadRequest(uri);
    setState(() => _controller = controller);
  }

  /// 注入 JS 自动填充个人信息
  Future<void> _autoFill() async {
    final controller = _controller;
    if (controller == null) return;
    final profile = _profile;
    if (profile == null ||
        (profile.name.isEmpty &&
            profile.phone.isEmpty &&
            profile.email.isEmpty)) {
      setState(() => _status = '还没有填写个人信息，请先到「我的」页保存');
      return;
    }

    setState(() => _autoFilling = true);
    try {
      final json = jsonEncode({
        'name': profile.name,
        'phone': profile.phone,
        'email': profile.email,
        'school': profile.school,
        'major': profile.major,
        'grade': profile.grade,
        'education': profile.education,
        'intendedCity': profile.intendedCity,
        'availableTime': profile.availableTime,
      });
      final result = await controller.runJavaScriptReturningResult(
        AutoFillScripts.fill(json),
      );
      final filled = JsResultParser.parseFilledCount(result);

      // 页面候选输入框数量（用于区分“没识别到字段”和“页面没有表单”）
      var candidates = 0;
      try {
        final countRes = await controller.runJavaScriptReturningResult(
          AutoFillScripts.countInputs,
        );
        candidates = int.tryParse(JsResultParser.toCleanString(countRes)) ?? 0;
      } catch (_) {
        candidates = 0;
      }

      final String message;
      if (filled > 0) {
        message = '已自动填充 $filled 项，请手动上传简历 PDF 后提交';
      } else if (candidates > 0) {
        message = '未能识别表单字段，请手动填写';
      } else {
        message = '当前页面没有可填写表单，请手动操作';
      }
      if (!mounted) return;
      setState(() => _status = message);
      _showTip(message);
    } catch (_) {
      // 注入失败兜底：提示手动填写，绝不崩溃
      if (!mounted) return;
      setState(() => _status = '自动填表失败，请手动填写');
      _showTip('自动填表失败，请手动填写');
    } finally {
      if (mounted) setState(() => _autoFilling = false);
    }
  }

  /// 用系统浏览器打开投递页（桌面端备用）
  Future<void> _openInBrowser() async {
    final url = widget.job.applyUrl.trim();
    if (url.isEmpty) {
      _showTip('暂无投递链接');
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showTip('无法打开投递链接');
      return;
    }
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) _showTip('无法打开投递链接');
    } catch (_) {
      _showTip('无法打开投递链接');
    }
  }

  void _showTip(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('网申自动填表')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isDesktop
              ? _buildDesktopGuide(theme)
              : _buildWebViewBody(theme),
    );
  }

  /// 桌面端引导：不创建 WebView，避免 macOS 渲染器崩溃
  Widget _buildDesktopGuide(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_iphone, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('自动填表请在手机端使用', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '内嵌浏览器在 macOS 桌面端不受支持，已自动降级为系统浏览器打开投递页。\n'
              '在 Android / iPhone 上可使用网申自动填表（无需登录云服务，信息只在本机）。',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(_status!, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('用系统浏览器打开投递页'),
            ),
          ],
        ),
      ),
    );
  }

  /// 手机端 WebView + 状态条 + 底部操作栏
  Widget _buildWebViewBody(ThemeData theme) {
    final controller = _controller;
    if (controller == null) {
      // 链接无效等情况：提示手动操作
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(_status ?? '页面无法打开，请手动填写',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openInBrowser,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('用系统浏览器打开投递页'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_status != null)
          Container(
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(_status!, style: theme.textTheme.bodySmall),
          ),
        Expanded(child: WebViewWidget(controller: controller)),
        Material(
          color: theme.colorScheme.surfaceContainer,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _autoFilling ? null : _autoFill,
                      icon: _autoFilling
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_fix_high),
                      label: const Text('重新自动填充'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openInBrowser,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('系统浏览器'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}