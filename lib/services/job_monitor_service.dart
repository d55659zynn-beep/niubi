import 'dart:async';

import '../db/app_setting_repo.dart';
import '../db/job_repo.dart';
import 'multi_platform_scraper.dart';
import 'notification_service.dart';

/// 岗位后台监控服务：
/// - 按 30 分钟周期触发（各平台内部节流保证 30 分钟内不会重复请求网页）
/// - 抓取后对比 Isar 本地缓存的岗位集合，识别新增岗位
/// - 有新岗位时通过本地通知提醒（仅提示数量，不自动打开爬虫/网页）
/// - 由设置页推送开关控制；App 前台运行期间生效
///   （iOS/Android 系统级后台限制见 docs 说明）
class JobMonitorService {
  JobMonitorService._();
  static final JobMonitorService instance = JobMonitorService._();

  /// 检查周期（与平台 30 分钟节流一致）
  static const checkInterval = Duration(minutes: 30);

  Timer? _timer;
  bool _checking = false;

  /// 根据推送开关启停定时器（应用启动 / 设置变化时调用）
  Future<void> refresh() async {
    try {
      final setting = await AppSettingRepo.instance.get();
      if (setting.pushEnabled) {
        _timer ??= Timer.periodic(checkInterval, (_) {
          // 后台静默检查；失败静默忽略（不影响 App）
          checkAndNotify();
        });
      } else {
        _stopTimer();
      }
    } catch (_) {
      // 数据库未就绪等异常：不影响 App
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 立即执行一次检查：抓取 → 对比新增 → 本地通知。返回新增岗位数。
  Future<int> checkAndNotify() async {
    if (_checking) return 0;
    _checking = true;
    try {
      final beforeIds =
          (await JobRepo.instance.query()).map((j) => j.id).toSet();
      final result = await MultiPlatformScraper.instance.fetchAll();
      if (result.hasJobs) {
        await JobRepo.instance.saveScraped(result.jobs);
      }
      final afterIds =
          (await JobRepo.instance.query()).map((j) => j.id).toSet();
      final addedCount = afterIds.difference(beforeIds).length;
      if (addedCount > 0) {
        await NotificationService.instance.showJobUpdateNotification(addedCount);
      }
      return addedCount;
    } catch (_) {
      // 抓取/写库失败：静默降级，不弹错
      return 0;
    } finally {
      _checking = false;
    }
  }

  /// 停止监控（退出/测试时调用）
  void stop() => _stopTimer();
}