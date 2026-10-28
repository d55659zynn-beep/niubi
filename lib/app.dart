import 'package:flutter/material.dart';

import 'pages/home_shell.dart';
import 'theme/app_theme.dart';

/// 应用根组件：Material3 + 跟随系统深浅色
class WangshenApp extends StatelessWidget {
  const WangshenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '实习投递',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}
