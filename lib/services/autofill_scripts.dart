/// 网申自动填表 JS 脚本库。
/// 进入投递页（WebView）后注入，按个人信息自动识别并填充网申表单。
/// 全部为本机生成字符串，不加载任何外部 JS。
class AutoFillScripts {
  AutoFillScripts._();

  /// 生成自动填表脚本，[jsonProfile] 为个人信息 JSON：
  /// {"name":...,"phone":...,"email":...,"school":...,"major":...,
  ///  "grade":...,"education":...,"intendedCity":...,"availableTime":...}
  /// 返回实际填充的字段数量（字符串形式）。
  static String fill(String jsonProfile) => r'''
(function() {
  var profile = ''' + jsonProfile + r''';
  if (!profile) return '0';

  // 关键词规则：按“具体 → 宽泛”排序，避免 name 等宽泛词误匹配。
  // 关键词覆盖牛客 / 实习僧 / BOSS直聘 三平台网申表单的常见字段命名
  // （含中文 label、英文 name/id、拼音缩写等）。
  var rules = [
    {keys: ['邮箱', 'email', 'mail', 'e-mail', 'emailaddress'], value: profile.email},
    {keys: ['手机', '电话', 'mobile', 'phone', 'tel', '联系电话', '手机号', 'phonenumber', 'phone_number'], value: profile.phone},
    {keys: ['学校', '院校', 'school', 'university', 'college', 'schoolname', 'school_name'], value: profile.school},
    {keys: ['专业', 'major', 'specialty', 'discipline', 'majorname', 'major_name'], value: profile.major},
    {keys: ['学历', 'education', 'degree', 'educationbackground', 'education_background'], value: profile.education},
    {keys: ['年级', 'grade', '届', 'graduation', 'graduationyear', 'graduation_year', '毕业年份'], value: profile.grade},
    {keys: ['意向城市', '意向地点', '期望城市', '期望地点', 'expectedcity', 'expectcity', 'expected_city'], value: profile.intendedCity},
    {keys: ['到岗', '入职时间', '可到岗', 'availabletime', 'available_time', 'onboardtime', 'onboard_time'], value: profile.availableTime},
    {keys: ['姓名', 'realname', 'real_name', 'username', 'fullname', 'full_name', '真实姓名'], value: profile.name}
  ];

  var filled = 0;

  // React/Vue 等框架需要触发原生 setter 才能识别值变化
  function setNativeValue(el, value) {
    var proto = el.tagName === 'TEXTAREA'
        ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype;
    var setter = Object.getOwnPropertyDescriptor(proto, 'value').set;
    setter.call(el, value);
    el.dispatchEvent(new Event('input', {bubbles: true}));
    el.dispatchEvent(new Event('change', {bubbles: true}));
  }

  // 汇总输入框的可识别描述：name/id/placeholder/aria-label/关联 label 文本
  function describe(el) {
    var label = '';
    try {
      if (el.labels && el.labels.length > 0) {
        label = el.labels[0].textContent || '';
      }
    } catch (e) { label = ''; }
    return [
      (el.name || ''),
      (el.id || ''),
      (el.placeholder || ''),
      (el.getAttribute('aria-label') || ''),
      label
    ].join(' ').toLowerCase();
  }

  var inputs = document.querySelectorAll('input, textarea, select');
  for (var i = 0; i < inputs.length; i++) {
    var el = inputs[i];
    var t = (el.type || 'input').toLowerCase();
    // 跳过无需自动填写的控件（文件上传/密码/按钮等由用户手动处理）
    if (t === 'hidden' || t === 'submit' || t === 'button' ||
        t === 'file' || t === 'password' || t === 'checkbox' || t === 'radio') {
      continue;
    }
    var desc = describe(el);
    if (!desc) continue;

    for (var j = 0; j < rules.length; j++) {
      var rule = rules[j];
      if (!rule.value) continue;
      var hit = false;
      for (var k = 0; k < rule.keys.length; k++) {
        if (desc.indexOf(rule.keys[k].toLowerCase()) >= 0) { hit = true; break; }
      }
      if (!hit) continue;

      if (el.tagName === 'SELECT') {
        // 下拉框：按选项文本或 value 匹配
        for (var o = 0; o < el.options.length; o++) {
          var opt = el.options[o];
          if (opt.text.indexOf(rule.value) >= 0 || opt.value === rule.value) {
            el.selectedIndex = o;
            break;
          }
        }
        el.dispatchEvent(new Event('change', {bubbles: true}));
        filled++;
      } else if (el.value !== rule.value) {
        setNativeValue(el, rule.value);
        filled++;
      } else {
        filled++;
      }
      break;
    }
  }
  return String(filled);
})();
''';

  /// 统计页面可填写的候选输入框数量（用于判断是否识别到网申表单）
  static const countInputs = r'''
(function() {
  var count = 0;
  var inputs = document.querySelectorAll('input, textarea, select');
  for (var i = 0; i < inputs.length; i++) {
    var t = (inputs[i].type || 'input').toLowerCase();
    if (t === 'hidden' || t === 'submit' || t === 'button' ||
        t === 'file' || t === 'password' || t === 'checkbox' || t === 'radio') {
      continue;
    }
    count++;
  }
  return String(count);
})();
''';
}