import 'package:flutter/material.dart';

import '../../db/resume_repo.dart';
import '../../db/schemas/resume_template.dart';
import 'resume_edit_page.dart';

/// 简历模板列表：多套模板的切换、新建、编辑、删除。
/// 激活的模板用于后续 WebView 一键填充。
class ResumeListPage extends StatefulWidget {
  const ResumeListPage({super.key});

  @override
  State<ResumeListPage> createState() => _ResumeListPageState();
}

class _ResumeListPageState extends State<ResumeListPage> {
  List<ResumeTemplate>? _templates;
  bool _dbError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// 从本地 Isar 加载模板列表
  Future<void> _load() async {
    try {
      final list = await ResumeRepo.instance.getAll();
      if (!mounted) return;
      setState(() {
        _templates = list;
        _dbError = false;
      });
    } catch (_) {
      // 数据库未就绪（如测试环境未初始化 Isar）时显示提示，避免崩溃
      if (!mounted) return;
      setState(() => _dbError = true);
    }
  }

  /// 新建模板：弹出名称输入框
  Future<void> _createTemplate() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建简历模板'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '如：后端岗位通用版'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('创建'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    // 第一套模板自动设为激活，方便直接使用
    final tpl = await ResumeRepo.instance.create(name);
    final all = await ResumeRepo.instance.getAll();
    if (all.length == 1) {
      await ResumeRepo.instance.setActive(tpl);
    }
    await _load();
  }

  /// 打开编辑页，返回后刷新列表
  Future<void> _openEdit(ResumeTemplate? tpl) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResumeEditPage(template: tpl)),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final templates = _templates;
    return Scaffold(
      appBar: AppBar(title: const Text('简历模板')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTemplate,
        icon: const Icon(Icons.add),
        label: const Text('新建模板'),
      ),
      body: _dbError
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '本地数据库未就绪，请重启应用后再试。',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : templates == null
          ? const Center(child: CircularProgressIndicator())
          : templates.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      '还没有简历模板。\n点右下角新建一套，所有内容仅保存在本机，不会上传。',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                    itemCount: templates.length,
                    itemBuilder: (context, i) =>
                        _TemplateCard(tpl: templates[i], parent: this),
                  ),
                ),
    );
  }
}

/// 单个模板卡片：激活标记 + 名称 + 操作菜单
class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.tpl, required this.parent});

  final ResumeTemplate tpl;
  final _ResumeListPageState parent;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除模板'),
        content: Text('确定删除「${tpl.templateName}」吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ResumeRepo.instance.delete(tpl);
    await parent._load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tpl.isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            tpl.isActive ? Icons.check : Icons.description_outlined,
            color: tpl.isActive
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(tpl.templateName),
        subtitle: Text(
          tpl.isActive
              ? '当前激活 · ${tpl.personName.isEmpty ? "待填写" : tpl.personName}'
              : '未激活 · 更新于 ${_fmt(tpl.updatedAt)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) async {
            switch (v) {
              case 'activate':
                await ResumeRepo.instance.setActive(tpl);
                await parent._load();
              case 'edit':
                await parent._openEdit(tpl);
              case 'delete':
                await _confirmDelete(context);
            }
          },
          itemBuilder: (context) => [
            if (!tpl.isActive)
              const PopupMenuItem(
                value: 'activate',
                child: Text('设为激活'),
              ),
            const PopupMenuItem(value: 'edit', child: Text('编辑')),
            const PopupMenuItem(value: 'delete', child: Text('删除')),
          ],
        ),
        onTap: () => parent._openEdit(tpl),
      ),
    );
  }

  /// 简化时间显示：MM-dd HH:mm
  static String _fmt(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.month}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  }
}