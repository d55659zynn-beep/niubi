import 'dart:convert';
import 'dart:io';

import 'package:isar_community/isar.dart';

import 'isar_service.dart';
import 'schemas/job_posting.dart';

/// 截止时间筛选条件
enum DeadlineFilter {
  /// 全部岗位
  all,

  /// 未截止（没有截止日期的按未截止处理，避免漏看）
  open,

  /// 未来 7 天内截止（不含无截止日期）
  withinWeek,

  /// 已过期
  expired,
}

/// 动态筛选条件标记（allOf 组合用）
enum _Cond { city, direction, favorite }

/// 岗位数据访问层：JSON 导入、查询筛选、收藏、提醒标记。
/// 只读写本机 Isar，不做网络抓取。
class JobRepo {
  JobRepo._();
  static final JobRepo instance = JobRepo._();

  /// 今日日期字符串（YYYY-MM-DD），用于字符串比较（同格式可直接比较）
  static String _todayStr() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${n.year}-${two(n.month)}-${two(n.day)}';
  }

  /// 从导入文件得到的目标列表
  static String _dateStr(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  /// 按条件查询岗位。
  /// [city] / [direction] 为精确匹配；[deadline] 为截止时间筛选；
  /// [isFavorite] 非空时按收藏状态过滤。结果按导入时间倒序。
  ///
  /// 实现说明：城市/方向/收藏用 Isar 精确匹配（allOf 动态组合）；
  /// 截止时间在 Dart 侧按日期字符串比较过滤——Isar 对 null 字符串的
  /// 比较行为不可靠（会把无截止日期的岗位算作已过期），而个人自用
  /// 数据量小，内存过滤更简单可靠。
  Future<List<JobPosting>> query({
    String? city,
    String? direction,
    DeadlineFilter deadline = DeadlineFilter.all,
    bool? isFavorite,
  }) async {
    final isar = IsarService.instance.isar;
    final today = _todayStr();
    final weekLater = _dateStr(DateTime.now().add(const Duration(days: 7)));

    // 收集激活的精确匹配条件；allOf 对空列表是无操作，因此无条件时也安全
    final conds = <_Cond>[];
    if (city != null && city.isNotEmpty) conds.add(_Cond.city);
    if (direction != null && direction.isNotEmpty) conds.add(_Cond.direction);
    if (isFavorite != null) conds.add(_Cond.favorite);

    final q = isar.jobPostings.filter().allOf(conds, (g, c) {
      switch (c) {
        case _Cond.city:
          return g.cityEqualTo(city!);
        case _Cond.direction:
          return g.directionEqualTo(direction!);
        case _Cond.favorite:
          return g.isFavoriteEqualTo(isFavorite!);
      }
    });

    final all = await q.sortByImportedAtDesc().findAll();

    // 截止时间筛选（无截止日期按“未截止”处理，避免漏看）
    return all.where((job) {
      final d = job.deadline ?? '';
      final hasDeadline = d.isNotEmpty;
      switch (deadline) {
        case DeadlineFilter.all:
          return true;
        case DeadlineFilter.open:
          return !hasDeadline || d.compareTo(today) >= 0;
        case DeadlineFilter.withinWeek:
          return hasDeadline &&
              d.compareTo(today) >= 0 &&
              d.compareTo(weekLater) <= 0;
        case DeadlineFilter.expired:
          return hasDeadline && d.compareTo(today) < 0;
      }
    }).toList();
  }

  /// 现有岗位中出现过的全部城市（用于筛选面板）
  Future<List<String>> distinctCities() async {
    final isar = IsarService.instance.isar;
    final all = await isar.jobPostings.where().findAll();
    return all.map((j) => j.city).where((c) => c.isNotEmpty).toSet().toList()
      ..sort();
  }

  /// 现有岗位中出现过的全部方向（用于筛选面板）
  Future<List<String>> distinctDirections() async {
    final isar = IsarService.instance.isar;
    final all = await isar.jobPostings.where().findAll();
    return all.map((j) => j.direction).where((c) => c.isNotEmpty).toSet().toList()
      ..sort();
  }

  /// 导入爬虫导出的岗位 JSON 文件（本机文件，不联网）。
  /// 按 source + id 去重：已存在的岗位原地更新，不重复插入。
  /// 返回 (新增数, 更新数, 需取消提醒的岗位 id 列表)。
  /// 重新导入时保留收藏状态；截止日期变化的已提醒岗位会重置提醒，
  /// 由页面层根据 reminderResetIds 取消对应的系统通知。
  Future<({int added, int updated, List<int> reminderResetIds})>
      importJsonFile(String path) async {
    final raw = await File(path).readAsString();
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final source = (map['source'] as String?)?.trim() ?? 'unknown';
    final jobs = (map['jobs'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    if (jobs.isEmpty) {
      throw FormatException('JSON 中没有 jobs 数组或为空');
    }

    final isar = IsarService.instance.isar;
    var added = 0;
    var updated = 0;
    final reminderResetIds = <int>[];
    await isar.writeTxn(() async {
      for (final raw in jobs) {
        final externalId = (raw['id'] as String?)?.trim() ?? '';
        final uniqueKey = '$source:$externalId';
        // 已存在则覆盖更新，否则新建
        final exists = await isar.jobPostings
            .filter()
            .uniqueKeyEqualTo(uniqueKey)
            .findFirst();
        // 注意：exists 与 job 是同一个对象，先保存旧值再赋值
        final oldDeadline = exists?.deadline;
        final wasReminderEnabled = exists?.reminderEnabled ?? false;
        final job = exists ?? JobPosting();
        job.uniqueKey = uniqueKey;
        job.source = source;
        job.externalId = externalId;
        job.company = (raw['company'] as String?)?.trim() ?? '未知公司';
        job.title = (raw['title'] as String?)?.trim() ?? '';
        job.city = (raw['city'] as String?)?.trim() ?? '';
        job.direction = (raw['direction'] as String?)?.trim() ?? '';
        final newDeadline = (raw['deadline'] as String?)?.trim();
        job.deadline = newDeadline;
        job.description = (raw['description'] as String?)?.trim() ?? '';
        // applyUrl：优先 camelCase（本仓库爬虫导出格式），兼容 snake_case 旧文件
        job.applyUrl =
            ((raw['applyUrl'] as String?) ?? (raw['apply_url'] as String?))
                ?.trim() ??
            '';
        // 保留用户的收藏与提醒状态
        job.isFavorite = exists?.isFavorite ?? false;
        job.reminderEnabled = exists?.reminderEnabled ?? false;
        // 截止日期变化时，旧的提醒时间已失效：重置并交由页面取消旧通知
        if (exists != null && wasReminderEnabled && oldDeadline != newDeadline) {
          job.reminderEnabled = false;
          reminderResetIds.add(exists.id);
        }
        job.importedAt = DateTime.now();
        await isar.jobPostings.put(job);
        if (exists == null) {
          added++;
        } else {
          updated++;
        }
      }
    });
    return (
      added: added,
      updated: updated,
      reminderResetIds: reminderResetIds,
    );
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(JobPosting job) async {
    final isar = IsarService.instance.isar;
    job.isFavorite = !job.isFavorite;
    await isar.writeTxn(() async {
      await isar.jobPostings.put(job);
    });
  }

  /// 更新岗位（用于持久化提醒开关等状态）
  Future<void> save(JobPosting job) async {
    final isar = IsarService.instance.isar;
    await isar.writeTxn(() async {
      await isar.jobPostings.put(job);
    });
  }

  /// 保存网页抓取的岗位：
  /// 抓取服务的岗位 Id 由“标题+公司”的 sha256 生成，相同岗位 Id 相同，
  /// Isar 的 put 会覆盖更新而不是重复新增；同时保留用户的收藏/提醒状态。
  /// 返回写入数量。
  Future<int> saveScraped(List<JobPosting> jobs) async {
    if (jobs.isEmpty) return 0;
    final isar = IsarService.instance.isar;
    var saved = 0;
    await isar.writeTxn(() async {
      for (final job in jobs) {
        final exists = await isar.jobPostings.get(job.id);
        if (exists != null) {
          // 已存在：保留用户的本地状态
          job.isFavorite = exists.isFavorite;
          job.reminderEnabled = exists.reminderEnabled;
        }
        await isar.jobPostings.put(job);
        saved++;
      }
    });
    return saved;
  }
}