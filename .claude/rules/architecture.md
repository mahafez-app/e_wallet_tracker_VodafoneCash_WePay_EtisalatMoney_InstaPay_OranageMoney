# Architecture — Feature-First Clean Architecture

All projects follow strict **Feature-First Clean Architecture**.
This structure is non-negotiable and applies to every feature without exception.

---

## Directory Structure

```
lib/
├── core/
│   ├── di/               # Imperative async init (Firebase, Hive, etc.)
│   ├── providers/        # App-wide Riverpod provider declarations
│   ├── error/            # Result<T>, Failure hierarchy, FailureMapper
│   ├── usecase/          # Base UseCase interfaces
│   ├── network/          # Dio client, interceptors, base API config
│   ├── router/           # GoRouter, route constants, refresh stream
│   ├── theme/            # AppTheme, AppColors, AppSpacing, ThemeExtension
│   ├── widgets/          # Shared UI components (AppButton, AppTextField…)
│   └── utils/            # Extensions, pure Dart helpers, app_assets.dart,
│                         # execute_and_handle_errors.dart
├── l10n/                 # ARB files, AppLocalizations setup
├── features/
│   └── feature_name/
│       ├── providers/
│       │   └── feature_name_providers.dart  # Data + Domain DI wiring only
│       ├── data/
│       │   ├── datasources/   # Remote (Firestore/REST) and local sources
│       │   ├── mappers/       # Complex multi-model DTO → Entity transforms
│       │   ├── models/        # DTOs: serialization + toEntity()
│       │   └── repositories/  # Repository implementations
│       ├── domain/
│       │   ├── entities/      # Pure Dart business objects (no Flutter)
│       │   ├── repositories/  # Abstract repository interfaces
│       │   └── usecases/      # Single-responsibility use cases
│       └── presentation/
│           ├── providers/     # Riverpod Notifier / AsyncNotifier providers
│           ├── screens/       # Screen entry points (Scaffold + body split)
│           └── widgets/       # Feature-specific UI components
│               ├── history/
│               └── form/
└── main.dart
```

---

## Dependency Rule (strictly enforced)

```
Presentation  →  Domain  (use cases only — never repositories or data sources)
Data          →  Domain  (implements repository interfaces)
Data          →  Core    (Dio, Firebase instances, storage)
Domain        →  nothing (pure Dart — zero Flutter or infrastructure imports)

❌  Presentation → Data
❌  Presentation → Repository (even through a provider)
❌  Domain       → Data
❌  UseCase      → another UseCase directly
❌  Notifier     → Repository
❌  Notifier     → DataSource
```

The **only** location where Presentation is allowed to reference Data is
`features/feature_name/providers/feature_name_providers.dart`, exclusively to
wire implementations to interfaces.

---

## Layer Rules

### Domain Layer (purest layer)

- Contains only: entities, repository interfaces, use cases, value objects.
- Zero imports from Flutter SDK, Firebase, Dio, or any infrastructure package.
- The only permitted external package: `equatable` for value comparison.
- Entities are immutable, extend `Equatable`, have no serialization logic.
- Repository interfaces define the contract — no implementation detail leaks.

### Data Layer

- Implements domain repository interfaces.
- All Firebase SDK calls, Dio calls, and third-party SDK calls live here.
- Firebase types (`Timestamp`, `DocumentSnapshot`, `DocumentReference`,
  `GeoPoint`, `QuerySnapshot`) are confined to this layer exclusively.
- DTOs handle serialization. Entities handle business logic. Never merge.
- Every DTO implements `toEntity()` for simple mappings. Complex multi-model
  transforms use a dedicated `Mapper` class in `data/mappers/`.
- All exceptions are caught here, mapped to `Failure` objects, returned as
  `Result<T>`. Raw exceptions never escape this layer.

### Presentation Layer

- Notifiers call use cases only. Never repositories or data sources.
- Screens are dumb: read state with `ref.watch`, trigger actions with
  `ref.read(provider.notifier).method()`.
- State shape: prefer `AsyncValue<T>`. Custom sealed state only when
  `AsyncValue` genuinely cannot express the requirements (see state-management.md).
- `ref.listen` for side effects (snackbars, navigation). `ref.watch` for UI.

### Core Layer

- `core/di/` — imperative init code only (Firebase init, plugin setup).
  No Riverpod providers here.
- `core/providers/` — Riverpod provider declarations wrapping initialized
  instances. No business logic here.
- `core/network/` — shared Dio client, auth interceptor, token refresh,
  logging interceptor, base URL config. Feature-specific API methods belong
  in the feature's data layer.
- `core/widgets/` — shared UI component library. Rules enforced in
  `code-quality.md`.

---

## Application Initialization (`core/di/`)

Firebase requires async initialization before `runApp`. All imperative setup
lives in `core/di/app_initializer.dart`.

```dart
// core/di/app_initializer.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import '../../firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Add other async init here: Hive.initFlutter(), etc.
}
```

```dart
// main.dart
void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: App()));
}
```

`main.dart` contains only the `main()` function and the top-level `App`
widget. No business logic, no provider declarations, no theme setup.

---

## Provider Organization (mandatory split)

Every feature has exactly two provider files:

| File                                                             | Contents                                                                  |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `features/feature_name/providers/feature_name_providers.dart`    | Data sources, repository impl, use case wiring                            |
| `features/feature_name/presentation/providers/*_controller.dart` | UI state: `AsyncNotifierProvider` / `NotifierProvider` / `StreamProvider` |

Mixing DI wiring with UI state in a single file is forbidden.

```dart
// features/auth/providers/auth_providers.dart
// — DI wiring only. No UI state. No Notifier classes.

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    failureMapper: const FailureMapper(),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);
```

```dart
// features/auth/presentation/providers/auth_controller.dart
// — UI state only. No data source or repository references.

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async => null;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(loginUseCaseProvider)(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(signOutUseCaseProvider)();
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}
```

---

## Core App-Wide Providers (`core/providers/`)

```dart
// core/providers/firebase_providers.dart
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

// core/providers/network_providers.dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
  dio.interceptors.addAll([
    AuthInterceptor(ref),
    LogInterceptor(requestBody: true, responseBody: true),
  ]);
  return dio;
});
```

These are the **only** providers features may import from outside their
own feature directory (besides `core/error/` types).

---

## Base Use Case Interfaces (`core/usecase/usecase.dart`)

```dart
abstract interface class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

abstract interface class NoParamsUseCase<T> {
  Future<Result<T>> call();
}

abstract interface class StreamUseCase<T, P> {
  Stream<Result<T>> call(P params);
}

abstract interface class NoParamsStreamUseCase<T> {
  Stream<Result<T>> call();
}
```

---

## Core Shared Widgets (`core/widgets/`)

- Check `core/widgets/` **before** building any UI component. If suitable,
  use it. Never duplicate.
- Anything used in two or more features belongs here.
- Core widgets are prefixed with `App`: `AppButton`, `AppTextField`,
  `AppLoader`, `AppDialog`, `AppCard`, `AppEmptyState`, `AppErrorView`.
- Every core widget must follow `code-quality.md` and `ui.md` without exception.
- Customization: add an optional parameter if it does not break existing
  usages. If the change is feature-specific, create a feature-level wrapper.

---

## Feature Widget File Placement

- **Private in same file:** only when under ~30 lines, used exactly once,
  and tightly coupled to parent. This is the exception.
- **Extract to `widgets/`:** as soon as a widget is used more than once,
  exceeds ~30 lines, or represents a named UI concept.
- **Hard cap per screen file:** if any screen file exceeds 200 lines,
  extract all non-trivial UI sections into dedicated files under the
  feature's `presentation/widgets/` folder.
- **Small component preference:** even below 200 lines, prefer small,
  named widgets over large in-file component stacks.
- **Multiple screens organization:** when a feature has more than one
  screen, group screens under `presentation/screens/<group>/` instead of
  keeping all screen files flat in `screens/`.
- **Group by concern** in subfolders — never dump all widgets flat:

```
widgets/
├── history/
│   ├── download_history_list.dart
│   └── download_history_item.dart
└── form/
    ├── url_input_field.dart
    └── source_selector.dart
```

---

## Feature Isolation

Features are self-contained. Cross-feature communication happens only through
the target feature's **domain layer** (entity types or repository interfaces).
A feature's presentation layer never imports from another feature's
presentation or data layers.
