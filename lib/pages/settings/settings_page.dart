import 'package:flutter/material.dart';

import '../../db/app_setting_repo.dart';
import '../../services/job_monitor_service.dart';
import '../../services/multi_platform_scraper.dart';

/// 设置页：岗位更新推送开关、BOSS直聘 Cookie 导入。
/// 所有数据仅保存在本机 Isar 数据库，不上传外部服务器。
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _cookieCtrl;
  var _loading = true;
  var _pushEnabled = false;
  var _checking = false;
  String? _cookieUpdatedAt;

  @override
  void initState() {
    super.initState();
    _cookieCtrl = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _cookieCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final setting = await AppSettingRepo.instance.get();
      _pushEnabled = setting.pushEnabled;
      _cookieCtrl.text = setting.bossCookie;
      _cookieUpdatedAt = _formatTime(setting.bossCookieUpdatedAt);
    } catch (_) {
      // 数据库未就绪：保持默认值
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  String? _formatTime(DateTime? time) {
    if (time == null) return null;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${time.year}-${two(time.month)}-${two(time.day)} '
        '${two(time.hour)}:${two(time.minute)}';
  }

  Future<void> _togglePush(bool enabled) async {
    setState(() => _pushEnabled = enabled);
    try {
      await AppSettingRepo.instance.setPushEnabled(enabled);
      await JobMonitorService.instance.refresh();
      if (!mounted) return;
      _showTip(enabled ? '已开启岗位更新推送（每 30 分钟检查一次）' : '已关闭岗位更新推送');
    } catch (e) {
      if (!mounted) return;
      _showTip('保存失败：$e');
    }
  }

  /// 立即检查一次新岗位（手动触发；受平台 30 分钟节流保护）
  Future<void> _checkNow() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      final added = await JobMonitorService.instance.checkAndNotify();
      if (!mounted) return;
      _showTip(added > 0 ? '发现 $added 个新岗位（已发送通知）' : '暂无新岗位');
    } catch (e) {
      if (!mounted) return;
      _showTip('检查失败：$e');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _saveCookie() async {
    try {
      await AppSettingRepo.instance.setBossCookie(_cookieCtrl.text);
      await _load();
      if (!mounted) return;
      _showTip(_cookieCtrl.text.trim().isEmpty
          ? '已清除 BOSS直聘 Cookie'
          : 'Cookie 已保存到本机（仅本地使用，不会上传）');
    } catch (e) {
      if (!mounted) return;
      _showTip('保存失败：$e');
    }
  }

  Future<void> _clearCookie() async {
    _cookieCtrl.clear();
    await _saveCookie();
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
      appBar: AppBar(title: const Text('设置')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 隐私说明
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '本页全部数据仅保存在本机 Isar 数据库，不会上传任何服务器。',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('岗位推送提醒', style: theme.textTheme.titleSmall),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('开启岗位更新推送'),
                        subtitle: const Text(
                          '每 30 分钟静默检查一次新岗位（受各平台节流限制），'
                          '发现新岗位时发送本地通知',
                        ),
                        value: _pushEnabled,
                        onChanged: _togglePush,
                      ),
                      ListTile(
                        leading: const Icon(Icons.refresh),
                        title: const Text('立即检查新岗位'),
                        subtitle: const Text('手动触发一次（30 分钟内不会重复请求网页）'),
                        trailing: _checking
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.chevron_right),
                        onTap: _checking ? null : _checkNow,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('BOSS直聘登录 Cookie', style: theme.textTheme.titleSmall),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOSS直聘需要登录 Cookie 才能绕过安全验证页。'
                          '获取方式：浏览器登录 zhipin.com 后，在开发者工具 → Network '
                          '中复制请求头里的 Cookie 值，粘贴到下方。'
                          'Cookie 仅保存在本机 Isar，不上传。',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _cookieCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Cookie',
                            hintText: '粘贴 BOSS直聘 登录 Cookie（如 __zp_stoken__=...；）',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        if (_cookieUpdatedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '最近导入：$_cookieUpdatedAt',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _clearCookie,
                              child: const Text('清除'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: _saveCookie,
                              icon: const Icon(Icons.save),
                              label: const Text('保存 Cookie'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '说明：BOSS直聘有较强反爬与浏览器指纹校验，'
                      'Cookie 有效时可能仍被拦截；失败时 App 会弹窗提示且不影响'
                      '${MultiPlatformScraper.labelOf('nowcoder')}、'
                      '${MultiPlatformScraper.labelOf('shixiseng')}的正常抓取。',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}