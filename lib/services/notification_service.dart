import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 本机系统通知（截止提醒）。不走任何云推送。
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;

    tzdata.initializeTimeZones();
    final tzName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    // 22.x 版本：settings 为命名参数；macOS 平台也必须提供 macOS 设置
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      ),
    );

    // Android 13+ 通知权限
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS 通知权限
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // macOS 通知权限（桌面端调试时生效）
    await _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _ready = true;
  }

  /// 在截止日期当天 09:00 本地提醒。已过期则跳过。
  Future<void> scheduleDeadlineReminder({
    required int jobId,
    required String title,
    required String company,
    required DateTime deadlineDate,
  }) async {
    if (!_ready) return;
    final when = tz.TZDateTime(
      tz.local,
      deadlineDate.year,
      deadlineDate.month,
      deadlineDate.day,
      9,
    );
    if (when.isBefore(tz.TZDateTime.now(tz.local))) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'job_deadline',
        '岗位截止提醒',
        channelDescription: '本地岗位截止日期提醒',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: jobId,
      title: '投递截止：$title',
      body: '$company 今日截止，记得手动完成验证码和附件。',
      scheduledDate: when,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelDeadlineReminder(int jobId) async {
    await _plugin.cancel(id: jobId);
  }

  /// 岗位更新提醒：仅提示新增岗位数量，不自动打开爬虫/网页。
  /// 移动端（iOS/Android）与桌面端（macOS）均使用系统通知。
  Future<void> showJobUpdateNotification(int count) async {
    if (!_ready || count <= 0) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'job_update',
        '岗位更新提醒',
        channelDescription: '发现新实习岗位时的本地提醒',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: 10086,
      title: '发现 $count 个新实习岗位',
      body: '打开 App 查看详情（不会自动打开网页）',
      notificationDetails: details,
    );
  }
}
