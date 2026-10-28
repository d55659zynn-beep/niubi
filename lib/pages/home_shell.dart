import 'package:flutter/material.dart';

import 'applications/applications_page.dart';
import 'jobs/job_list_page.dart';
import 'profile/profile_page.dart';
import 'resume/resume_list_page.dart';

/// 底部导航：岗位 / 简历 / 投递台账 / 我的（个人信息）
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  /// 岗位页的 GlobalKey：切回岗位 Tab 时触发一次网页同步
  final _jobPageKey = GlobalKey<JobListPageState>();

  /// IndexedStack 保持页面状态，所以页面列表不能是 static const
  late final List<Widget> _pages = [
    JobListPage(key: _jobPageKey),
    const ResumeListPage(),
    const ApplicationsPage(),
    const ProfilePage(),
  ];

  /// 切换 Tab：切回岗位页时触发同步抓取。
  /// 30 分钟内重复切换由 JobScraper 的节流缓存拦截，不会重复请求网页。
  void _onDestinationSelected(int index) {
    setState(() => _index = index);
    if (index == 0) {
      _jobPageKey.currentState?.onTabActivated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: '岗位',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: '简历',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: '投递',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}