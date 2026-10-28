import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../db/application_repo.dart';
import '../../db/job_repo.dart';
import '../../db/schemas/application_record.dart';
import '../../db/schemas/job_posting.dart';
import '../../services/notification_service.dart';
import '../profile/auto_fill_page.dart';

/// 岗位详情：公司/岗位/地点/方向/截止时间/描述/投递链接，
/// 支持收藏、截止日当天 09:00 的本地提醒开关、投递状态与备注。
class JobDetailPage extends StatefulWidget {
  const JobDetailPage({super.key, required this.job});

  final JobPosting job;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late JobPosting _job;
  var _saving = false;

  // 投递状态与备注（本机 Isar 存储）
  var _applyStatus = ApplyStatus.pending;
  final _noteCtrl = TextEditingController();
  var _applySaving = false;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
    _loadApplicationRecord();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  /// 读取该岗位已有的投递状态与备注
  Future<void> _loadApplicationRecord() async {
    try {
      final record = await ApplicationRepo.instance.getByJobId(_job.id);
      if (!mounted) return;
      setState(() {
        if (record != null) {
          _applyStatus = ApplyStatus
              .values[record.status.clamp(0, ApplyStatus.values.length - 1)];
          _noteCtrl.text = record.note;
        }
      });
    } catch (_) {
      // 数据库未就绪：保持默认值
    }
  }

  /// 保存投递状态与备注到本机 Isar
  Future<void> _saveApplication() async {
    if (_applySaving) return;
    setState(() => _applySaving = true);
    try {
      await ApplicationRepo.instance.upsert(
        jobId: _job.id,
        status: _applyStatus,
        note: _noteCtrl.text.trim(),
      );
      await _loadApplicationRecord();
      if (!mounted) return;
      _showTip('投递状态已保存（仅本机）');
    } catch (e) {
      if (!mounted) return;
      _showTip('保存失败：$e');
    } finally {
      if (mounted) setState(() => _applySaving = false);
    }
  }

  /// 切换收藏并保存到本地
  Future<void> _toggleFavorite() async {
    setState(() => _saving = true);
    try {
      await JobRepo.instance.toggleFavorite(_job);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// 开启/关闭截止提醒（本地通知，无云服务）
  Future<void> _toggleReminder(bool enable) async {
    if (enable) {
      final deadline = _job.deadline;
      final date = deadline == null ? null : DateTime.tryParse(deadline);
      if (date == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('该岗位没有有效的截止日期，无法设置提醒')),
        );
        return;
      }
      await NotificationService.instance.scheduleDeadlineReminder(
        jobId: _job.id,
        title: _job.title,
        company: _job.company,
        deadlineDate: date,
      );
    } else {
      await NotificationService.instance.cancelDeadlineReminder(_job.id);
    }
    _job.reminderEnabled = enable;
    await JobRepo.instance.save(_job);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 所有文本字段都经过空值兜底：抓取的岗位可能存在空 JD / 空字段，
    // 渲染时绝不能因为空数据抛异常（避免红屏）
    final company = _safe(_job.company, '未知公司');
    final title = _safe(_job.title, '未知岗位');
    final city = _safe(_job.city, '未知城市');
    final direction = _safe(_job.direction, '未分类');
    final deadlineText = _safe(_job.deadline, '未知');
    final description = _safe(_job.description, '暂无岗位详细描述');
    final applyUrl = _safe(_job.applyUrl, '（无链接）');

    return Scaffold(
      appBar: AppBar(title: const Text('岗位详情')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(company, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(theme, Icons.location_on_outlined, city),
              _infoChip(theme, Icons.category_outlined, direction),
              _infoChip(
                theme,
                Icons.event_outlined,
                '截止：$deadlineText',
                urgent: _isUrgent(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 收藏 + 提醒设置（用 Wrap 防止窄窗口下溢出）
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _actionButton(
                icon: _job.isFavorite ? Icons.star : Icons.star_border,
                label: _job.isFavorite ? '已收藏' : '收藏',
                filled: _job.isFavorite,
                onPressed: _saving ? null : _toggleFavorite,
              ),
              if (_job.deadline != null && _job.deadline!.isNotEmpty)
                _actionButton(
                  icon: _job.reminderEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  label: _job.reminderEnabled ? '提醒已开启' : '开启截止提醒',
                  filled: _job.reminderEnabled,
                  onPressed:
                      _saving ? null : () => _toggleReminder(!_job.reminderEnabled),
                ),
            ],
          ),
          if (_job.reminderEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '将在截止当日 09:00 本地提醒，可手动关闭',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          const SizedBox(height: 20),
          // 投递进度：状态 + 备注（仅本机 Isar 存储）
          Text('投递进度', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: const InputDecoration(
              labelText: '投递状态',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ApplyStatus>(
                value: _applyStatus,
                isExpanded: true,
                items: [
                  for (final status in ApplyStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(applyStatusLabels[status] ?? ''),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _applyStatus = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '备注',
              hintText: '如：已投递简历等待笔试 / 面试时间 11-05',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: _applySaving ? null : _saveApplication,
              icon: Icon(_applySaving ? Icons.hourglass_top : Icons.save),
              label: Text(_applySaving ? '保存中…' : '保存投递状态'),
            ),
          ),
          const SizedBox(height: 20),
          Text('岗位描述', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          // 完整 JD（空时显示友好提示；可选中复制）
          SelectableText(
            description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Text('投递链接', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(
            applyUrl,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 12),
          // 投递操作：系统浏览器打开 + 网申自动填表（手机端）
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _openApplyUrl,
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('打开投递页面'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AutoFillPage(job: _job),
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('自动填表'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 打开投递链接：用系统默认浏览器打开。
  /// （内嵌 WebView 在 macOS 渲染器上会触发 opaque 报错导致红屏，已移除）
  /// 空链接 / 非法链接 / 打开失败都只弹轻提示，绝不崩溃。
  Future<void> _openApplyUrl() async {
    final url = _job.applyUrl.trim();
    if (url.isEmpty) {
      _showTip('暂无投递链接');
      return;
    }
    // 只允许 http/https，避免非法 scheme 触发平台异常
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showTip('无法打开投递链接');
      return;
    }
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) _showTip('无法打开投递链接');
    } catch (_) {
      // 设备没有可用浏览器等异常：兜底提示，不向上抛出
      _showTip('无法打开投递链接');
    }
  }

  /// 轻提示（Toast 风格浮层，2 秒自动消失）
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

  /// 安全取文本：null 或空白时返回兜底文案，保证渲染不抛异常
  static String _safe(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  /// 截止日期是否在 7 天内（用于红色高亮）
  bool _isUrgent() {
    final d = _job.deadline;
    final date = d == null ? null : DateTime.tryParse(d);
    if (date == null) return false;
    final diff = date.difference(DateTime.now()).inDays;
    return diff >= 0 && diff <= 7;
  }

  Widget _infoChip(ThemeData theme, IconData icon, String text,
      {bool urgent = false}) {
    final color =
        urgent ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.labelMedium?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required bool filled,
    required VoidCallback? onPressed,
  }) {
    return filled
        ? FilledButton.tonalIcon(
            onPressed: onPressed, icon: Icon(icon), label: Text(label))
        : OutlinedButton.icon(
            onPressed: onPressed, icon: Icon(icon), label: Text(label));
  }
}