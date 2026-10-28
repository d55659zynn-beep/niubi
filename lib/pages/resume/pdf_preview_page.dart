import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

/// PDF 简历预览页：用 pdfx 加载本机 PDF 文件，仅本地渲染，不上传。
class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({super.key, required this.path});

  /// 本机 PDF 文件路径
  final String path;

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  PdfController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final file = File(widget.path);
    if (!file.existsSync()) {
      _failed = true;
      return;
    }
    try {
      _controller = PdfController(document: PdfDocument.openFile(widget.path));
    } catch (_) {
      // 文件已损坏或非 PDF 时进入失败态
      _failed = true;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF 预览')),
      body: _failed
          ? const Center(child: Text('无法打开该 PDF 文件'))
          : PdfView(
              controller: _controller!,
              // 页面切换/滚动时由 pdfx 自行处理，这里不做额外逻辑
            ),
    );
  }
}