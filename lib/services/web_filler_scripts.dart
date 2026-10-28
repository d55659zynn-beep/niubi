/// WebView 注入的 JS 脚本库。
/// 全部为本机生成的字符串，不加载任何外部 JS。
/// 功能：1) 元素 CSS 选择器生成  2) 点击捕获（映射模式）
///       3) 一键填充表单（兼容 React/Vue 受控组件）
class WebFillerScripts {
  WebFillerScripts._();

  /// 页面加载完成后注入的引导脚本：
  /// - 定义 cssPath() 生成元素选择器（id 优先，其次 name/class + nth 定位）
  /// - capture 阶段监听点击，把被点击的输入控件信息发给 Flutter（映射模式）
  static const bootstrap = r'''
(function() {
  if (window.__wsInjected) return;
  window.__wsInjected = true;
  window.__wsCaptureOn = false;

  // 为元素生成唯一选择器：优先 id，其次 name，再其次 label/class，
  // 最后用 nth-of-type 保证唯一
  function cssPath(el) {
    if (!el || el.nodeType !== 1) return '';
    if (el.id) return '#' + CSS.escape(el.id);
    var parts = [];
    var cur = el;
    while (cur && cur.nodeType === 1 &&
           cur !== document.body && cur !== document.documentElement) {
      var part = cur.tagName.toLowerCase();
      if (cur.id) {
        part = '#' + CSS.escape(cur.id);
        parts.unshift(part);
        break;
      }
      if (cur.name) {
        part += '[name="' + cur.name + '"]';
      } else if (cur.className && typeof cur.className === 'string') {
        var cls = cur.className.trim().split(/\s+/).filter(Boolean);
        if (cls.length) part += '.' + cls.map(function(c) { return CSS.escape(c); }).join('.');
      }
      var parent = cur.parentElement;
      if (parent) {
        var same = Array.prototype.filter.call(
          parent.children,
          function(sib) { return sib.tagName === cur.tagName; }
        );
        // 同父下同标签有多个时附加位置，避免选择器命中多个元素
        if (same.length > 1) {
          part += ':nth-of-type(' + (Array.prototype.indexOf.call(same, cur) + 1) + ')';
        }
      }
      parts.unshift(part);
      cur = parent;
    }
    return parts.join(' > ');
  }

  // capture 阶段监听点击：找到被点击处最接近的输入控件并上报
  document.addEventListener('click', function(e) {
    if (!window.__wsCaptureOn) return;
    var t = e.target;
    if (!t || t.nodeType !== 1) return;
    var ctrl = t.closest ? t.closest('input, textarea, select') : null;
    if (!ctrl || !window.wsApp) return;
    // 映射模式下阻止点击的默认行为，避免绑定操作误触发页面逻辑
    // （如聚焦弹出键盘、按钮提交、跳转等）
    e.preventDefault();
    e.stopPropagation();
    var info = {
      selector: cssPath(ctrl),
      type: ctrl.tagName.toLowerCase(),
      typeAttr: ctrl.type || '',
      name: ctrl.name || '',
      id: ctrl.id || ''
    };
    window.wsApp.postMessage(JSON.stringify(info));
  }, true);
})();
''';

  /// 切换“映射模式”（开启后点击网页输入框会上报给 Flutter）
  static String captureToggle(bool on) => 'window.__wsCaptureOn = $on; true;';

  /// 一键填充脚本。jsonConfig 为填充项数组的 JSON 字符串：
  /// [{"selector": "...", "value": "...", "type": "input|textarea|select"}]
  /// 返回实际填充的数量。
  static String fill(String jsonConfig) => r'''
(function() {
  var config = ''' + jsonConfig + r''';
  if (!config || !config.length) return '0';
  var count = 0;

  // React/Vue 等框架需要触发原生 setter，否则受控组件认为值未变
  function setNativeValue(el, value) {
    var proto = el.tagName === 'TEXTAREA'
        ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype;
    var setter = Object.getOwnPropertyDescriptor(proto, 'value').set;
    setter.call(el, value);
    el.dispatchEvent(new Event('input', {bubbles: true}));
    el.dispatchEvent(new Event('change', {bubbles: true}));
  }

  config.forEach(function(item) {
    var el = document.querySelector(item.selector);
    if (!el) return;
    var value = item.value;

    // select：优先按文本匹配，其次按 value 匹配
    if (el.tagName === 'SELECT') {
      var found = false;
      for (var i = 0; i < el.options.length; i++) {
        if (el.options[i].text.trim() === value ||
            el.options[i].value === value) {
          el.selectedIndex = i;
          found = true;
          break;
        }
      }
      el.dispatchEvent(new Event('change', {bubbles: true}));
      if (found) count++;
      return;
    }

    var t = (el.type || '').toLowerCase();
    if (t === 'checkbox') {
      var want = (value === 'true' || value === '1' ||
                  value === '是' || value === '有' || value === 'yes');
      if (el.checked !== want) el.click();
      count++;
      return;
    }
    if (t === 'radio') {
      // 同 name 组内按 value 或附近文本匹配后点击
      var radios = document.querySelectorAll(
        'input[type=radio][name="' + el.name + '"]');
      var hit = null;
      radios.forEach(function(r) {
        var label = (r.parentElement ? r.parentElement.textContent : '') || '';
        if (r.value === value || label.indexOf(value) >= 0) hit = r;
      });
      if (hit) { hit.click(); count++; }
      return;
    }
    // 文件上传只能手动操作，跳过
    if (t === 'file') return;

    setNativeValue(el, value);
    count++;
  });
  return String(count);
})();
''';

  /// 读取当前页面 host（映射按 host 分别保存）
  static const getHost = r'''window.location.host''';

  /// 检测页面上的验证码输入框（验证码无法自动填充，需要提示用户手动完成）。
  /// 返回逗号分隔的命中控件标识（name/id/placeholder），空串表示未检测到。
  /// 识别依据：控件的 name/id/placeholder/aria-label 含验证码相关关键词。
  static const detectCaptcha = r'''
(function() {
  var keywords = [
    'captcha', 'verifycode', 'verify_code', 'verification', 'vcode',
    'authcode', 'auth_code', 'checkcode', 'check_code', 'smscode',
    'sms_code', 'validatecode', 'validate_code',
    '验证码', '图形码', '短信验证', '安全码'
  ];
  var els = document.querySelectorAll('input, textarea');
  var hits = [];
  for (var i = 0; i < els.length; i++) {
    var el = els[i];
    var desc = [
      (el.name || ''),
      (el.id || ''),
      (el.placeholder || ''),
      (el.getAttribute('aria-label') || '')
    ].join(' ').toLowerCase();
    var matched = false;
    for (var j = 0; j < keywords.length; j++) {
      if (desc.indexOf(keywords[j]) >= 0) { matched = true; break; }
    }
    if (matched) {
      var label = el.name || el.id || el.placeholder || ('input' + i);
      if (hits.indexOf(label) < 0) hits.push(label);
    }
  }
  return hits.join(',');
})();
''';
}