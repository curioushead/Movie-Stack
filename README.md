# 🎬 Movie Stack

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)](https://flutter.dev/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge\&logo=android\&logoColor=white)](https://www.android.com/)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge\&logo=ios\&logoColor=white)](https://developer.apple.com/ios/)
[![Hive](https://img.shields.io/badge/Hive-FF6F00?style=for-the-badge\&logo=hive\&logoColor=white)](https://pub.dev/packages/hive)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge)](#)

A modern, fast, and robust Flutter mobile app to showcase trending movies. Designed with **offline-first functionality**, ensuring a smooth experience even without an internet connection.

<p align="center">
<img src="https://placehold.co/400x800/222222/FFFFFF?text=App+Screenshot" alt="App Screenshot">
</p>

---

## ✨ Features

* **Trending Movies**: Browse the most popular movies trending by day or week.
* **Offline-First**: View cached movies even without network access.
* **Local Storage**: All movie data stored locally using **Hive**, a lightweight and fast NoSQL database.
* **Clean Architecture**: Structured with the **BLoC pattern** for scalability, testability, and maintainability.
* **Responsive UI**: Beautiful interface compatible with both iOS and Android.
* **Modular Code**: Organized layers (presentation, domain, data) for better readability and maintainability.

---

## ⚙️ Architecture

**Clean Architecture** with three main layers:

1. **Presentation Layer**: Handles UI components and BLoCs, user input, and state updates.
2. **Domain Layer**: Core business logic and models, independent of frameworks.
3. **Data Layer**: Manages API calls and local data caching using Hive.

---

## 🚀 Getting Started

Follow these steps to set up and run the project locally.

### Prerequisites

* **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
* **IDE**: Visual Studio Code or Android Studio with Flutter & Dart plugins

---

### Installation

Clone the repository:

```bash
git clone https://github.com/curioushead/Movie-Stack.git
cd movie_stack
```

Install dependencies:

```bash
flutter pub get
```

Run code generation for Hive adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Run the application:

```bash
flutter run
```

---

## 📱 Build & Release

### Android

* Build debug APK:

```bash
flutter build apk --debug
```

* Build release APK:

```bash
flutter build apk --release
```

* Build Android App Bundle (AAB) for Play Store:

```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/flutter-apk/` or `build/app/outputs/bundle/release/`

---

### iOS

**Prerequisites:** macOS, Xcode, Apple Developer account

1. Open iOS project in Xcode:

```bash
open ios/Runner.xcworkspace
```

2. Select your device or simulator.
3. For release build: **Product > Archive**, then export IPA via Organizer.

Command-line alternative:

```bash
flutter build ios --release
```

IPA location: `build/ios/iphoneos/Runner.app`

---

## 🤝 Contributing

Contributions are welcome! Open an issue or submit a pull request for bug fixes or new features.

---

## 📝 License

This project is licensed under the **MIT License**.
