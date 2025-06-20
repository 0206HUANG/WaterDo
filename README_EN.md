# WaterDo

<img src="assets/images/google_logo.png" width="140" align="right" />

A lightweight Pomodoro / To-Do management app that runs on Web, Mobile and Desktop.

---

## ✨ Features

* Bubble-style task board (stored with Hive – fully Web compatible)
* Google Sign-In (Firebase Auth)
* Lottie animations & gradient UI
* **SQLite Task Demo** – showcases native SQLite CRUD (Mobile / Desktop only)

---

## 🚀 Quick Start

```bash
# Clone the repo
git clone <repo-url>
cd WaterDo

# Install dependencies
flutter pub get

# Run on Web (easiest to try)
flutter run -d chrome
```

### Run on Android / iOS

```bash
# Plug in a device or start an emulator
flutter doctor        # ensure Android / iOS toolchains are ✅
flutter run           # choose the target device
```

### Windows / macOS / Linux Desktop
Firebase support on desktop is limited. If you need a desktop build:
1. Comment out Firebase init code at the top of `lib/main.dart`.
2. Run `flutter run -d windows|macos|linux`.

---

## 📦 Build APK / AAB

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
# Split per-ABI (smaller size)
flutter build apk --release --split-per-abi

# Play Store preferred – AAB
flutter build appbundle --release
```

Generated files are placed under `build/app/outputs/`.

For signing, create a keystore and fill passwords / path in `android/app/key.properties`, then reference it in `android/app/build.gradle` → `signingConfigs`.

---

## 🗄️ Data Storage Matrix

| Module          | Database | Platform Support |
|-----------------|----------|------------------|
| Main App        | Hive     | ✅ Web / Mobile / Desktop |
| SQLite Demo     | Sqflite  | ✅ Android / iOS / Desktop<br/>❌ Web |

* Click the **Storage** icon (top-right on Home) to open the SQLite Task Demo.
* On Web, you'll see a notice that SQLite isn't available.

---

## 📚 References

* [Flutter SQLite Cookbook](https://docs.flutter.dev/cookbook/persistence/sqlite)
* [Hive on pub.dev](https://pub.dev/packages/hive)
* [Sqflite on pub.dev](https://pub.dev/packages/sqflite)

---

Made with ❤️ by HUANG BOSHENG 