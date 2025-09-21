# Flutter Application BLoC

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-4285F4?style=for-the-badge&logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)

**An advanced educational platform mobile application built with Flutter and BLoC pattern**

[📱 Downloads](#downloads) • [🚀 Features](#features) • [📋 Setup](#environment-setup) • [🏗️ Architecture](#architecture) • [🧪 Testing](#testing)

</div>

---

## 📋 Project Metadata

| **Attribute** | **Value** |
|---------------|-----------|
| **Project Name** | Flutter Application BLoC |
| **Version** | 0.1.0 |
| **Flutter SDK** | 3.29.3 (stable) |
| **Dart SDK** | ^3.7.2 |
| **Architecture** | Clean Architecture + BLoC Pattern |
| **Platform Support** | Android, iOS |
| **Localization** | Arabic, English |
| **State Management** | Flutter BLoC |
| **Build System** | Flutter Build Runner |
| **Package Manager** | Pub.dev |
| **Version Control** | Git |
| **Development Tool** | FVM (Flutter Version Management) |

## 📱 Downloads

| Environment | APK Download |
|-------------|--------------|
| **Development** | [📦 Dev APK](https://drive.google.com/file/d/1E5aUAiFDKuGnH3-u9ls47YZWZpxkwFWn/view?usp=sharing) |
| **Production** | [🚀 Prod APK](https://drive.google.com/file/d/1UEEFwdAJbRYbtTPGvQbDzK2oxXRD5qES/view?usp=sharing) |

## 🎯 Project Overview

A comprehensive educational platform mobile application designed to provide seamless learning experiences. Built with modern Flutter architecture patterns, featuring robust state management, multi-environment support, and advanced educational tools including quiz systems, progress tracking, and interactive content delivery.

## 🚀 Features

### 📚 Educational Core Features
- **📖 Interactive Lessons**: Video, audio, PDF, and text-based content delivery
- **🎯 Smart Quiz System**: Multi-attempt quizzes with hints and progress tracking
- **📊 Progress Tracking**: Real-time lesson completion and performance analytics
- **🎓 Subject Management**: Organized curriculum with required/optional subjects
- **📋 Unit Organization**: Structured learning paths with expandable units
- **🔍 Search Functionality**: Advanced search across subjects, units, and lessons

### 🎨 User Experience
- **🌐 Multi-Language Support**: Arabic and English localization
- **📱 Responsive Design**: Adaptive layouts for different screen sizes
- **🎭 Theme System**: Consistent design language throughout the app
- **♿ Accessibility**: Screen reader support and keyboard navigation
- **🔄 Dynamic UI**: Real-time updates based on user selections

### 🏗️ Technical Features
- **🔐 Authentication System**: Secure login with automatic token refresh
- **🌍 Multi-Environment**: Separate development and production builds
- **📡 Offline Support**: Cached content for uninterrupted learning
- **🔄 State Management**: Robust BLoC pattern implementation
- **🧪 Comprehensive Testing**: Unit, widget, and integration tests
- **📝 Form Management**: Advanced form handling with validation

### 🛠️ Developer Features
- **🔄 Hot Reload**: Fast development with Flutter's hot reload
- **📦 Modular Architecture**: Clean, maintainable code structure
- **🎯 Type Safety**: Full Dart type safety with null safety
- **📊 Logging System**: Comprehensive debugging and monitoring
- **🚀 CI/CD Ready**: Automated build and deployment support

## 📋 Table of Contents

- [🚀 Features](#features)
- [📋 Project Metadata](#project-metadata)
- [🎯 Project Overview](#project-overview)
- [⚙️ Flutter Version](#flutter-version)
- [🏗️ Project Structure](#project-structure)
- [🛠️ Environment Setup](#environment-setup)
- [▶️ Running the Application](#running-the-application)
- [🍃 Flavors Configuration](#flavors-configuration)
- [🔐 Authentication & Token Management](#authentication--token-management)
- [🧪 Testing](#testing)
- [📚 Development Guidelines](#development-guidelines)
- [📦 Dependencies](#dependencies)
- [🏛️ Architecture](#architecture)

## ⚙️ Flutter Version

| Component | Version | Channel |
|-----------|---------|---------|
| **Flutter SDK** | 3.29.3 | stable |
| **Dart SDK** | ^3.7.2 | - |
| **FVM** | Latest | Used for version management |

## 🏗️ Project Structure

```
📁 flutter_application_bloc/
├── 📁 lib/
│   ├── 📄 main.dart                    # Default entry point
│   ├── 📄 main_dev.dart               # Development environment
│   ├── 📄 main_prod.dart              # Production environment
│   └── 📁 src/
│       ├── 📁 core/                   # Core application layer
│       │   ├── 📁 config/             # App configurations
│       │   │   ├── 📁 assets/         # Generated assets
│       │   │   ├── 📁 l10n/           # Localization files
│       │   │   └── 📄 app_colors.dart  # Theme colors
│       │   ├── 📁 services/           # Core services
│       │   │   ├── 📄 dio_service.dart      # HTTP client
│       │   │   ├── 📄 storage_service.dart  # Local storage
│       │   │   └── 📄 router_service.dart   # Navigation
│       │   └── 📁 utils/              # Utilities & helpers
│       │       ├── 📁 interceptors/   # HTTP interceptors
│       │       ├── 📄 enums.dart      # App enumerations
│       │       └── 📄 extension.dart  # Dart extensions
│       ├── 📁 data/                   # Data access layer
│       │   ├── 📁 datasources/        # Remote & local data sources
│       │   └── 📁 repositories/       # Repository implementations
│       ├── 📁 domain/                 # Business logic layer
│       │   ├── 📁 entities/           # Business entities
│       │   ├── 📁 repositories/       # Repository interfaces
│       │   └── 📁 usecases/           # Business use cases
│       └── 📁 presentation/           # Presentation layer
│           ├── 📁 view/               # UI components
│           │   ├── 📁 pages/          # Application pages
│           │   ├── 📁 common/         # Shared widgets
│           │   └── 📁 mixins/         # UI mixins
│           └── 📁 controllers/        # Page controllers
├── 📁 test/                          # Test files
│   ├── 📁 unit/                      # Unit tests
│   ├── 📁 widget/                    # Widget tests
│   └── 📁 integration/               # Integration tests
├── 📁 assets/                        # Static assets
│   ├── 📁 images/                    # Image assets
│   ├── 📁 icons/                     # Icon assets
│   ├── 📁 fonts/                     # Font files
│   └── 📁 sounds/                    # Audio assets
├── 📁 android/                       # Android-specific code
├── 📁 ios/                          # iOS-specific code
└── 📄 pubspec.yaml                   # Dependencies & metadata
```

## 🛠️ Environment Setup

### Prerequisites

- Flutter SDK 3.29.3
- Dart SDK ^3.7.2
- FVM (Flutter Version Management)
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd flutter_application_bloc
```

2. **Install dependencies**

```bash
fvm flutter pub get
```

3. **Generate code (if needed)**

```bash
fvm flutter packages pub run build_runner build
```

## ▶️ Running the Application

### Using VS Code Launch Configurations

The project includes pre-configured launch configurations in `.vscode/launch.json`:

#### Development Mode

- **Flutter (DEV Debug)**: Runs development environment in debug mode
- **Flutter (DEV Release)**: Runs development environment in release mode

#### Production Mode

- **Flutter (PROD Debug)**: Runs production environment in debug mode
- **Flutter (PROD Release)**: Runs production environment in release mode

### Using Command Line

#### Development Environment

```bash
# Debug mode
fvm flutter run --flavor dev -t lib/main_dev.dart

# Release mode
fvm flutter run --flavor dev -t lib/main_dev.dart --release
```

#### Production Environment

```bash
# Debug mode
fvm flutter run --flavor prod -t lib/main_prod.dart

# Release mode
fvm flutter run --flavor prod -t lib/main_prod.dart --release
```

### Building for Distribution

#### Android

```bash
# Development APK
fvm flutter build apk --flavor dev -t lib/main_dev.dart

# Production APK
fvm flutter build apk --flavor prod -t lib/main_prod.dart
```

#### iOS

```bash
# Development IPA
fvm flutter build ios --flavor dev -t lib/main_dev.dart

# Production IPA
fvm flutter build ios --flavor prod -t lib/main_prod.dart
```

## 🍃 Flavors Configuration

### Android Flavors

The Android project is configured with two product flavors in `android/app/build.gradle.kts`:

```kotlin
productFlavors {
    create("dev") {
        dimension = "env"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "flutter_application_bloc Dev")
    }
    create("prod") {
        dimension = "env"
        resValue("string", "app_name", "flutter_application_bloc")
    }
}
```

**Features:**

- **Dev flavor**: App ID suffix `.dev`, version suffix `-dev`, distinct app name
- **Prod flavor**: Standard app ID and name
- **NDK Version**: 27.0.12077973

### iOS Flavors

For iOS, you need to manually configure schemes in Xcode:

1. **Open Xcode workspace**

```bash
open ios/Runner.xcworkspace
```

2. **Create schemes**:

   - Duplicate the `Runner` scheme twice
   - Name them: `Runner-dev` and `Runner-prod`
   - Configure build settings for each scheme

3. **Configure bundle identifiers**:

   - Dev: `com.example.flutterApplicationBloc.dev`
   - Prod: `com.example.flutterApplicationBloc`

4. **Set display names** in `Info.plist` per configuration

## 🔐 Authentication & Token Management

### Refresh Token Implementation

The application implements an automatic token refresh mechanism in `lib/src/core/utils/interceptors/data_interceptor.dart`:

## 🧪 Testing

The project includes comprehensive testing strategies covering multiple layers:

### 🔧 Testing Architecture

```
test/
├── 📁 unit/                          # Unit Tests
│   ├── 📄 dashboard_controller_test.dart    # Controller logic tests
│   ├── 📄 login_controller_test.dart        # Authentication tests
│   ├── 📄 questions_controller_test.dart    # Quiz logic tests
│   └── 📄 units_controller_test.dart        # Unit management tests
├── 📁 widget/                        # Widget Tests
│   ├── 📄 dashboard_page_widget_test.dart   # Dashboard UI tests
│   └── 📄 login_page_widget_test.dart       # Login UI tests
└── 📁 integration/                   # Integration Tests
    └── 📄 app_test.dart              # End-to-end tests
```

### 🎯 Testing Features

| Test Type | Coverage | Files | Purpose |
|-----------|----------|-------|---------|
| **Unit Tests** | Business Logic | 4+ files | Controller methods, state management |
| **Widget Tests** | UI Components | 2+ files | User interactions, responsive design |
| **Integration Tests** | Full App Flow | 1+ files | End-to-end user journeys |

### 🚀 Running Tests

```bash
# Run all tests
flutter test

# Run specific test categories
flutter test test/unit/                    # Unit tests only
flutter test test/widget/                  # Widget tests only
flutter test test/integration/             # Integration tests only

# Run tests with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 📊 Test Coverage Areas

- **✅ Authentication Flow**: Login, logout, token refresh
- **✅ Dashboard Navigation**: Step-by-step education setup
- **✅ Quiz System**: Question flow, answers, scoring
- **✅ Content Management**: Subjects, units, lessons
- **✅ UI Components**: Forms, buttons, navigation
- **✅ State Management**: BLoC pattern implementation
- **✅ Error Handling**: Network errors, validation
- **✅ Accessibility**: Screen reader support

## 📦 Dependencies

### 🏗️ Core Dependencies

| Category | Package | Version | Purpose |
|----------|---------|---------|----------|
| **State Management** | `flutter_bloc` | ^8.1.6 | BLoC pattern implementation |
| **State Management** | `bloc` | ^8.1.4 | Core BLoC library |
| **Dependency Injection** | `get_it` | ^7.7.0 | Service locator pattern |
| **HTTP Client** | `dio` | ^5.5.0 | Network requests |
| **Local Storage** | `shared_preferences` | ^2.2.3 | Simple data persistence |
| **Local Storage** | `hive` | ^2.2.3 | NoSQL database |

### 🎨 UI & UX Dependencies

| Package | Version | Purpose |
|---------|---------|----------|
| `flutter_screenutil` | ^5.9.3 | Responsive design |
| `cached_network_image` | ^3.3.1 | Image caching |
| `flutter_svg` | ^2.0.10 | SVG support |
| `lottie` | ^3.1.2 | Animations |
| `flutter_animate` | ^4.5.0 | Advanced animations |
| `percent_indicator` | ^4.2.3 | Progress indicators |

### 📱 Platform & Media

| Package | Version | Purpose |
|---------|---------|----------|
| `image_picker` | ^1.1.2 | Camera & gallery access |
| `audioplayers` | ^5.2.1 | Audio playback |
| `flutter_cached_pdfview` | ^0.4.2 | PDF viewing |
| `qr_code_scanner_plus` | ^2.0.10+1 | QR code scanning |
| `geolocator` | ^12.0.0 | Location services |

### 🔧 Development Dependencies

| Package | Version | Purpose |
|---------|---------|----------|
| `flutter_test` | SDK | Testing framework |
| `build_runner` | ^2.4.11 | Code generation |
| `freezed` | ^2.4.7 | Data classes |
| `json_serializable` | ^6.8.0 | JSON serialization |
| `flutter_lints` | ^4.0.0 | Linting rules |

## 🏛️ Architecture

### 📐 Clean Architecture Layers

```
┌─────────────────────────────────────┐
│           PRESENTATION              │
│  ┌─────────────┐ ┌─────────────┐   │
│  │    Pages    │ │ Controllers │   │
│  │   Widgets   │ │    BLoCs    │   │
│  └─────────────┘ └─────────────┘   │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│             DOMAIN                  │
│  ┌─────────────┐ ┌─────────────┐   │
│  │  Entities   │ │  Use Cases  │   │
│  │ Repository  │ │             │   │
│  │ Interfaces  │ │             │   │
│  └─────────────┘ └─────────────┘   │
└─────────────────────────────────────┘
                    │
┌─────────────────────────────────────┐
│              DATA                   │
│  ┌─────────────┐ ┌─────────────┐   │
│  │ Repository  │ │ Data Sources│   │
│  │    Impl     │ │Remote│Local │   │
│  └─────────────┘ └─────────────┘   │
└─────────────────────────────────────┘
```

### 🎯 BLoC Pattern Implementation

- **Event**: User actions and system triggers
- **State**: UI state representations
- **BLoC**: Business logic processing
- **Repository**: Data access abstraction
- **Data Source**: Remote API and local storage

### 🔄 State Management Flow

1. **UI Event** → User interaction
2. **BLoC Event** → Dispatched to business logic
3. **Repository Call** → Data fetching/manipulation
4. **State Emission** → New state emitted
5. **UI Rebuild** → Interface updates reactively

## 📚 Development Guidelines

### Code Generation

Run code generation when making changes to:

- Freezed classes
- JSON serialization
- Localization files

```bash
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Localization

The project supports multiple languages:

- **ARB Directory**: `lib/src/core/config/l10n`
- **Generated Directory**: `lib/src/core/config/l10n/generated`
- **Untranslated File**: `untranslated.json`

### Asset Management

- **Images**: `assets/images/`
- **Icons**: `assets/icons/`
- **Fonts**: `assets/fonts/` (Cairo font family)
- **Sounds**: `assets/sounds/`

## 🚨 Troubleshooting

### ⚠️ Common Issues

| Issue | Solution | Additional Notes |
|-------|----------|------------------|
| **iOS Flavor Error** | Configure Xcode schemes properly | Check bundle identifiers |
| **Token Refresh Fails** | Verify network connectivity & token validity | Check interceptor logic |
| **Build Errors** | Run `flutter clean` & `flutter pub get` | Clear build cache |
| **Widget Test Failures** | Check mock implementations | Verify ValueNotifier disposal |
| **Hot Reload Issues** | Restart app completely | Check for stateful widget issues |

### 🔍 Debug Mode

Enable comprehensive debugging:

```dart
// Set in environment configuration
const bool kEnableLogging = true;
const bool kEnableNetworkLogs = true;
const bool kEnableBloCLogs = true;
```

### 📊 Performance Optimization

- **Use `const` constructors** for static widgets
- **Implement `dispose()` methods** for controllers
- **Cache network images** using `cached_network_image`
- **Optimize list rendering** with `ListView.builder`
- **Monitor memory usage** in development builds

## 🤝 Contributing

### 📝 Development Standards

1. **📐 Follow Clean Architecture** principles
2. **🧪 Write comprehensive tests** for new features
3. **📖 Document complex logic** with clear comments
4. **🔍 Handle errors gracefully** with proper user feedback
5. **🌐 Support both environments** (dev/prod)
6. **♿ Ensure accessibility** compliance

### 🔄 Pull Request Process

1. **Fork** the repository
2. **Create** a feature branch (`feature/amazing-feature`)
3. **Test** your changes thoroughly
4. **Commit** with clear, descriptive messages
5. **Push** to your branch
6. **Open** a Pull Request with detailed description

### 📋 Code Review Checklist

- ✅ All tests pass
- ✅ No linting errors
- ✅ Proper error handling
- ✅ Documentation updated
- ✅ UI responsiveness verified
- ✅ Performance impact assessed

## 📜 License

This project is **private** and proprietary. All rights reserved.

## 👥 Team

**Development Team**: Internal development team
**Architecture**: Clean Architecture + BLoC Pattern
**Platforms**: Android & iOS
**Status**: Active Development

## 📞 Support

For technical support or questions:

- **Development Issues**: Create an issue in the repository
- **Architecture Questions**: Consult the team lead
- **Build Problems**: Check troubleshooting section first

---

<div align="center">

**🚀 Built with Flutter • 💙 Powered by BLoC • 🎯 Designed for Education**

*This project uses FVM for Flutter version management. Ensure you have FVM installed and configured before running the application.*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/BLoC-4285F4?style=flat-square&logo=flutter&logoColor=white)](https://bloclibrary.dev)

**Last Updated**: December 2024 | **Version**: 0.1.0

</div>