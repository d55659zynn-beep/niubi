# Android 构建与安装指南

> 本项目的 Android 端使用 Flutter + Isar 原生库；UI 自适应手机屏幕，
> 深色主题跟随系统，功能与 iOS 一致性由同一套 Dart 代码保证。

## 一、环境要求

1. **Android Studio**（或 Android SDK Command-line Tools）
2. **Android SDK**（API 33+ 建议），含：
   - Platform-Tools（adb）
   - Build-Tools
3. **JDK 17**（Android Gradle Plugin 要求）
4. Flutter SDK 3.13.7+
5. 设置 SDK 路径：
   ```bash
   flutter config --android-sdk <Android SDK 路径>
   flutter doctor -v   # 确认 Android toolchain 正常
   ```

## 二、构建与运行

```bash
cd wangshen_app

# 调试运行（连接手机或模拟器）
flutter run -d <设备ID>

# 打 Release APK（可直接安装到手机）
flutter build apk --release

# 打 App Bundle（用于上架/分发）
flutter build appbundle --release
```

### 产物位置

```
build/app/outputs/flutter-apk/app-release.apk      # APK
build/app/outputs/bundle/release/app-release.aab    # App Bundle
```

### 安装到手机

```bash
# USB 调试连接后
adb install -r build/app/outputs/flutter-apk/app-release.apk

# 或把 APK 传到手机，用文件管理器点击安装（需允许"安装未知来源应用"）
```

## 三、权限配置（项目已就绪）

`android/app/src/main/AndroidManifest.xml` 已包含：

| 配置 | 说明 |
|------|------|
| `android.permission.INTERNET` | 多平台岗位抓取（牛客/实习僧/BOSS直聘）与网络请求 |
| `android.permission.POST_NOTIFICATIONS` | 截止日期本地通知（Android 13+） |
| `android.permission.RECEIVE_BOOT_COMPLETED` / `VIBRATE` | 通知相关 |
| `<queries>` VIEW intent（http/https） | Android 11+ 唤起系统浏览器（url_launcher） |
| `android:usesCleartextTraffic="true"` | 兼容个别 http 招聘页面跳转 |

> 自动填表（内嵌 WebView）在 Android 端**可用**；「打开投递页面」走系统浏览器。

## 四、本地数据库（Android）

- Isar 数据库位置：App 私有目录（`/data/data/<包名>/app_flutter/wangshen_local.isar`）
- 无需外部存储权限（应用私有目录）
- 卸载 App 会删除本地数据库；备份需 root 或 adb backup

## 五、手机端适配说明

- 岗位列表卡片、筛选面板为响应式布局（ListView / Wrap / BottomSheet），
  适配 320dp~平板宽度，深色主题跟随系统
- 自动填表页使用 WebView + JS 注入；桌面端/平板横屏亦可使用
- 免费分发：个人自用可直接安装 APK，无需上架

## 六、常见问题

| 问题 | 处理 |
|------|------|
| `Android SDK not found` | `flutter config --android-sdk <路径>` 后重试 |
| Gradle 构建失败 | 检查 JDK 17；`cd android && ./gradlew clean` 后重试 |
| 安装被拦截 | 手机设置允许安装未知来源应用；或使用 `adb install` |
| 抓取岗位失败 | 检查网络；BOSS直聘有反爬限制，牛客/实习僧可正常抓取（失败会弹窗提示且不影响其他平台） |
| 通知不显示 | Android 13+ 需在系统设置中允许通知权限 |
