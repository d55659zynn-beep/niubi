import '../db/schemas/job_posting.dart';

/// 岗位本地过滤工具（纯内存计算，不触发任何网络请求）。
/// 用于岗位列表的「实习生专区」开关与关键词搜索。
class JobFilter {
  JobFilter._();

  /// 是否实习岗位：标题或 JD 含“实习 / Intern”即视为实习岗
  static bool isInternship(JobPosting job) {
    final text = '${job.title}${job.description}'.toLowerCase();
    return text.contains('实习') || text.contains('intern');
  }

  /// 应用本地过滤（纯内存，不触发网络请求）：
  /// - [internOnly]：实习生专区开关，过滤掉全职岗位
  /// - [keyword]：关键词搜索，匹配岗位标题或 JD 全文（忽略大小写）
  /// - [sources]：招聘平台多选筛选（如 {'nowcoder','shixiseng'}），
  ///   为空表示不限制平台
  static List<JobPosting> apply(
    List<JobPosting> jobs, {
    bool internOnly = false,
    String keyword = '',
    Set<String>? sources,
  }) {
    var result = jobs;
    // 招聘平台多选过滤
    if (sources != null && sources.isNotEmpty) {
      result = result.where((j) => sources.contains(j.source)).toList();
    }
    if (internOnly) {
      result = result.where(isInternship).toList();
    }
    final q = keyword.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((j) =>
              j.title.toLowerCase().contains(q) ||
              j.description.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }
}