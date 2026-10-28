import 'package:flutter_test/flutter_test.dart';
import 'package:wangshen_app/services/js_result_parser.dart';
import 'package:wangshen_app/services/web_filler_scripts.dart';

/// WebView 模块单元测试：
/// 1) 注入脚本的内容断言（关键逻辑/关键词是否齐全）
/// 2) JS 返回值解析工具（不同平台的引号/转义包装、验证码结果判断）
void main() {
  group('WebFillerScripts 注入脚本内容', () {
    test('bootstrap：包含选择器生成、点击捕获、映射模式开关逻辑', () {
      final js = WebFillerScripts.bootstrap;
      expect(js, contains('__wsCaptureOn')); // 映射模式开关
      expect(js, contains('cssPath')); // 选择器生成
      expect(js, contains('closest')); // 向上找输入控件
      expect(js, contains('input, textarea, select'));
      expect(js, contains('addEventListener'));
      expect(js, contains('wsApp.postMessage')); // 上报给 Flutter
      expect(js, contains('preventDefault')); // 映射模式拦截默认行为
      expect(js, contains('stopPropagation'));
      expect(js, contains('nth-of-type')); // 选择器唯一性
    });

    test('captureToggle：true/false 正确切换捕获开关', () {
      expect(WebFillerScripts.captureToggle(true), contains('__wsCaptureOn = true'));
      expect(WebFillerScripts.captureToggle(false), contains('__wsCaptureOn = false'));
      expect(WebFillerScripts.captureToggle(true), endsWith('true;'));
    });

    test('fill：配置可注入，兼容 React/Vue 与 select/radio/checkbox', () {
      const cfg = '[{"selector":"#name","value":"张三","type":"input"}]';
      final js = WebFillerScripts.fill(cfg);
      expect(js, contains('var config = $cfg')); // 配置正确嵌入
      expect(js, contains('querySelector')); // 按选择器定位
      expect(js, contains('setNativeValue')); // 原生 setter
      expect(js, contains('HTMLTextAreaElement'));
      expect(js, contains('HTMLInputElement'));
      expect(js, contains("'input'")); // input 事件
      expect(js, contains("'change'")); // change 事件
      expect(js, contains('SELECT')); // 下拉框处理
      expect(js, contains('checkbox'));
      expect(js, contains('radio'));
      expect(js, contains('file')); // 文件上传跳过
    });

    test('detectCaptcha：包含验证码关键词与控件扫描逻辑', () {
      final js = WebFillerScripts.detectCaptcha;
      expect(js, contains('captcha'));
      expect(js, contains('verifycode'));
      expect(js, contains('验证码'));
      expect(js, contains('短信验证'));
      expect(js, contains('querySelectorAll'));
      expect(js, contains('aria-label'));
      expect(js, contains("join(',')")); // 结果以逗号分隔返回
    });

    test('getHost：返回当前页面 host', () {
      expect(WebFillerScripts.getHost, contains('window.location.host'));
    });
  });

  group('JsResultParser JS 返回值解析', () {
    test('toCleanString：处理双引号/单引号/无引号/null/数字', () {
      expect(JsResultParser.toCleanString('"已填充 3 项"'), '已填充 3 项');
      expect(JsResultParser.toCleanString("'a.example.com'"), 'a.example.com');
      expect(JsResultParser.toCleanString('plain'), 'plain');
      expect(JsResultParser.toCleanString(null), '');
      expect(JsResultParser.toCleanString(5), '5');
      expect(JsResultParser.toCleanString('  "  x  "  '), '  x  ');
    });

    test('toCleanString：还原 JSON 转义字符', () {
      // 平台返回 r'"a\"b"'（外层引号 + 内部转义）时应还原为 a"b
      expect(JsResultParser.toCleanString(r'"a\"b"'), 'a"b');
      expect(JsResultParser.toCleanString(r'"line1\nline2"'), 'line1\nline2');
      expect(JsResultParser.toCleanString(r'"back\\slash"'), r'back\slash');
    });

    test('parseFilledCount：解析填充数量', () {
      expect(JsResultParser.parseFilledCount('"5"'), 5);
      expect(JsResultParser.parseFilledCount('0'), 0);
      expect(JsResultParser.parseFilledCount('"abc"'), 0);
      expect(JsResultParser.parseFilledCount(null), 0);
    });

    test('hasCaptcha：空串/空白表示未检测到，非空表示检测到', () {
      expect(JsResultParser.hasCaptcha(''), isFalse);
      expect(JsResultParser.hasCaptcha('   '), isFalse);
      expect(JsResultParser.hasCaptcha('code'), isTrue);
      expect(JsResultParser.hasCaptcha('验证码'), isTrue);
    });

    test('captchaTip：未检测到返回 null，检测到给出提示文案', () {
      expect(JsResultParser.captchaTip(''), isNull);
      expect(JsResultParser.captchaTip('   '), isNull);

      final tip = JsResultParser.captchaTip('code,验证码');
      expect(tip, isNotNull);
      expect(tip, contains('验证码'));
      expect(tip, contains('手动完成'));
    });

    test('captchaTip：去重且最多展示 3 个控件标识', () {
      final tip = JsResultParser.captchaTip('a,a,b,c,d')!;
      expect(tip, contains('a'));
      expect(tip, contains('b'));
      expect(tip, contains('c'));
      expect(tip, isNot(contains('d')));
    });
  });
}