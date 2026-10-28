import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../db/resume_repo.dart';
import '../../db/schemas/resume_template.dart';
import 'pdf_preview_page.dart';

/// 简历模板编辑页：基本信息 + 实习/项目经历 + 技能 + 自定义字段 + PDF。
/// 新建时传入 null，保存后写入本地 Isar。
class ResumeEditPage extends StatefulWidget {
  const ResumeEditPage({super.key, this.template});

  /// 已有模板；null 表示新建
  final ResumeTemplate? template;

  @override
  State<ResumeEditPage> createState() => _ResumeEditPageState();
}

class _ResumeEditPageState extends State<ResumeEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final ResumeTemplate _tpl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _personNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _schoolCtrl;
  late final TextEditingController _majorCtrl;
  late final TextEditingController _educationCtrl;
  late final TextEditingController _skillsCtrl;

  var _saving = false;

  /// 是否有未保存的修改（离开页面时提示）
  var _dirty = false;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      // 编辑：深拷贝传入模板，避免直接改动列表页缓存的对象
      _tpl = _copyTemplate(widget.template!);
    } else {
      // 新建：late 列表字段必须显式初始化，否则读写会抛错
      _tpl = ResumeTemplate()
        ..internships = <ResumeExperience>[]
        ..projects = <ResumeExperience>[]
        ..customFields = <CustomField>[];
    }
    _nameCtrl = TextEditingController(text: _tpl.templateName);
    _personNameCtrl = TextEditingController(text: _tpl.personName);
    _phoneCtrl = TextEditingController(text: _tpl.phone);
    _emailCtrl = TextEditingController(text: _tpl.email);
    _schoolCtrl = TextEditingController(text: _tpl.school);
    _majorCtrl = TextEditingController(text: _tpl.major);
    _educationCtrl = TextEditingController(text: _tpl.education);
    _skillsCtrl = TextEditingController(text: _tpl.skills);
    // 任何输入变化都标记为“有未保存修改”（只在首次变化时重建）
    for (final c in <TextEditingController>[
      _nameCtrl,
      _personNameCtrl,
      _phoneCtrl,
      _emailCtrl,
      _schoolCtrl,
      _majorCtrl,
      _educationCtrl,
      _skillsCtrl,
    ]) {
      c.addListener(_markDirty);
    }
  }

  /// 标记有未保存修改
  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  /// 深拷贝模板（含内嵌经历、自定义字段），保留 id 以便更新原记录
  static ResumeTemplate _copyTemplate(ResumeTemplate src) {
    return ResumeTemplate()
      ..id = src.id
      ..templateName = src.templateName
      ..isActive = src.isActive
      ..personName = src.personName
      ..phone = src.phone
      ..email = src.email
      ..school = src.school
      ..major = src.major
      ..education = src.education
      ..internships = src.internships.map(_copyExperience).toList()
      ..projects = src.projects.map(_copyExperience).toList()
      ..skills = src.skills
      ..customFields = src.customFields
          .map(
            (f) => CustomField()
              ..key = f.key
              ..value = f.value,
          )
          .toList()
      ..pdfLocalPath = src.pdfLocalPath
      ..updatedAt = src.updatedAt;
  }

  static ResumeExperience _copyExperience(ResumeExperience e) =>
      ResumeExperience()
        ..title = e.title
        ..org = e.org
        ..timeRange = e.timeRange
        ..content = e.content;

  /// 电话格式校验：非必填；填了则允许数字、+、-、空格，6~20 位
  static String? _validatePhone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return RegExp(r'^[0-9+\-\s]{6,20}$').hasMatch(t) ? null : '电话格式不正确';
  }

  /// 邮箱格式校验：非必填；填了则要求形如 a@b.c
  static String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t) ? null : '邮箱格式不正确';
  }

  /// 离开前确认：有未保存修改时弹窗
  Future<bool?> _confirmDiscard() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃修改？'),
        content: const Text('当前修改尚未保存，离开后将丢失。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('继续编辑'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _personNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _schoolCtrl.dispose();
    _majorCtrl.dispose();
    _educationCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  /// 表单内容回填到 _tpl 并保存
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      _tpl.templateName = _nameCtrl.text.trim();
      _tpl.personName = _personNameCtrl.text.trim();
      _tpl.phone = _phoneCtrl.text.trim();
      _tpl.email = _emailCtrl.text.trim();
      _tpl.school = _schoolCtrl.text.trim();
      _tpl.major = _majorCtrl.text.trim();
      _tpl.education = _educationCtrl.text.trim();
      _tpl.skills = _skillsCtrl.text.trim();
      await ResumeRepo.instance.save(_tpl);
      if (!mounted) return;
      _dirty = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('已保存「${_tpl.templateName}」')));
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// 选择本机 PDF 作为简历附件（file_picker 只选文件，不上传）
  Future<void> _pickPdf() async {
    // 13.x 版本：FilePicker.pickFiles 为静态方法，取消时返回空列表
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    final path = files.isEmpty ? null : files.first.path;
    if (path == null || !mounted) return;
    setState(() {
      _tpl.pdfLocalPath = path;
      _dirty = true;
    });
  }

  Future<void> _previewPdf() async {
    final path = _tpl.pdfLocalPath;
    if (path == null || !File(path).existsSync()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PDF 文件不存在，请重新选择')));
      return;
    }
    if (!mounted) return;
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfPreviewPage(path: path)));
  }

  /// 添加或编辑一段经历（实习/项目共用）
  Future<void> _editExperience(
    List<ResumeExperience> list, {
    int? index,
    required String title,
  }) async {
    final item = index != null ? list[index] : ResumeExperience();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => _ExperienceDialog(
        dialogTitle: index != null ? '编辑$title' : '添加$title',
        item: item,
      ),
    );
    if (ok != true) return;
    setState(() {
      if (index != null) {
        list[index] = item;
      } else {
        list.add(item);
      }
      _dirty = true;
    });
  }

  /// 删除一段经历
  void _removeExperience(List<ResumeExperience> list, int index) {
    setState(() {
      list.removeAt(index);
      _dirty = true;
    });
  }

  /// 添加 / 编辑自定义字段（key → value）
  Future<void> _editCustomField(int? index) async {
    final isNew = index == null;
    final keyCtrl = TextEditingController(
      text: isNew ? '' : _tpl.customFields[index].key,
    );
    final valCtrl = TextEditingController(
      text: isNew ? '' : _tpl.customFields[index].value,
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? '添加自定义字段' : '编辑自定义字段'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyCtrl,
              decoration: const InputDecoration(
                labelText: '字段名',
                hintText: '如：毕业时间',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: valCtrl,
              decoration: const InputDecoration(labelText: '字段值'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final key = keyCtrl.text.trim();
              if (key.isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() {
      if (isNew) {
        _tpl.customFields.add(
          CustomField()
            ..key = keyCtrl.text.trim()
            ..value = valCtrl.text.trim(),
        );
      } else {
        _tpl.customFields[index].key = keyCtrl.text.trim();
        _tpl.customFields[index].value = valCtrl.text.trim();
      }
      _dirty = true;
    });
  }

  void _removeCustomField(int index) {
    setState(() {
      _tpl.customFields.removeAt(index);
      _dirty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 有未保存修改时拦截返回，弹窗确认后再离开
    return PopScope(
      canPop: !_dirty || _saving,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmDiscard();
        if (leave != true) return;
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.template == null ? '新建简历' : '编辑简历')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: '模板名称',
                  hintText: '如：后端岗位通用版',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '请输入模板名称' : null,
              ),
              const SizedBox(height: 16),
              _sectionTitle('基本信息'),
              TextFormField(
                controller: _personNameCtrl,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '电话',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _schoolCtrl,
                decoration: const InputDecoration(
                  labelText: '学校',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _majorCtrl,
                decoration: const InputDecoration(
                  labelText: '专业',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _educationCtrl,
                decoration: const InputDecoration(
                  labelText: '学历',
                  hintText: '如：本科 / 硕士 / 博士',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skillsCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '技能',
                  hintText: '用顿号或换行分隔，如：Java、Spring、MySQL',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('实习经历'),
              ..._experienceSection(_tpl.internships),
              const SizedBox(height: 16),
              _sectionTitle('项目经历'),
              ..._experienceSection(_tpl.projects),
              const SizedBox(height: 16),
              _sectionTitle('自定义字段（网页映射可选）'),
              if (_tpl.customFields.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    '暂无自定义字段，可添加键值对供网页表单绑定',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ..._tpl.customFields.asMap().entries.map(
                (e) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.key),
                  title: Text(e.value.key),
                  subtitle: Text(e.value.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _removeCustomField(e.key),
                  ),
                  onTap: () => _editCustomField(e.key),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _editCustomField(null),
                  icon: const Icon(Icons.add),
                  label: const Text('添加自定义字段'),
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('PDF 简历（本机预览）'),
              _buildPdfTile(),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: Icon(_saving ? Icons.hourglass_top : Icons.save),
                label: Text(_saving ? '保存中…' : '保存模板'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 分节标题
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );

  /// 一段经历列表 + “添加”按钮（实习与项目共用）
  List<Widget> _experienceSection(List<ResumeExperience> list) {
    return [
      if (list.isEmpty)
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('暂无，点下方添加', style: TextStyle(color: Colors.grey)),
        ),
      ...list.asMap().entries.map(
        (e) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            title: Text(e.value.title.isEmpty ? '（未命名）' : e.value.title),
            subtitle: Text(
              '${e.value.org}${e.value.timeRange.isEmpty ? "" : " · ${e.value.timeRange}"}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeExperience(list, e.key),
            ),
            onTap: () => _editExperience(list, index: e.key, title: '经历'),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _editExperience(list, title: '经历'),
          icon: const Icon(Icons.add),
          label: const Text('添加经历'),
        ),
      ),
    ];
  }

  /// PDF 上传 / 预览 / 清除操作区
  Widget _buildPdfTile() {
    final path = _tpl.pdfLocalPath;
    final exists = path != null && File(path).existsSync();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf),
        title: Text(
          path != null && exists ? path.split('/').last : '未选择 PDF',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
                onPressed: () => setState(() {
                  _tpl.pdfLocalPath = null;
                  _dirty = true;
                }),
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

/// 一段经历（实习/项目）的编辑对话框：标题、单位、时间、内容
class _ExperienceDialog extends StatefulWidget {
  const _ExperienceDialog({required this.dialogTitle, required this.item});

  final String dialogTitle;
  final ResumeExperience item;

  @override
  State<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<_ExperienceDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _orgCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item.title);
    _orgCtrl = TextEditingController(text: widget.item.org);
    _timeCtrl = TextEditingController(text: widget.item.timeRange);
    _contentCtrl = TextEditingController(text: widget.item.content);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _orgCtrl.dispose();
    _timeCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '如：后端开发实习生',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _orgCtrl,
              decoration: const InputDecoration(
                labelText: '单位',
                hintText: '如：某某科技有限公司',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _timeCtrl,
              decoration: const InputDecoration(
                labelText: '时间',
                hintText: '如：2025.06 - 2025.09',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '内容',
                hintText: '主要工作与成果',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            widget.item.title = _titleCtrl.text.trim();
            widget.item.org = _orgCtrl.text.trim();
            widget.item.timeRange = _timeCtrl.text.trim();
            widget.item.content = _contentCtrl.text.trim();
            Navigator.pop(context, true);
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
