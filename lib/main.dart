import 'package:flutter/material.dart';

import 'app.dart';
import 'db/isar_service.dart';
import 'services/job_monitor_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Isar 本地库是核心依赖，失败时直接暴露
  await IsarService.instance.init();
  // 本地通知是辅助功能，初始化失败不应阻止 APP 启动
  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('通知初始化失败（不影响主功能）: $e');
  }
  // 按设置中的推送开关启动岗位监控（失败静默，不影响启动）
  try {
    await JobMonitorService.instance.refresh();
  } catch (e) {
    debugPrint('岗位监控启动失败（不影响主功能）: $e');
  }
  runApp(const WangshenApp());
}
