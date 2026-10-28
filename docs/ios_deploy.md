# iPhone 真机部署指南（免费 Apple ID · USB 有线）

> 适用：没有付费 Apple Developer 账号（$99/年），使用**免费 Apple ID** 在 iPhone 上安装本 App。
> 项目 Bundle ID：`com.wangshen.wangshenApp`（如与已有 App 冲突，改成你自己的唯一 ID，
> 例如 `com.yourname.wangshen`）。

## ⚠️ 免费 Apple ID 的限制（务必先读）

| 限制 | 说明 |
|------|------|
| **证书 7 天过期** | 免费签名证书有效期 7 天，到期后 App 图标变灰、无法打开 |
| **必须重新有线部署** | 7 天到期后需用 USB 连接 Mac，重新执行 `flutter run` 或 Xcode 重新安装 |
| **只能 USB 有线推送** | 无法导出 `.ipa` 分发/安装到其他设备，无法通过 AirDrop 安装 |
| **必须开启开发者模式** | iOS 16+ 需要在 iPhone「设置 → 隐私与安全性 → 开发者模式」手动开启（需重启手机） |
| **账号配额** | 免费账号最多 3 个自签 App、10 个 App ID |
| **首次信任** | 首次安装后需在「设置 → 通用 → VPN 与设备管理」中信任你的开发者证书 |
| **不支持推送/后台限制** | 免费签名不支持 Push 通知（本项目用本地通知，不受影响） |

## 一、环境准备

1. **Mac**（macOS 13+），已安装 **Xcode**（本项目验证环境 Xcode 27.1）
2. **iPhone**（iOS 15+，项目最低部署版本 iOS 15.0）
3. **USB 数据线** 连接 Mac 与 iPhone
4. **免费 Apple ID**（普通 iCloud 账号即可）
5. Flutter SDK（与 Mac 上开发环境一致）

```bash
# 确认 Xcode 与设备可用
xcode-select -p                  # 应指向 /Applications/Xcode.app/...
flutter doctor                   # 确认 iOS toolchain 正常
flutter devices                  # 连接 iPhone 后应能看到设备
```

## 二、Xcode 配置自动签名

1. 打开 Xcode → **Settings → Accounts** → 左下角 `+` → 添加 **Apple ID**（免费账号）
2. 进入项目 iOS 工程：
   ```bash
   cd wangshen_app
   flutter pub get
   cd ios && pod install && cd ..    # 首次或依赖变更后执行
   open ios/Runner.xcworkspace
   ```
3. Xcode 左侧选择 **Runner** target → **Signing & Capabilities**：
   - 勾选 **Automatically manage signing**
   - **Team** 选择你的个人 Apple ID（显示为 `Your Name (Personal Team)`）
   - **Bundle Identifier** 保持唯一（`com.wangshen.wangshenApp`；若提示已被占用，
     改为 `com.<你的名字>.wangshen` 并同步修改 `project.pbxproj` 中的 Bundle ID）
   - 若报错 `Failed to register bundle identifier`，换一个唯一 Bundle ID 即可
4. 若出现 `No profiles for 'com.wangshen.wangshenApp' were found`：
   保持自动签名，Xcode 会自动创建临时描述文件（免费账号支持 7 天）

## 三、iPhone 开启开发者模式

1. 用 USB 连接 iPhone 与 Mac，在 iPhone 上点「信任此电脑」
2. iPhone →「设置 → 隐私与安全性 → 开发者模式」→ 打开 → **重启手机** → 解锁后确认
   （iOS 16 以上才会显示该选项；iOS 15 无需开启）
3. 首次安装后，若提示"不受信任的开发者"：
   「设置 → 通用 → VPN 与设备管理 → 开发者 App → 信任」

## 四、运行与安装

```bash
# 方式一：Flutter 直接安装到真机（推荐，自动完成签名与安装）
flutter run -d <设备ID>        # 设备ID 用 flutter devices 查看

# 方式二：Xcode 中选中你的 iPhone 作为运行目标，点击 Run
```

> 首次构建较慢（CocoaPods + Xcode 编译）。成功后 App 会出现在 iPhone 桌面。

## 五、7 天到期后重新部署

1. USB 连接 iPhone 与 Mac
2. 直接重新执行：`flutter run -d <设备ID>`
   （Xcode 会自动刷新签名并重装；也可在 Xcode 中再次 Run）
3. 若仍提示证书过期：Xcode → Settings → Accounts → 选中 Apple ID → 下载手动描述文件，
   或删掉旧描述文件后让 Xcode 自动重建

## 六、ATS 与权限配置说明（项目已就绪）

`ios/Runner/Info.plist` 已配置：

- `NSAppTransportSecurity`：允许 HTTPS 访问牛客/实习僧/BOSS直聘，
  并为 `nowcoder.com`、`shixiseng.com`、`zhipin.com` 配置了显式域名例外
- `LSApplicationQueriesSchemes`：`http` / `https`，供 url_launcher 唤起系统浏览器
- 最低部署版本：iOS 15.0（`project.pbxproj` 中 `IPHONEOS_DEPLOYMENT_TARGET = 15.0`）

## 七、Isar 数据库在 iOS 上的说明

- Isar 通过 `isar_community_flutter_libs` 的 CocoaPods 集成（包含 iOS 真机/模拟器 slice）
- 数据库文件位于 App 沙盒：`<App 沙盒>/Documents/wangshen_local.isar`
- 模拟器路径示例：`~/Library/Developer/CoreSimulator/Devices/<设备ID>/data/Containers/Data/Application/<AppUUID>/Documents/wangshen_local.isar`
- 真机路径需在 Xcode → Devices and Simulators → 选中 App → Download Container 查看
- 数据不上传任何服务器；卸载 App 会一并删除本地数据库

## 八、常见问题

| 问题 | 处理 |
|------|------|
| `Xcode not installed` | 安装完整 Xcode（不是仅 Command Line Tools）并执行 `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` |
| `Pod install` 失败 | `cd ios && pod repo update && pod install` |
| 安装时提示"无法验证 App" | USB 重连后重新 `flutter run`；确认已信任电脑与开发者证书 |
| App 图标变灰打不开 | 免费证书 7 天过期 → 重新有线部署 |
| 真机无法启动调试 | 确认已开启开发者模式；Xcode → Window → Devices 检查设备状态 |
