# 网申辅助 · wangshen_app

个人自用的实习生网申投递工具（Flutter 四端：macOS / Windows / iOS / Android）。

- **多平台岗位聚合**：自动抓取牛客、实习僧、BOSS直聘实习岗位（各平台独立 30 分钟节流），
  物流/供应链/采购/运营类岗位自动打标签，本地 Isar 去重
- **筛选与搜索**：招聘平台多选、城市、岗位方向、截止时间、实习生专区开关、本地关键词搜索
- **个人信息与自动填表**：本地保存个人信息与 PDF 简历，手机端 WebView 自动填充网申表单
- **本地通知**：岗位截止日期每日本地提醒

**所有数据仅保存在本机 Isar 数据库，不上传任何服务器，不包含登录、支付、广告、云服务。**

> 项目定位：个人自用工具，不上架应用商店。
> 另外提供独立 Python 脚本（crawler/），可在电脑端导出岗位 JSON 手动导入。

---

## 1. 项目介绍

### 功能模块

| 模块 | 功能 |
|------|------|
| **多平台抓取** | 牛客 / 实习僧 / BOSS直聘 实习岗位；每平台独立 30 分钟节流、请求间隔与并发限制；单平台失败弹窗提示、不影响其他平台；平台来源标记；标题+公司 sha256 稳定 Id 去重 |
| **岗位聚合** | 岗位列表、下拉刷新、详情（公司/岗位/地点/方向/截止时间/JD/投递链接）、筛选（平台/城市/方向/截止时间/实习生专区）、本地关键词搜索（标题+JD）、本地收藏、截止日期本地通知 |
| **简历管理** | 9 项基本信息、实习/项目经历、自定义字段、多套模板切换保存、PDF 上传与预览（全部本地存储） |
| **个人信息** | 姓名/手机/邮箱/学校/专业/年级/学历/意向城市/可到岗时间，PDF 简历上传；仅本地 Isar 存储 |
| **网申自动填表** | 手机端（Android/iOS）WebView 加载投递页 + JS 注入自动填入个人信息；桌面端（macOS/Windows）自动降级提示，不崩溃 |
| **配套爬虫** | 独立 Python 脚本（标准库零依赖），导出与 APP 导入格式一致的岗位 JSON |

### 技术栈

| 层 | 技术 |
|----|------|
| UI | Flutter Material3，深浅色主题（跟随系统），响应式布局 |
| 数据库 | Isar（`isar_community`，纯本地存储，四端原生库） |
| 网络抓取 | http + html（CSS 选择器解析）+ crypto（sha256 去重） |
| 系统浏览器 | url_launcher（打开投递链接） |
| 自动填表 | webview_flutter + JS 注入（仅手机端） |
| 本地通知 | flutter_local_notifications + timezone |
| PDF | pdfx（本机文件预览） |
| 文件选择 | file_picker |

### 四端支持

| 能力 | macOS | Windows | iOS（含 iPhone 真机） | Android |
|------|-------|---------|----------------------|---------|
| 岗位抓取 / 筛选 / 搜索 / 收藏 | ✅ | ✅ | ✅ | ✅ |
| 简历 / 个人信息 / PDF 上传 | ✅ | ✅ | ✅ | ✅ |
| 打开投递页（系统浏览器） | ✅ | ✅ | ✅ | ✅ |
| 网申自动填表（内嵌 WebView） | ❌ 降级提示 | ❌ 降级提示 | ✅ | ✅ |
| 截止日期本地通知 | ⚠️ 有限 | ⚠️ 有限 | ✅ | ✅ |

> 部署文档：[iOS 真机部署（免费 Apple ID）](docs/ios_deploy.md) ·
> [Windows 构建与数据库路径](docs/windows_build.md) · [Android 构建与安装](docs/android_build.md)

### 目录结构（核心代码）

```
wangshen_app/
├── lib/
│   ├── main.dart                    # 入口：初始化 Isar + 通知（通知失败容错）
│   ├── app.dart                     # MaterialApp 根组件
│   ├── theme/app_theme.dart         # Material3 深浅色主题
│   ├── db/
│   │   ├── isar_service.dart        # Isar 单例（注册 4 个集合）
│   │   ├── job_repo.dart            # 岗位：导入/筛选/收藏/抓取入库（稳定 Id 覆盖）
│   │   ├── resume_repo.dart         # 简历模板多套管理
│   │   ├── personal_profile_repo.dart # 个人信息（单条记录）
│   │   ├── form_mapping_repo.dart   # 网站表单映射（预留）
│   │   └── schemas/                 # Isar 模型 + 生成代码（*.g.dart）
│   ├── pages/
│   │   ├── home_shell.dart          # 底部导航（岗位/简历/我的）
│   │   ├── jobs/                    # 岗位列表（搜索/筛选/平台标记）、岗位详情
│   │   ├── resume/                  # 模板列表、编辑表单、PDF 预览
│   │   └── profile/                 # 个人信息管理、自动填表页
│   └── services/
│       ├── job_scraper.dart             # 单平台抓取（多列表页/详情 JD/标签/聚焦过滤）
│       ├── multi_platform_scraper.dart  # 三平台编排（独立节流、失败隔离）
│       ├── job_filter.dart              # 本地过滤（平台/实习生/关键词）
│       ├── autofill_scripts.dart        # 自动填表 JS（三平台表单兼容）
│       ├── notification_service.dart    # 截止提醒本地通知
│       ├── web_filler_scripts.dart      # 网页映射填充 JS（预留）
│       ├── js_result_parser.dart        # JS 返回值解析
│       └── fill_config_builder.dart     # 简历值 → 填充配置
├── crawler/                         # 独立 Python 爬虫（导出 JSON 导入）
├── docs/                            # 部署文档（iOS / Windows / Android）
├── test/                            # 单元测试（89 个用例）
└── android/ · ios/ · macos/ · windows/  # 四端平台工程
```

---

## 2. 环境准备

| 依赖 | 版本要求 | 说明 |
|------|---------|------|
| Flutter SDK | 3.13.7+（Dart ^3.13.7） | 开发环境 Flutter 3.47.8 |
| Xcode | macOS 上构建 iOS/macOS | 需 CocoaPods |
| Visual Studio 2022 | Windows 端构建 | 使用 C++ 桌面开发工作负载 |
| Android Studio / SDK | Android 端构建 | JDK 17、API 33+ |
| Python | 3.9+ | 仅 crawler 脚本需要（标准库） |

```bash
flutter pub get
dart run build_runner build     # 首次或 schema 变更后生成 Isar 代码
```

---

## 3. 编译与运行

```bash
# 静态检查 + 单元测试
flutter analyze
flutter test                    # 89 个用例

# 各端运行 / 构建
flutter run -d macos --no-enable-impeller   # macOS
flutter run -d windows                       # Windows（需 Windows 主机）
flutter run -d <iPhone 设备ID>                # iPhone 真机（免费签名见 docs/ios_deploy.md）
flutter run -d <Android 设备ID>               # Android

flutter build macos --release
flutter build windows --release             # 产物 build\windows\x64\runner\Release\
flutter build ios --simulator               # iOS 模拟器编译（已验证通过）
flutter build apk --release                 # Android APK
```

---

## 4. 使用教程

### 4.1 岗位抓取与浏览（三平台自动）

1. 打开 APP「岗位」页 → 自动抓取牛客/实习僧/BOSS直聘实习岗位
   - 首次显示「正在抓取岗位信息...」 Loading
   - 每个平台独立 30 分钟节流，期间重复进入不重复请求
   - 单平台失败弹窗提示失败原因，其他平台数据正常
2. 岗位卡片显示来源平台标记（牛客 / 实习僧 / BOSS直聘 / 导入）
3. 顶部搜索框检索**本地缓存**岗位标题与 JD（不触发抓取）
4. 右上角「筛选」：实习生专区开关（过滤全职）、招聘平台多选、
   城市（北京/上海/广州/深圳/杭州/成都/武汉/南京/苏州/东莞/西安）、
   岗位方向（物流/供应链、运营、采购、市场、财务、人力、产品、后端、嵌入式、算法）、
   截止时间
5. 点击岗位查看详情 / 收藏 / 开启截止提醒

### 4.2 个人信息与自动填表

1. 底部「我的」→ 填写个人信息 → 保存（仅本机 Isar）
2. 选择 PDF 简历（本机文件，预览/清除）
3. 岗位详情 →「自动填表」：
   - 手机端：WebView 打开投递页，自动识别并填入姓名/手机/邮箱/学校/专业/学历/年级/意向城市/到岗时间；PDF 需手动上传
   - 桌面端：显示降级提示（不崩溃），可点「用系统浏览器打开投递页」

### 4.3 数据存储位置

| 平台 | Isar 数据库路径 |
|------|----------------|
| macOS | `~/Documents/wangshen_local.isar` |
| Windows | `C:\Users\<用户名>\Documents\wangshen_local.isar` |
| iOS | App 沙盒 `Documents/wangshen_local.isar` |
| Android | `/data/data/<包名>/app_flutter/wangshen_local.isar` |

---

## 5. 已知限制

| 限制 | 说明 |
|------|------|
| BOSS直聘反爬 | 公开访问会被安全验证页拦截，抓取会失败并弹窗提示（不影响牛客/实习僧）；需要登录态的数据无法获取 |
| 实习僧 JD | 详情页 JD 为前端动态渲染，SSR 抓不到 → 该平台岗位 JD 可能为空，详情页显示「暂无岗位详细描述」 |
| 牛客数据池 | 牛客实习广场当前以技术岗为主，物流/供应链岗位较少；聚焦过滤在无相关岗位时保留全部岗位避免空白 |
| 验证码/文件上传 | 网申自动填表无法处理验证码；PDF 附件需手动上传 |
| 桌面端自动填表 | macOS/Windows 内嵌 WebView 不稳定（macOS 渲染器崩溃），桌面端自动降级为系统浏览器 |
| 免费 Apple ID | 证书 7 天过期、仅 USB 有线部署、无法分发 ipa（详见 docs/ios_deploy.md） |
| 无云同步 | 数据仅在本机，换设备需手动迁移 `.isar` 文件或重新录入 |

---

## 6. 开发备注

- **测试**：`flutter test` 89 个用例（抓取/解析/节流/去重/筛选/自动填表脚本/数据层）
- **测试环境 Isar**：flutter_test 不执行插件注册，`test/isar_test_helper.dart` 会从
  `package_config.json` 定位并加载 `libisar` 原生库
- **平台节流**：每个平台一个 `JobScraper` 实例，实例内 `_lastAttemptAt` 按 30 分钟窗口去重
- **失败隔离**：`MultiPlatformScraper` 逐个平台 try-catch，错误收集后由页面弹窗提示
- **去重**：岗位标题 + 公司名 sha256 前 48 位作为 Isar Id，相同岗位覆盖更新
- **UI 风格**：全部 Material3 + `Theme.of(context)` 配色，深浅色跟随系统

---

*本项目为个人自用工具；抓取请遵守目标网站 robots.txt 与用户协议，控制请求频率。*
