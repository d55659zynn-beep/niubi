import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../db/personal_profile_repo.dart';
import '../../db/schemas/personal_profile.dart';
import '../resume/pdf_preview_page.dart';
import '../settings/settings_page.dart';

/// 个人信息管理页：
/// 保存网申自动填表所需的个人基础信息与 PDF 简历。
/// ⚠️ 所有信息仅保存在本机 Isar 数据库，不会上传到任何外部服务器。
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late PersonalProfile _profile;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _schoolCtrl;
  late final TextEditingController _majorCtrl;
  late final TextEditingController _gradeCtrl;
  late final TextEditingController _educationCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _availableCtrl;

  var _loading = true;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _schoolCtrl = TextEditingController();
    _majorCtrl = TextEditingController();
    _gradeCtrl = TextEditingController();
    _educationCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _availableCtrl = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _schoolCtrl.dispose();
    _majorCtrl.dispose();
    _gradeCtrl.dispose();
    _educationCtrl.dispose();
    _cityCtrl.dispose();
    _availableCtrl.dispose();
    super.dispose();
  }

  /// 从本地 Isar 读取已保存的个人信息
  Future<void> _load() async {
    try {
      final saved = await PersonalProfileRepo.instance.get();
      _profile = saved ?? PersonalProfileRepo.empty();
    } catch (_) {
      // 数据库未就绪时使用空数据，避免崩溃
      _profile = PersonalProfileRepo.empty();
    }
    _fillControllers();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  void _fillControllers() {
    _nameCtrl.text = _profile.name;
    _phoneCtrl.text = _profile.phone;
    _emailCtrl.text = _profile.email;
    _schoolCtrl.text = _profile.school;
    _majorCtrl.text = _profile.major;
    _gradeCtrl.text = _profile.grade;
    _educationCtrl.text = _profile.education;
    _cityCtrl.text = _profile.intendedCity;
    _availableCtrl.text = _profile.availableTime;
  }

  /// 保存个人信息到本地 Isar
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      _profile
        ..name = _nameCtrl.text.trim()
        ..phone = _phoneCtrl.text.trim()
        ..email = _emailCtrl.text.trim()
        ..school = _schoolCtrl.text.trim()
        ..major = _majorCtrl.text.trim()
        ..grade = _gradeCtrl.text.trim()
        ..education = _educationCtrl.text.trim()
        ..intendedCity = _cityCtrl.text.trim()
        ..availableTime = _availableCtrl.text.trim();
      await PersonalProfileRepo.instance.save(_profile);
      if (!mounted) return;
      _showTip('个人信息已保存到本机（不会上传）');
    } catch (e) {
      if (!mounted) return;
      _showTip('保存失败：$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// 选择本机 PDF 简历（只保存路径，不上传）
  Future<void> _pickPdf() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final path = files.isEmpty ? null : files.first.path;
    if (path == null || !mounted) return;
    setState(() => _profile.resumePdfPath = path);
    _showTip('简历已选择，记得点保存');
  }

  Future<void> _previewPdf() async {
    final path = _profile.resumePdfPath;
    if (path == null || !File(path).existsSync()) {
      _showTip('PDF 文件不存在，请重新选择');
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PdfPreviewPage(path: path)),
    );
  }

  void _showTip(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        actions: [
          // 设置页入口：推送开关 / BOSS直聘 Cookie
          IconButton(
            tooltip: '设置',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 隐私说明（本地存储约束）
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline,
                            size: 18, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '信息仅保存在本机 Isar 数据库，不会上传任何服务器；'
                            '网申自动填表时才会读取使用。',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle(theme, '基础信息'),
                  _field(
                    controller: _nameCtrl,
                    label: '姓名',
                    hint: '如：张三',
                  ),
                  _field(
                    controller: _phoneCtrl,
                    label: '手机号',
                    hint: '如：13800138000',
                    keyboardType: TextInputType.phone,
                  ),
                  _field(
                    controller: _emailCtrl,
                    label: '邮箱',
                    hint: '如：zhangsan@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  _sectionTitle(theme, '教育背景'),
                  _field(
                    controller: _schoolCtrl,
                    label: '学校',
                    hint: '如：示例大学',
                  ),
                  _field(
                    controller: _majorCtrl,
                    label: '专业',
                    hint: '如：物流管理',
                  ),
                  _field(
                    controller: _gradeCtrl,
                    label: '年级',
                    hint: '如：大二 / 2027 届',
                  ),
                  _field(
                    controller: _educationCtrl,
                    label: '学历',
                    hint: '如：本科 / 硕士',
                  ),
                  const SizedBox(height: 8),
                  _sectionTitle(theme, '求职意向'),
                  _field(
                    controller: _cityCtrl,
                    label: '意向城市',
                    hint: '如：成都、武汉（多个用顿号分隔）',
                  ),
                  _field(
                    controller: _availableCtrl,
                    label: '可到岗时间',
                    hint: '如：随时到岗 / 2026年7月',
                  ),
                  const SizedBox(height: 8),
                  _sectionTitle(theme, 'PDF 简历（本机文件）'),
                  _buildPdfTile(theme),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: Icon(_saving ? Icons.hourglass_top : Icons.save),
                    label: Text(_saving ? '保存中…' : '保存个人信息'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: theme.textTheme.titleSmall),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  /// PDF 上传 / 预览 / 清除操作区
  Widget _buildPdfTile(ThemeData theme) {
    final path = _profile.resumePdfPath;
    final exists = path != null && File(path).existsSync();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf),
        title: Text(
          exists ? path.split('/').last : '未选择 PDF 简历',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: const Text('仅保存本机文件路径，不上传'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (exists)
              IconButton(
                tooltip: '预览',
                icon: const Icon(Icons.visibility),
                onPressed: _previewPdf,
              ),
            if (path != null)
              IconButton(
                tooltip: '清除',
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _profile.resumePdfPath = null),
              ),
            IconButton(
              tooltip: '选择 PDF',
              icon: const Icon(Icons.upload_file),
              onPressed: _pickPdf,
            ),
          ],
        ),
      ),
    );
  }
}