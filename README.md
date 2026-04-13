# Mahafez (محافظ)

Mahafez is a Flutter application for tracking personal and shared e-wallet activity in Egypt. It combines automatic SMS parsing on Android with Firebase-powered real-time sync so users can monitor balances, review transaction history, manage multiple wallets, and collaborate inside shared workspaces.

## Overview

The app is designed for people who actively use mobile wallets and need a clearer record of incoming and outgoing transfers across more than one account. Instead of relying on scattered SMS messages, Mahafez turns wallet activity into a structured dashboard with transaction history, collaboration flows, and workspace-level visibility.

## Core Features

- Multi-wallet tracking with per-wallet balances, totals, and recent activity
- Real-time transaction sync through Firebase Authentication and Cloud Firestore
- Android SMS ingestion for supported wallet providers, including background handling
- Shared workspaces for grouping wallets, inviting members, and monitoring collective activity
- Transaction details with notes, paid status, receipt capture, and sharing support
- Arabic-first localized experience with English support
- Light and dark themes
- Email/password and Google authentication flows

## Supported Product Areas

- Authentication
- Home dashboard
- Wallet management
- Transactions and transaction details
- Workspace creation and workspace settings
- Member invitations and invitation responses
- User settings and SMS permission flows

## Architecture

This project follows a feature-first Clean Architecture structure with clear separation between presentation, domain, and data layers.

- `presentation` depends on domain use cases only
- `domain` stays pure Dart and contains entities, repository contracts, and use cases
- `data` implements repositories, DTOs, Firebase access, and error mapping
- Riverpod is used for dependency injection and UI state management
- Firebase SDK usage is isolated to the data layer
- Failures are mapped into `Result<T>` instead of leaking raw exceptions upward

## Tech Stack

- Flutter
- Dart
- Riverpod
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- GoRouter
- Intl with ARB-based localization
- Flutter ScreenUtil
- Android SMS tooling via `another_telephony`, `flutter_sms_inbox`, and `permission_handler`
- `share_plus` and `screenshot` for transaction receipt sharing

## Project Structure

```text
lib/
├── core/
│   ├── data/
│   ├── di/
│   ├── domain/
│   ├── error/
│   ├── providers/
│   ├── router/
│   ├── services/
│   ├── theme/
│   ├── usecase/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── home/
│   ├── invitations/
│   ├── settings/
│   ├── transactions/
│   ├── wallets/
│   └── workspaces/
├── generated/
├── l10n/
└── main.dart
```

## App Preview And Screenshots

This repository is prepared for portfolio-style media. When you capture screens later, place them in these folders:

- `docs/previews/` for a GIF or short app preview
- `docs/screenshots/` for still screenshots

Suggested file names:

- `docs/previews/app-preview.gif`
- `docs/screenshots/home.png`
- `docs/screenshots/wallet-details.png`
- `docs/screenshots/transactions.png`
- `docs/screenshots/workspace-details.png`
- `docs/screenshots/settings.png`

After adding media, you can embed it directly in this README:

```md
![App Preview](docs/previews/app-preview.gif)

| Home | Wallet Details | Transactions |
|------|----------------|--------------|
| ![](docs/screenshots/home.png) | ![](docs/screenshots/wallet-details.png) | ![](docs/screenshots/transactions.png) |
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- A configured Firebase project
- Android Studio or Xcode
- A physical Android device if you want to test SMS ingestion

### Installation

```bash
git clone <repository-url>
cd wallet_tracker
flutter pub get
flutter run
```

## Firebase Setup

1. Create a Firebase project.
2. Enable Authentication and Firestore.
3. Configure platform apps for Android and iOS.
4. Generate or replace Firebase config files for this project.
5. Ensure `lib/firebase_options.dart` matches your Firebase project.

If you are setting the project up from scratch, using `flutterfire configure` is the cleanest option.

## Development Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

## Platform Notes

- Android supports the full experience, including SMS permissions, foreground listeners, and background SMS transaction capture.
- iOS can use the synced app experience, but SMS reading is not available due to platform restrictions.

## Localization

The app currently supports:

- Arabic (`ar`) as the primary locale
- English (`en`) as a secondary locale

Localization files live in `lib/l10n/`, and generated localization output lives in `lib/generated/`.

## Why This Project Is Strong For A Portfolio Or CV

Mahafez demonstrates more than UI work. It shows practical Flutter engineering across app architecture, Firebase integration, state management, localization, background processing, and collaborative product flows. It is especially useful as a portfolio project because it combines real-world constraints: platform-specific behavior, real-time sync, modular architecture, and a user-facing problem with clear value.

## License

This project is private and not intended for public distribution without the owner's approval.
