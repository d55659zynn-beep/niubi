/// JS 返回值解析工具。
///
/// webview_flutter 的 `runJavaScriptReturningResult` 返回 Object，
/// 不同平台/不同 JS 返回值类型的包装方式不一致：
/// - JS 返回字符串时，可能带回外层引号与反斜杠转义（Android）
/// - iOS 上可能直接返回已解码的值
/// 这里统一转换为干净的 Dart 字符串，供填充计数、验证码检测等使用。
class JsResultParser {
  JsResultParser._();

  /// 把 JS 返回值转成干净字符串（去掉平台可能包裹的外层引号并还原转义）。
  static String toCleanString(Object? result) {
    if (result == null) return '';
    var s = result.toString().trim();
    // 去掉外层引号（"xxx" / 'xxx'）
    if (s.length >= 2 &&
        ((s.startsWith('"') && s.endsWith('"')) ||
            (s.startsWith("'") && s.endsWith("'")))) {
      s = s.substring(1, s.length - 1);
      s = _unescape(s);
    }
    return s;
  }

  /// 还原 JSON 字符串转义（\" -> "、\\ -> \、\n -> 换行等）
  static String _unescape(String s) {
    final sb = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      if (c == r'\' && i + 1 < s.length) {
        final next = s[i + 1];
        switch (next) {
          case '"':
            sb.write('"');
            i++;
          case r'\':
            sb.write(r'\');
            i++;
          case 'n':
            sb.write('\n');
            i++;
          case 'r':
            sb.write('\r');
            i++;
          case 't':
            sb.write('\t');
            i++;
          default:
            sb.write(c);
        }
      } else {
        sb.write(c);
      }
    }
    return sb.toString();
  }

  /// 是否检测到验证码。
  /// [raw] 为 `WebFillerScripts.detectCaptcha` 的返回值，
  /// 空串表示页面没有验证码输入框，非空表示命中。
  static bool hasCaptcha(String raw) => raw.trim().isNotEmpty;

  /// 验证码提示文案；未检测到时返回 null。
  static String? captchaTip(String raw) {
    if (!hasCaptcha(raw)) return null;
    // 返回形如 "code,验证码"，最多展示 3 个控件标识
    final names = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .take(3)
        .join('、');
    return '检测到验证码输入框${names.isEmpty ? '' : '（$names）'}，请手动完成验证码';
  }

  /// 解析填充脚本返回的填充数量（非数字时按 0 处理）。
  static int parseFilledCount(Object? result) {
    final s = toCleanString(result);
    return int.tryParse(s) ?? 0;
  }
}