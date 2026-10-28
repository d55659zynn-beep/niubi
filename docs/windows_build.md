# Windows 桌面端构建与运行指南

> 本项目 macOS / Windows / iOS / Android 四端共用同一套 Dart 代码；
> Windows 端使用 Flutter Windows 桌面嵌入 + Isar 原生库（x64）。

## 一、环境要求（Windows 机器）

1. **Windows 10/11（64 位）**
2. **Flutter SDK**（3.13.7+；本项目验证环境 Flutter 3.47.8 / Dart 3.13.7）
3. **Visual Studio 2022**，安装工作负载：
   - 「使用 C++ 的桌面开发」（Desktop development with C++）
   - 含 Windows 10/11 SDK、MSVC v143 工具集
4. **Git**（可选，便于拉取代码）
5. 开启 Flutter Windows 桌面支持：
   ```powershell
   flutter config --enable-windows-desktop
   flutter doctor -v     # 确认 Visual Studio / Windows 工具链正常
   ```

## 二、构建与运行

```powershell
cd wangshen_app

# 1. 安装依赖 + 生成 Isar 代码
flutter pub get
dart run build_runner build

# 2. 调试运行（自动编译并启动窗口）
flutter run -d windows

# 3. 打 Release 包（生成 exe 与运行依赖）
flutter build windows --release
```

### 产物位置

```
build\windows\x64\runner\Release\
├── wangshen_app.exe              # 双击运行的入口
├── flutter_windows.dll           # Flutter 运行时
├── isar.dll（或 libisar 相关）    # Isar 原生库
└── data\                         # 资源与 ICU 数据
```

> **分发方式**：双击 `wangshen_app.exe` 即可运行，但需要**整个 Release 目录**一起分发
> （不能只拷 exe）。可用 Inno Setup / 7-Zip 打包整个目录。个人自用直接双击同样有效。

## 三、Windows 本地数据库文件存放路径（重要）

App 使用 `path_provider` 的 `getApplicationDocumentsDirectory()` 作为 Isar 目录：

| 项目 | 路径 |
|------|------|
| 数据库目录 | `C:\Users\<你的Windows用户名>\Documents` |
| 数据库文件 | `C:\Users\<用户名>\Documents\wangshen_local.isar` |
| 说明 | Isar 单文件数据库；运行时可能伴随 `wangshen_local.isar.lock` 等锁文件，属正常现象 |

- 所有岗位/简历/个人信息/映射配置都在该文件中，**仅存本机，不上传服务器**
- 备份：直接复制 `wangshen_local.isar` 文件
- 清空数据：关闭 App 后删除该文件（下次启动自动重建空库）
- 换机迁移：把 `.isar` 文件拷贝到新机器的相同路径

> 注：`Documents` 路径受 Windows 用户目录重定向影响（如 OneDrive 备份），
> 实际以 `%USERPROFILE%\Documents` 为准。

## 四、Windows 端功能说明

| 功能 | Windows 支持 |
|------|-------------|
| 多平台岗位抓取（牛客/实习僧/BOSS直聘） | ✅（需网络；BOSS 受反爬限制） |
| 筛选 / 搜索 / 收藏 / 简历 / 个人信息 | ✅ |
| PDF 简历上传与预览 | ✅（pdfx 桌面渲染） |
| 「打开投递页面」唤起系统浏览器 | ✅（url_launcher 调用默认浏览器） |
| **网申自动填表（内嵌 WebView）** | ❌ 桌面端显示降级提示（同 macOS），请用手机端 |
| 截止日期本地通知 | ⚠️ 桌面端通知能力有限，以手机端为准 |

## 五、常见问题

| 问题 | 处理 |
|------|------|
| `flutter doctor` 报 Visual Studio 未安装 | 安装 VS 2022「使用 C++ 的桌面开发」工作负载 |
| Isar 编译报 `libisar` 相关错误 | 确认 `isar_community_flutter_libs` 依赖存在，并执行 `flutter pub get` 后重新构建 |
| 窗口缩放后布局异常 | 页面为响应式布局（ListView / Wrap），极小窗口下可能出现滚动，不影响功能 |
| 双击 exe 闪退 | 需在 Release 目录内双击（依赖 dll 与 data 目录）；检查是否被杀软拦截 |
| 深色主题 | 跟随 Windows 系统深/浅色设置，可在系统「颜色」中切换 |
