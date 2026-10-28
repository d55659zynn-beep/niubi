import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

/// 测试公共辅助：定位并加载 Isar 原生库。
///
/// flutter test 环境不会执行插件注册（GeneratedPluginRegistrant），
/// 因此先从 .dart_tool/package_config.json 找到 isar_community_flutter_libs
/// 的安装路径，再手动打开其动态库（macOS/arm64 上为 libisar.dylib）。
DynamicLibrary loadIsarNativeLib() {
  final cfg = File('.dart_tool/package_config.json');
  final packages =
      (jsonDecode(cfg.readAsStringSync()) as Map<String, dynamic>)['packages']
          as List;
  String? root;
  for (final p in packages) {
    final pkg = p as Map<String, dynamic>;
    if (pkg['name'] == 'isar_community_flutter_libs') {
      root = pkg['rootUri'] as String;
      break;
    }
  }
  if (root == null) {
    throw StateError('package_config.json 中找不到 isar_community_flutter_libs');
  }
  // rootUri 可能是相对路径，按测试进程 cwd 解析
  final resolved = Uri.base.resolve(root);
  final dir = File.fromUri(resolved).path;
  const candidates = [
    'macos/isar.xcframework/macos-arm64_x86_64/libisar.dylib',
    'macos/libisar.dylib',
    'linux/libisar.so',
  ];
  for (final c in candidates) {
    final full = '$dir/$c';
    if (File(full).existsSync()) return DynamicLibrary.open(full);
  }
  throw StateError('未找到 Isar 原生库（$dir 下无 $candidates）');
}