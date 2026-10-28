import 'package:flutter/material.dart';

import '../../db/application_repo.dart';
import '../../db/job_repo.dart';
import '../../db/schemas/application_record.dart';
import '../../db/schemas/job_posting.dart';
import '../../services/multi_platform_scraper.dart';
import '../jobs/job_detail_page.dart';

/// 投递台账：汇总全部带投递状态标记的岗位。
/// 支持按平台 / 投递状态 / 时间筛选，可直接跳转岗位详情。
/// 全部数据来自本机 Isar，不触发爬虫。
class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  List<({JobPosting job, ApplicationRecord record})>? _entries;
  bool _dbError = false;

  // 筛选条件（空集合 = 不限）
  Set<String> _platforms = {};
  Set<ApplyStatus> _statuses = {};

  /// 0=全部 1=最近7天 2=最近30天
  int _timeRange = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final records = await ApplicationRepo.instance.getAll();
      final jobs = await JobRepo.instance.query();
      final jobMap = {for (final j in jobs) j.id: j};
      var entries = <({JobPosting job, ApplicationRecord record})>[];
      for (final record in records) {
        final job = jobMap[record.jobId];
        if (job != null) {
          entries.add((job: job, record: record));
        }
      }
      // 平台筛选
      if (_platforms.isNotEmpty) {
        entries =
            entries.where((e) => _platforms.contains(e.job.source)).toList();
      }
      // 投递状态筛选
      if (_statuses.isNotEmpty) {
        entries = entries.where((e) {
          final status = ApplyStatus.values[
              e.record.status.clamp(0, ApplyStatus.values.length - 1)];
          return _statuses.contains(status);
        }).toList();
      }
      // 时间筛选（按状态更新时间）
      if (_timeRange > 0) {
        final cutoff = DateTime.now()
            .subtract(Duration(days: _timeRange == 1 ? 7 : 30));
        entries =
            entries.where((e) => e.record.updatedAt.isAfter(cutoff)).toList();
      }
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _dbError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _dbError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('投递台账'),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: _dbError
          ? const Center(child: Text('本地数据库未就绪，请重启应用后再试。'))
          : _entries == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildFilters(theme),
                    Expanded(child: _buildList(theme)),
                  ],
                ),
    );
  }

  /// 筛选区：平台 / 投递状态 / 时间
  Widget _buildFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('平台', style: theme.textTheme.labelSmall),
          Wrap(
            spacing: 6,
            children: [
              ChoiceChip(
                label: const Text('全部'),
                selected: _platforms.isEmpty,
                onSelected: (_) => setState(() {
                  _platforms = {};
                  _load();
                }),
              ),
              for (final key in MultiPlatformScraper.allPlatformKeys)
                ChoiceChip(
                  label: Text(MultiPlatformScraper.labelOf(key)),
                  selected: _platforms.contains(key),
                  onSelected: (selected) => setState(() {
                    final next = {..._platforms};
                    selected ? next.add(key) : next.remove(key);
                    _platforms = next;
                    _load();
                  }),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('投递状态', style: theme.textTheme.labelSmall),
          Wrap(
            spacing: 6,
            children: [
              ChoiceChip(
                label: const Text('全部'),
                selected: _statuses.isEmpty,
                onSelected: (_) => setState(() {
                  _statuses = {};
                  _load();
                }),
              ),
              for (final status in ApplyStatus.values)
                ChoiceChip(
                  label: Text(applyStatusLabels[status] ?? ''),
                  selected: _statuses.contains(status),
                  onSelected: (selected) => setState(() {
                    final next = {..._statuses};
                    selected ? next.add(status) : next.remove(status);
                    _statuses = next;
                    _load();
                  }),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('时间', style: theme.textTheme.labelSmall),
          Wrap(
            spacing: 6,
            children: [
              for (final (value, label) in const [
                (0, '全部时间'),
                (1, '最近 7 天'),
                (2, '最近 30 天'),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _timeRange == value,
                  onSelected: (_) => setState(() {
                    _timeRange = value;
                    _load();
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme) {
    final entries = _entries!;
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '暂无投递记录。\n进入岗位详情页设置投递状态后，这里会汇总展示。',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        final status = ApplyStatus.values[
            entry.record.status.clamp(0, ApplyStatus.values.length - 1)];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              '${entry.job.company} · ${entry.job.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${MultiPlatformScraper.labelOf(entry.job.source)} · '
                  '${entry.job.city.isEmpty ? '未知城市' : entry.job.city} · '
                  '更新于 ${_formatTime(entry.record.updatedAt)}',
                  style: theme.textTheme.bodySmall,
                ),
                if (entry.record.note.isNotEmpty)
                  Text(
                    '备注：${entry.record.note}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
            trailing: _statusChip(theme, status),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JobDetailPage(job: entry.job),
                ),
              );
              await _load();
            },
          ),
        );
      },
    );
  }

  /// 投递状态标签（颜色区分）
  Widget _statusChip(ThemeData theme, ApplyStatus status) {
    final color = switch (status) {
      ApplyStatus.pending => theme.colorScheme.onSurfaceVariant,
      ApplyStatus.submitted => theme.colorScheme.primary,
      ApplyStatus.interviewing => theme.colorScheme.tertiary,
      ApplyStatus.rejected => theme.colorScheme.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        applyStatusLabels[status] ?? '',
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }

  String _formatTime(DateTime time) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${time.month}-${two(time.day)} '
        '${two(time.hour)}:${two(time.minute)}';
  }
}