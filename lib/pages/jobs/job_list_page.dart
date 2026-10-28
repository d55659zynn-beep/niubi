import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../db/application_repo.dart';
import '../../db/job_repo.dart';
import '../../db/schemas/application_record.dart';
import '../../db/schemas/job_posting.dart';
import '../../services/csv_exporter.dart';
import '../../services/job_filter.dart';
import '../../services/multi_platform_scraper.dart';
import '../../services/notification_service.dart';
import 'job_detail_page.dart';

/// 岗位列表：进入页面自动抓取多平台岗位（牛客/实习僧/BOSS直聘，各自 30 分钟
/// 节流）、JSON 导入、下拉刷新、筛选（平台/城市/方向/截止时间/实习生专区）、
/// 关键词搜索、收藏切换。抓取失败时降级展示 Isar 本地缓存，不出现空白页面。
class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => JobListPageState();
}

class JobListPageState extends State<JobListPage> {
  List<JobPosting>? _jobs;
  bool _dbError = false;
  var _importing = false;

  // 网页抓取同步状态
  var _syncing = false;
  var _syncFailed = false;
  String? _syncError;

  // 当前筛选条件
  String? _city;
  String? _direction;
  DeadlineFilter _deadline = DeadlineFilter.all;
  bool _favoriteOnly = false;

  // 招聘平台多选筛选（空集合 = 不限平台）
  Set<String> _sources = {};

  // 投递记录（jobId → 记录），用于卡片状态标记与状态筛选
  Map<int, ApplicationRecord> _records = {};

  // 投递状态多选筛选（空集合 = 不限状态）
  Set<ApplyStatus> _statusFilter = {};

  // 实习生专区开关（仅本地过滤全职岗位）
  bool _internOnly = false;

  // 关键词搜索（仅本地过滤，不触发新爬虫请求）
  final _searchCtrl = TextEditingController();
  var _searchQuery = '';
  Timer? _searchDebounce;

  /// 预设岗位方向标签：物流管理专业常用 + 原有技术方向
  static const presetDirections = [
    '物流/供应链', '运营', '采购', '市场', '财务', '人力',
    '产品', '后端', '嵌入式', '算法',
  ];

  /// 预设城市选项：原有城市 + 新增城市
  static const presetCities = [
    '北京', '上海', '广州', '深圳', '杭州',
    '成都', '武汉', '南京', '苏州', '东莞', '西安',
  ];

  @override
  void initState() {
    super.initState();
    // 先读本地缓存（快速出内容），再触发网页同步抓取
    _load();
    _syncJobs();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  /// 由 HomeShell 在切回岗位 Tab 时调用：
  /// 触发同步（30 分钟内由 JobScraper 节流兜底，不会重复请求网页）
  Future<void> onTabActivated() => _syncJobs();

  /// 按当前筛选条件从本地 Isar 加载岗位。
  /// 城市/方向/截止走 Isar 查询；平台/实习生/关键词/投递状态在本地内存过滤，
  /// 不触发任何网络请求（遵守 30 分钟抓取节流）。
  Future<void> _load() async {
    try {
      final list = await JobRepo.instance.query(
        city: _city,
        direction: _direction,
        deadline: _deadline,
        isFavorite: _favoriteOnly ? true : null,
      );
      // 投递记录（仅本地缓存，不触发抓取）
      Map<int, ApplicationRecord> records = {};
      try {
        records = await ApplicationRepo.instance.getAllMap();
      } catch (_) {
        records = {};
      }
      if (!mounted) return;
      setState(() {
        _records = records;
        _jobs = _applyLocalFilters(list);
        _dbError = false;
      });
    } catch (_) {
      // 数据库未就绪（如测试环境未初始化）时显示提示，避免崩溃
      if (!mounted) return;
      setState(() => _dbError = true);
    }
  }

  /// 本地过滤：招聘平台多选 + 实习生专区开关 + 关键词搜索 + 投递状态。
  /// 平台/实习生/关键词逻辑在 [JobFilter] 中实现；投递状态需要关联本地记录。
  List<JobPosting> _applyLocalFilters(List<JobPosting> list) {
    var result = JobFilter.apply(
      list,
      internOnly: _internOnly,
      keyword: _searchQuery,
      sources: _sources,
    );
    // 投递状态筛选：未标记投递状态的岗位在状态筛选下不展示
    if (_statusFilter.isNotEmpty) {
      result = result.where((job) {
        final record = _records[job.id];
        if (record == null) return false;
        final status = ApplyStatus.values[
            record.status.clamp(0, ApplyStatus.values.length - 1)];
        return _statusFilter.contains(status);
      }).toList();
    }
    return result;
  }

  /// 关键词输入：立即更新清除按钮状态，防抖后执行本地过滤
  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _load();
    });
  }

  /// 清空搜索
  void _clearSearch() {
    _searchCtrl.clear();
    _searchDebounce?.cancel();
    setState(() => _searchQuery = '');
    _load();
  }

  /// 同步多平台网页岗位（进入页面 / 下拉刷新 / 切回 Tab 时触发）：
  /// - 每个平台独立 30 分钟节流（由各自 JobScraper 实例保证）
  /// - 抓取成功：合并写入 Isar（相同岗位按稳定 Id 覆盖更新）
  /// - 单平台失败：弹窗提示该平台，不中断其他平台；本地缓存照常展示
  Future<void> _syncJobs() async {
    if (_syncing) return;
    setState(() {
      _syncing = true;
      _syncFailed = false;
    });

    try {
      final result = await MultiPlatformScraper.instance.fetchAll();
      if (!mounted) return;

      // 合并结果写入 Isar（幂等：同 Id 覆盖更新）
      if (result.hasJobs) {
        await JobRepo.instance.saveScraped(result.jobs);
        if (!mounted) return;
      }

      if (result.platformErrors.isEmpty) {
        setState(() {
          _syncing = false;
          _syncFailed = false;
          _syncError = null;
        });
      } else {
        // 单平台失败：仅提示失败平台，其他平台数据正常展示
        final summary = result.platformErrors.entries
            .map((e) =>
                '${MultiPlatformScraper.labelOf(e.key)}：${e.value}')
            .join('；');
        setState(() {
          _syncing = false;
          _syncFailed = true;
          _syncError = summary;
        });
        _showPlatformErrorDialog(result.platformErrors);
      }
      await _load();
    } catch (e) {
      // 兜底：写库/解析等意外异常不崩溃，降级展示本地缓存
      if (!mounted) return;
      setState(() {
        _syncing = false;
        _syncFailed = true;
        _syncError = '$e';
      });
      await _load();
    }
  }

  /// 单平台抓取失败弹窗提示（不中断其他平台）
  void _showPlatformErrorDialog(Map<String, String> errors) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('部分平台抓取失败'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in errors.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '${MultiPlatformScraper.labelOf(entry.key)}：${entry.value}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              '其他平台数据已正常更新，可在本地缓存中继续浏览。',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  /// 选择本机 JSON 文件导入岗位
  Future<void> _importJson() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = files.isEmpty ? null : files.first.path;
    if (path == null || !mounted) return;

    setState(() => _importing = true);
    try {
      final result = await JobRepo.instance.importJsonFile(path);
      // 截止日期变化的已提醒岗位：取消旧通知，避免在旧日期误提醒
      for (final id in result.reminderResetIds) {
        await NotificationService.instance.cancelDeadlineReminder(id);
      }
      if (!mounted) return;
      final resetTip = result.reminderResetIds.isEmpty
          ? ''
          : '；${result.reminderResetIds.length} 个岗位截止日期已变，提醒已重置';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('导入完成：新增 ${result.added} 条，更新 ${result.updated} 条$resetTip'),
        ),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败：$e')),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  /// 打开筛选面板（招聘平台 / 实习生专区 / 城市 / 方向 / 截止时间 / 投递状态）
  Future<void> _openFilter() async {
    final dataCities = await JobRepo.instance.distinctCities();
    final dataDirections = await JobRepo.instance.distinctDirections();
    if (!mounted) return;
    // 固定选项在前，本地数据中出现的其他城市/方向补充在后
    final cities = <String>[
      ...presetCities,
      ...dataCities.where((c) => !presetCities.contains(c)),
    ];
    final directions = <String>[
      ...presetDirections,
      ...dataDirections.where((d) => !presetDirections.contains(d)),
    ];
    final result = await showModalBottomSheet<
        ({
          String? city,
          String? direction,
          DeadlineFilter deadline,
          bool internOnly,
          Set<String> sources,
          Set<ApplyStatus> statuses,
        })>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterSheet(
        cities: cities,
        directions: directions,
        initialCity: _city,
        initialDirection: _direction,
        initialDeadline: _deadline,
        initialInternOnly: _internOnly,
        initialSources: _sources,
        initialStatuses: _statusFilter,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _city = result.city;
      _direction = result.direction;
      _deadline = result.deadline;
      _internOnly = result.internOnly;
      _sources = result.sources;
      _statusFilter = result.statuses;
    });
    await _load();
  }

  /// 导出当前筛选后的岗位为 CSV（仅读取本地 Isar 缓存，不触发爬虫）
  Future<void> _exportCsv() async {
    final jobs = _jobs ?? [];
    if (jobs.isEmpty) {
      _showTip('当前没有可导出的岗位');
      return;
    }
    try {
      // 用户选择导出目录
      final dir = await FilePicker.getDirectoryPath(dialogTitle: '选择导出目录');
      if (dir == null || !mounted) return;
      final csv = CsvExporter.buildCsv(jobs, records: _records);
      final fileName =
          'jobs_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('$dir/$fileName');
      await file.writeAsString(csv, encoding: const SystemEncoding());
      if (!mounted) return;
      _showTip('已导出 ${jobs.length} 个岗位到 ${file.path}');
    } catch (e) {
      if (!mounted) return;
      _showTip('导出失败：$e');
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

  /// 收藏筛选开关
  Future<void> _toggleFavoriteOnly() async {
    setState(() => _favoriteOnly = !_favoriteOnly);
    await _load();
  }

  /// 当前是否有激活的筛选条件（用于显示徽标）
  bool get _hasActiveFilter =>
      (_city != null) ||
      (_direction != null) ||
      (_deadline != DeadlineFilter.all) ||
      _internOnly ||
      _sources.isNotEmpty ||
      _statusFilter.isNotEmpty;

  /// 是否有会缩小结果集的本地条件（搜索 / 筛选 / 收藏），用于空状态文案
  bool get _hasSearchOrFilterCondition =>
      _searchQuery.trim().isNotEmpty ||
      _internOnly ||
      _city != null ||
      _direction != null ||
      _deadline != DeadlineFilter.all ||
      _favoriteOnly ||
      _sources.isNotEmpty ||
      _statusFilter.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('岗位'),
        actions: [
          // 筛选按钮：有激活条件时显示小圆点
          IconButton(
            tooltip: '筛选',
            icon: Badge(
              isLabelVisible: _hasActiveFilter,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _openFilter,
          ),
          // 收藏切换
          IconButton(
            tooltip: _favoriteOnly ? '显示全部' : '只看收藏',
            icon: Icon(
              _favoriteOnly ? Icons.star : Icons.star_border,
              color: _favoriteOnly ? Colors.amber : null,
            ),
            onPressed: _toggleFavoriteOnly,
          ),
          // 导入 JSON（电脑端爬虫导出的岗位文件）
          IconButton(
            tooltip: '导入岗位 JSON',
            icon: _importing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_open_outlined),
            onPressed: _importing ? null : _importJson,
          ),
          // 导出当前筛选后的岗位为 CSV（仅本地缓存，不触发抓取）
          IconButton(
            tooltip: '导出岗位 CSV',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportCsv,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(theme),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  /// 顶部关键词搜索框：只在本地缓存中检索标题 + JD，不触发抓取
  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '搜索岗位标题 / JD 关键词（如：物流、供应链）',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: '清空',
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_dbError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('本地数据库未就绪，请重启应用后再试。', textAlign: TextAlign.center),
        ),
      );
    }
    final theme = Theme.of(context);
    final jobs = _jobs;

    // 首次进入且本地无缓存、正在抓取 → 全屏 Loading（环形动画 + 文案）
    if (_syncing && (jobs == null || jobs.isEmpty)) {
      return _scrapeLoadingView(theme);
    }
    if (jobs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (jobs.isEmpty) {
      // 本地无数据 / 本地条件过滤后无结果：分别提示
      return RefreshIndicator(
        onRefresh: _syncJobs,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 80),
            Icon(
              _hasSearchOrFilterCondition
                  ? Icons.search_off
                  : Icons.cloud_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _hasSearchOrFilterCondition
                    ? '没有匹配的岗位。\n试试清空搜索关键词或调整筛选条件。'
                    : _syncFailed
                        ? '网络抓取失败，本地也还没有缓存岗位。\n可以点下方重试，或导入电脑端导出的 JSON。'
                        : '还没有岗位数据。\n可以导入电脑端导出的 JSON，或下拉重新抓取。',
                textAlign: TextAlign.center,
              ),
            ),
            if (_syncFailed && _syncError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Text(
                  _syncError!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: _syncing ? null : _syncJobs,
                icon: const Icon(Icons.refresh),
                label: const Text('重新抓取'),
              ),
            ),
          ],
        ),
      );
    }

    // 有本地缓存：优先展示列表；抓取中显示进度条，失败显示降级提示条
    return Column(
      children: [
        if (_syncing) _scrapingBanner(theme),
        if (_syncFailed) _syncFailedBanner(theme),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _syncJobs,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              itemCount: jobs.length,
              itemBuilder: (context, i) => _JobCard(
                job: jobs[i],
                record: _records[jobs[i].id],
                onToggleFavorite: () async {
                  await JobRepo.instance.toggleFavorite(jobs[i]);
                  await _load();
                },
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JobDetailPage(job: jobs[i]),
                    ),
                  );
                  await _load();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 首次抓取中的全屏 Loading：环形进度动画 + 指定文案
  Widget _scrapeLoadingView(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 20),
          Text('正在抓取岗位信息...', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            '首次加载需要几秒，请稍候',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  /// 已有缓存数据、后台抓取中的顶部进度条
  Widget _scrapingBanner(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text('正在抓取岗位信息...', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  /// 抓取失败的降级提示条（点击可重试），数据为 Isar 本地缓存
  Widget _syncFailedBanner(ThemeData theme) {
    return Material(
      color: theme.colorScheme.errorContainer,
      child: InkWell(
        onTap: _syncing ? null : _syncJobs,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.cloud_off,
                size: 18,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '网络抓取失败，已展示本地缓存'
                  '${_syncError == null ? '' : '（$_syncError）'}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onErrorContainer),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '重试',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单个岗位卡片：公司 / 岗位 / 方向 / 城市 / 截止时间 / 投递状态 / 收藏
class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.job,
    this.record,
    required this.onToggleFavorite,
    required this.onTap,
  });

  final JobPosting job;

  /// 投递记录（可选）：有记录时展示投递状态
  final ApplicationRecord? record;
  final Future<void> Function() onToggleFavorite;
  final VoidCallback onTap;

  /// 截止日期 → 状态文案与颜色
  (String, Color) _deadlineInfo(BuildContext context) {
    final theme = Theme.of(context);
    final d = job.deadline;
    if (d == null || d.isEmpty) {
      return ('截止：未知', theme.colorScheme.onSurfaceVariant);
    }
    final today = DateTime.now();
    final dd = DateTime.tryParse(d);
    if (dd == null) return ('截止：$d', theme.colorScheme.onSurfaceVariant);
    final diff = dd.difference(today).inDays;
    if (diff < 0) return ('已截止', theme.colorScheme.error);
    if (diff == 0) return ('今天截止', theme.colorScheme.error);
    if (diff == 1) return ('明天截止', theme.colorScheme.tertiary);
    if (diff <= 7) return ('$diff 天后截止', theme.colorScheme.tertiary);
    return ('$diff 天后截止', theme.colorScheme.onSurfaceVariant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (deadlineText, deadlineColor) = _deadlineInfo(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.company,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 来源平台标记：牛客 / 实习僧 / BOSS直聘 / 导入
                        _sourceBadge(theme),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job.title,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _chip(theme, job.direction.isEmpty ? '未分类' : job.direction),
                        _chip(theme, job.city.isEmpty ? '未知城市' : job.city),
                        _chip(theme, deadlineText, color: deadlineColor),
                        if (record != null) _statusChip(theme, record!),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: job.isFavorite ? '取消收藏' : '收藏',
                icon: Icon(
                  job.isFavorite ? Icons.star : Icons.star_border,
                  color: job.isFavorite ? Colors.amber : null,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 来源平台标记（牛客 / 实习僧 / BOSS直聘；JSON 导入显示「导入」）
  Widget _sourceBadge(ThemeData theme) {
    final label = MultiPlatformScraper.labelOf(job.source);
    final isImported = !MultiPlatformScraper.platformLabels.containsKey(job.source);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isImported
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isImported
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _chip(ThemeData theme, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color == null
            ? theme.colorScheme.surfaceContainerHighest
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color ?? theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// 投递状态标签（有投递记录时展示）
  Widget _statusChip(ThemeData theme, ApplicationRecord record) {
    final status = ApplyStatus.values[
        record.status.clamp(0, ApplyStatus.values.length - 1)];
    final color = switch (status) {
      ApplyStatus.pending => theme.colorScheme.onSurfaceVariant,
      ApplyStatus.submitted => theme.colorScheme.primary,
      ApplyStatus.interviewing => theme.colorScheme.tertiary,
      ApplyStatus.rejected => theme.colorScheme.error,
    };
    return _chip(theme, '投递：${applyStatusLabels[status] ?? ''}', color: color);
  }
}

/// 筛选面板：实习生专区（顶部开关）/ 城市 / 方向 / 截止时间
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.cities,
    required this.directions,
    required this.initialCity,
    required this.initialDirection,
    required this.initialDeadline,
    required this.initialInternOnly,
    required this.initialSources,
    required this.initialStatuses,
  });

  final List<String> cities;
  final List<String> directions;
  final String? initialCity;
  final String? initialDirection;
  final DeadlineFilter initialDeadline;
  final bool initialInternOnly;
  final Set<String> initialSources;
  final Set<ApplyStatus> initialStatuses;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _city;
  late String? _direction;
  late DeadlineFilter _deadline;
  late bool _internOnly;
  late Set<String> _sources;
  late Set<ApplyStatus> _statuses;

  @override
  void initState() {
    super.initState();
    _city = widget.initialCity;
    _direction = widget.initialDirection;
    _deadline = widget.initialDeadline;
    _internOnly = widget.initialInternOnly;
    _sources = {...widget.initialSources};
    _statuses = {...widget.initialStatuses};
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('筛选岗位', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            // 实习生专区总开关（筛选区域顶部）：只保留实习岗位，过滤全职
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('实习生专区'),
              subtitle: const Text('仅显示实习岗位，过滤全职岗位'),
              value: _internOnly,
              onChanged: (v) => setState(() => _internOnly = v),
            ),
            const SizedBox(height: 8),
            // 招聘平台多选：牛客 / 实习僧 / BOSS直聘（仅本地缓存过滤）
            Text('招聘平台', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: const Text('不限'),
                  selected: _sources.isEmpty,
                  onSelected: (_) => setState(() => _sources = {}),
                ),
                for (final key in MultiPlatformScraper.allPlatformKeys)
                  ChoiceChip(
                    label: Text(MultiPlatformScraper.labelOf(key)),
                    selected: _sources.contains(key),
                    onSelected: (selected) => setState(() {
                      final next = {..._sources};
                      if (selected) {
                        next.add(key);
                      } else {
                        next.remove(key);
                      }
                      _sources = next;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // 投递状态多选：待投递/已投递/面试中/已挂（仅本地缓存过滤）
            Text('投递状态', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: const Text('不限'),
                  selected: _statuses.isEmpty,
                  onSelected: (_) => setState(() => _statuses = {}),
                ),
                for (final status in ApplyStatus.values)
                  ChoiceChip(
                    label: Text(applyStatusLabels[status] ?? ''),
                    selected: _statuses.contains(status),
                    onSelected: (selected) => setState(() {
                      final next = {..._statuses};
                      if (selected) {
                        next.add(status);
                      } else {
                        next.remove(status);
                      }
                      _statuses = next;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _choiceGroup(
              label: '城市',
              items: widget.cities,
              selected: _city,
              onSelected: (v) => setState(() => _city = v),
            ),
            const SizedBox(height: 12),
            _choiceGroup(
              label: '岗位方向',
              items: widget.directions,
              selected: _direction,
              onSelected: (v) => setState(() => _direction = v),
            ),
            const SizedBox(height: 12),
            Text('截止时间', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                for (final (value, label) in const [
                  (DeadlineFilter.all, '全部'),
                  (DeadlineFilter.open, '未截止'),
                  (DeadlineFilter.withinWeek, '7 天内截止'),
                  (DeadlineFilter.expired, '已截止'),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _deadline == value,
                    onSelected: (_) => setState(() => _deadline = value),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _city = null;
                      _direction = null;
                      _deadline = DeadlineFilter.all;
                      _internOnly = false;
                      _sources = {};
                      _statuses = {};
                    });
                  },
                  child: const Text('重置'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    (
                      city: _city,
                      direction: _direction,
                      deadline: _deadline,
                      internOnly: _internOnly,
                      sources: _sources,
                      statuses: _statuses,
                    ),
                  ),
                  child: const Text('应用筛选'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 一组单选 chip（城市 / 方向）
  Widget _choiceGroup({
    required String label,
    required List<String> items,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ChoiceChip(
              label: const Text('不限'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
            for (final item in items)
              ChoiceChip(
                label: Text(item),
                selected: selected == item,
                onSelected: (_) => onSelected(item),
              ),
          ],
        ),
      ],
    );
  }
}