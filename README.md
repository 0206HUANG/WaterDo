# WaterDo

<img src="assets/images/google_logo.png" width="140" align="right" />

轻量级番茄钟 / To-Do 管理应用，支持 Web、移动端与桌面端。

---

## ✨ 功能亮点

* 气泡式任务管理（Hive 数据库存储，支持 Web）
* Google 账号登陆（Firebase Auth）
* Lottie 动效 & 渐变 UI
* **SQLite Task Demo** – 演示原生 SQLite CRUD（仅移动 / 桌面平台）

---

## 🚀 快速开始

```bash
# 克隆项目
git clone <repo-url>
cd WaterDo

# 获取依赖
flutter pub get

# 运行 Web 版本（推荐测试）
flutter run -d chrome
```

### 运行到 Android／iOS

```bash
# 连接真机或启动模拟器
flutter doctor       # 确保 Android toolchain/iOS toolchain 无报错
flutter run          # 选择对应设备
```

### Windows / macOS / Linux 桌面
Firebase 目前对桌面端支持有限，如果需要桌面端编译请：
1. 注释 `lib/main.dart` 顶部的 Firebase 相关代码。
2. 运行 `flutter run -d windows|macos|linux`。

---

## 📦 打包 APK

```bash
# Debug APK
flutter build apk --debug

# Release APK（正式发布）
flutter build apk --release
# 如果需要拆分多 ABI 以减小体积
flutter build apk --release --split-per-abi
```

> 生成文件位于 `build/app/outputs/flutter-apk/`。

如需上传 Google Play，请改用 AAB：

```bash
flutter build appbundle --release
```

关于签名：请在 `android/app/key.properties` 填入 keystore 路径与密码，并在 `android/app/build.gradle` 的 `signingConfigs` 中引用。

---

## 🗄️ 数据存储

| 功能模块 | 数据库          | 平台支持 |
|---------|----------------|-----------|
| 主应用   | Hive           | ✅ Web / Mobile / Desktop |
| SQLite 演示 | Sqflite        | ✅ Android / iOS / Desktop<br/>❌ Web |

* 进入主界面右上角点击 **Storage** 图标可进入 SQLite Task Demo。
* 在 Web 平台会显示"SQLite 不可用"提示。

---

## 📚 参考

* [Flutter 官方 SQLite Cookbook](https://docs.flutter.dev/cookbook/persistence/sqlite)
* [Hive](https://pub.dev/packages/hive)
* [Sqflite](https://pub.dev/packages/sqflite)

---

Made with ❤️ by WaterDo Team 