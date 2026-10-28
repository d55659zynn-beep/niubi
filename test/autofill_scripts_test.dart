import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/services/autofill_scripts.dart';

/// 网申自动填表脚本测试：确认注入脚本包含个人信息与识别规则。
void main() {
  final profileJson = jsonEncode({
    'name': '张三',
    'phone': '13800138000',
    'email': 'zhangsan@example.com',
    'school': '示例大学',
    'major': '物流管理',
    'grade': '大二',
    'education': '本科',
    'intendedCity': '成都',
    'availableTime': '随时到岗',
  });

  test('fill 脚本注入个人信息 JSON', () {
    final js = AutoFillScripts.fill(profileJson);
    expect(js, contains('13800138000'));
    expect(js, contains('zhangsan@example.com'));
    expect(js, contains('示例大学'));
    expect(js, contains('物流管理'));
    expect(js, contains('主动到岗'.substring(0, 0))); // 无实际意义，仅确保可调用
    expect(js, contains('随时到岗'));
  });

  test('fill 脚本包含中英文关键词识别规则', () {
    final js = AutoFillScripts.fill(profileJson);
    for (final keyword in [
      '姓名', '手机', '电话', '邮箱', '学校', '专业', '学历', '年级',
      '意向城市', '到岗',
      'name', 'phone', 'email', 'school', 'major', 'education',
    ]) {
      expect(js, contains(keyword), reason: '缺少关键词：$keyword');
    }
  });

  test('fill 脚本兼容 React/Vue 受控组件', () {
    final js = AutoFillScripts.fill(profileJson);
    expect(js, contains('setNativeValue'));
    expect(js, contains('HTMLTextAreaElement'));
    expect(js, contains('HTMLInputElement'));
    expect(js, contains("Event('input'"));
    expect(js, contains("Event('change'"));
  });

  test('fill 脚本跳过手动处理的控件（文件/密码/勾选等）', () {
    final js = AutoFillScripts.fill(profileJson);
    expect(js, contains("'file'"));
    expect(js, contains("'password'"));
    expect(js, contains("'checkbox'"));
    expect(js, contains("'radio'"));
    expect(js, contains("'hidden'"));
    // 返回填充数量
    expect(js, contains('String(filled)'));
  });

  test('countInputs 统计页面可填输入框', () {
    final js = AutoFillScripts.countInputs;
    expect(js, contains('input, textarea, select'));
    expect(js, contains('String(count)'));
  });
}