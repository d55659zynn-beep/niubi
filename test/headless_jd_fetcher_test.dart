import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/services/headless_jd_fetcher.dart';

/// 无头浏览器 JD 提取测试（纯解析逻辑，不启动浏览器）。
void main() {
  test('从渲染后 HTML 按选择器提取 JD（多元素拼接）', () {
    const html = '''
<html><body>
<div class="job-content">
  <div class="content_left">
    <div class="con-job">
      <div class="job_til">职位描述：</div>
      <div class="job_part">
        <div class="job_detail" style="white-space:pre-wrap;">工作内容：负责供应链数据核对与台账优化。</div>
        <div class="job_detail">任职要求：物流管理专业，每周到岗 4 天。</div>
      </div>
    </div>
  </div>
</div>
</body></html>
''';
    final jd = HeadlessJdFetcher.extractDescription(
      html,
      '.job-content .job_detail',
    );
    expect(jd, isNotNull);
    expect(jd, contains('负责供应链数据核对与台账优化'));
    expect(jd, contains('物流管理专业'));
    expect(jd, contains('\n\n'), reason: '多段 JD 用空行拼接');
  });

  test('选择器无匹配时返回 null（上层按空 JD 兜底）', () {
    const html = '<html><body><div class="other">无 JD</div></body></html>';
    expect(
      HeadlessJdFetcher.extractDescription(html, '.job-content .job_detail'),
      isNull,
    );
  });

  test('桌面端判定（macOS 测试环境应为 true）', () {
    // 单元测试运行在 macOS 宿主上，isDesktop 应为 true
    expect(HeadlessJdFetcher.isDesktop, Platform.isMacOS ||
        Platform.isWindows || Platform.isLinux);
  });

  test('无头浏览器可用性检测不抛异常', () {
    // 本机可能安装/未安装 Chrome，均不应抛异常
    expect(() => HeadlessJdFetcher.instance.available, returnsNormally);
  });
}