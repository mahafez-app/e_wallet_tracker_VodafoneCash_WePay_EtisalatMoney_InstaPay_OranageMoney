# 🏦 **Mahafez** (محافظ) — Family E-Wallet Transaction Tracker

A Flutter application for tracking shared family wallet transactions across multiple Vodafone Cash and InstaPay accounts in Egypt.

## 📖 Project Overview

**Mahafez** solves the problem of tracking transactions across multiple shared family wallets. When family members receive or send money through Vodafone Cash or InstaPay, the app automatically syncs transactions in real-time and provides an audit trail showing who marked payments as complete.

### Key Features
- 📱 **Multi-wallet tracking** across family member devices
- 📲 **Automatic SMS parsing** (Android) from Vodafone Cash & InstaPay
- 🔄 **Real-time Firestore sync** across all devices
- ✅ **Audit trail** with user attribution and timestamps
- 🌙 **Dark/Light theme** support
- 🇸🇦 **Arabic-first UI** (RTL) with English support
- 👨‍👩‍👧‍👦 **Family-friendly** non-technical user interface

## 🏗 Project Structure

```
lib/
├── core/
│   ├── di/                 # Dependency injection & app initialization
│   ├── error/              # Failure & error handling
│   ├── providers/          # Riverpod providers (Firebase, theme, etc.)
│   ├── router/             # GoRouter configuration
│   ├── theme/              # Colors, typography, theme
│   ├── usecase/            # Base use case class
│   ├── utils/              # Utilities & extensions
│   └── widgets/            # App-wide widgets (App, NotFoundScreen)
│
├── features/               # Feature modules (auth, transactions, wallets, etc.)
│   ├── auth/               # Authentication (login, signup, name confirmation)
│   ├── transactions/       # Transaction display & management
│   ├── wallets/            # Wallet summaries
│   └── sms/                # SMS parsing & sync
│
├── generated/              # Auto-generated code (localization, routing)
├── l10n/                   # Localization files (ARB: ar, en)
└── main.dart               # App entry point
```

## 🛠 Tech Stack

- **UI Framework:** Flutter 3.11+
- **State Management:** Riverpod + Flutter Hooks
- **Backend:** Firebase (Auth + Firestore)
- **Navigation:** GoRouter
- **Localization:** Intl + ARB files
- **Testing:** Mocktail + Flutter Test
- **Build:** Build Runner (JSON serialization, localization generation)

## 📋 Documentation Files

The following documentation files guide implementation:

| File | Purpose |
|------|---------|
| [`TECHNICAL_EXECUTION_PLAN.md`](./TECHNICAL_EXECUTION_PLAN.md) | AI-guided 4-phase implementation roadmap |
| [`STITCH_DESIGN_BRIEF.md`](./STITCH_DESIGN_BRIEF.md) | Pixel-perfect design specifications (ready for Google Stitch) |
| [`DESIGN_SUMMARY.md`](./DESIGN_SUMMARY.md) | Guide for using design documents |
| [`APP_DEFINITION.md`](./APP_DEFINITION.md) | High-level product summary for stakeholders |
| [`WALLET_TRACKER_PLAN.md`](./WALLET_TRACKER_PLAN.md) | Detailed technical specs (Firestore schema, SMS regex, security rules) |

## 🚀 Getting Started

### Prerequisites
- Flutter 3.11 or later
- Dart 3.11 or later
- Android Studio / Xcode (for iOS)
- Firebase project configured

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wallet_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Download `google-services.json` (Android) and place in `android/app/`
3. Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
4. Enable Authentication (Google Sign-In + Email/Password)
5. Set up Firestore in native mode

## 📱 Platforms

- **Android:** Full support (SMS reading + Firestore sync)
- **iOS:** Read-only mode (SMS reading not available on iOS; displays synced transactions)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 📦 Build & Release

```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android, for Play Store)
flutter build appbundle

# Build iOS
flutter build ios
```

## 🔐 Security

- Firebase Security Rules enforce user authentication
- Transaction immutability (no deletion; audit trail preserved)
- User attribution on all status changes
- Sensitive data (Firebase keys) are environment-specific

## 🌐 Localization

The app supports:
- **Arabic (ar)** — Primary UI language (RTL)
- **English (en)** — Secondary language (LTR)

Localization strings are in `lib/l10n/*.arb`. To add new strings:

1. Edit `lib/l10n/intl_en.arb` (English)
2. Edit `lib/l10n/intl_ar.arb` (Arabic)
3. Run: `flutter pub run build_runner build`

## 🎨 Theme

The app uses Material Design 3 with semantic colors:
- **Primary Blue** for main actions
- **Success Green** for "Paid" status
- **Error Red** for "Unpaid" status
- **Warning Amber** for pending actions

See `lib/core/theme/` for theme configuration.

## 📞 Support

For issues or questions, refer to:
- [TECHNICAL_EXECUTION_PLAN.md](./TECHNICAL_EXECUTION_PLAN.md) — Implementation roadmap
- [WALLET_TRACKER_PLAN.md](./WALLET_TRACKER_PLAN.md) — Technical specifications
- Flutter documentation: https://docs.flutter.dev

## 📄 License

This project is proprietary and for internal use only.
