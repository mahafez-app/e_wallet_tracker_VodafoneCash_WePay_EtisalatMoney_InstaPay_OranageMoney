# Architecture — Feature-First Clean Architecture

All projects follow strict **Feature-First Clean Architecture**.
This structure is non-negotiable.

```
├── assets/
│   ├── images/
│   └── icons/
└── lib/
    ├── core/
    │   ├── providers/   # App-wide providers and wiring
    │   ├── error/       # Result<T>, Failure hierarchy, FailureMapper
    │   ├── usecase/     # Base UseCase interfaces (UseCase, NoParamsUseCase)
    │   ├── network/     # Shared Dio client, interceptors, and base API config
    │   ├── router/      # GoRouter definition, route constants, refresh stream
    │   ├── theme/       # AppTheme, AppColors, AppSpacing, AppBreakpoints,
    │   │                # ThemeExtensions
    │   ├── widgets/     # Shared UI components used across multiple features
    │   │                # (AppButton, AppTextField, AppDialog, AppLoader, etc.)
    │   └── utils/       # Extensions, pure Dart helpers,
    │                    # repository_handler.dart, app_assets.dart
    ├── l10n/            # Localization ARB files and AppLocalizations setup
    ├── features/
    │   └── feature_name/
    │       ├── providers/
    │       │   └── feature_name_providers.dart   # Data/Domain DI wiring only
    │       ├── data/
    │       │   ├── datasources/   # Remote & local data sources
    │       │   ├── mappers/       # Mapper classes for complex DTO → Entity
    │       │   │                  # transformations involving multiple models
    │       │   ├── models/        # DTOs with serialization + toEntity()
    │       │   └── repositories/  # Repository implementations
    │       ├── domain/
    │       │   ├── entities/      # Pure Dart business objects
    │       │   ├── repositories/  # Abstract repository interfaces
    │       │   └── usecases/      # Single-responsibility use cases
    │       └── presentation/
    │           ├── providers/     # Riverpod Notifier/AsyncNotifier logic
    │           ├── screens/       # Screen entry points
    │           └── widgets/       # Feature-specific UI components.
    │               │              # Group by concern in subfolders when
    │               │              # the feature has many widgets:
    │               │              # widgets/history/, widgets/download/
    └── main.dart
```

## Dependency Rule

Dependencies always point inwards.

- Presentation depends on Domain.
- Data depends on Domain.
- Presentation may reference Data only in the feature DI provider file
  (`features/feature_name/providers/feature_name_providers.dart`) to wire
  implementations to interfaces.
- Domain depends on nothing from Presentation/Data/Flutter.

## Layer Rules

- **Domain Purity:** The domain layer must be independent of Flutter and all
  infrastructure. It contains only entities, repository interfaces, and use
  cases. The only permitted external package is `equatable` (value comparison).
  No exceptions.
- **Repository Pattern:** All data access is abstracted via interfaces defined
  in the domain layer. API clients, database logic, and third-party SDK calls
  (Firebase, Supabase, etc.) belong exclusively in the data layer.
- **Use Case Strictness:** Notifiers must interact only with use cases — never
  with repositories or data sources directly. This keeps the presentation layer
  decoupled from business orchestration.
- **Base Use Case & Result Pattern:** All use cases implement the standard
  interface defined in `core/usecase/` and return `Result<T>` (defined in
  `core/error/`) untouched. Use cases never fold, switch, or inspect the
  result — that is the presentation provider's responsibility.

- **Riverpod State Shape:** Prefer `AsyncValue<T>` in providers over Cubit-style
  sealed state class trees. Do not create dedicated `*_state.dart` files unless
  there is a strong, documented need that `AsyncValue` cannot express cleanly.

```dart
// core/usecase/usecase.dart
abstract class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

abstract class NoParamsUseCase<T> {
  Future<Result<T>> call();
}
```

- **Network Layer:** `core/network/` contains only the shared Dio client
  instance, interceptors (auth, logging, token refresh), and base API
  configuration. Feature-specific API methods belong in the feature's
  data layer, not here.
- **DTO Mapping:** Every DTO must implement `toEntity()` for straightforward
  single-model mappings. For complex transformations that combine multiple
  models or require additional business context, use a dedicated mapper class
  in `data/mappers/`. Entities must never contain `fromJson`, `toJson`, or
  any serialization logic.
- **Atomic Use Cases:** Each use case has one public `call()` method and a
  single responsibility. For multi-step data operations, delegate to the
  repository. For independent business flows, compose separate use cases.
- **Feature Isolation:** Features are self-contained. Cross-feature
  communication happens exclusively through the target feature's domain layer.
- **Provider Organization:** Separate feature DI wiring from UI state:
  - `features/feature_name/providers/feature_name_providers.dart` wires data
    sources, repositories, and use cases.
  - `presentation/providers/*_controller.dart` or
    `presentation/providers/*_provider.dart` contains UI state providers
    (`AsyncNotifierProvider`/`NotifierProvider`/`StateNotifierProvider`) and
    logic.
    This separation is mandatory.

## Core Shared Widgets (`core/widgets/`)

`core/widgets/` is the shared UI component library for the entire app.
These rules are non-negotiable.

- **Check before building.** Before writing any UI component, check
  `core/widgets/` first. If a suitable component exists, use it. Never
  duplicate a component that already exists in core.
- **What belongs in `core/widgets/`.** Any widget used in two or more
  features belongs here. Typical candidates: `AppButton`, `AppTextField`,
  `AppLoader`, `AppDialog`, `AppEmptyState`, `AppErrorView`, `AppCard`.
- **Customization policy.** If a core widget needs customization for a
  specific use case, add an optional parameter to the core widget — but only
  if the change does not break or alter any existing usage. If the
  customization is feature-specific and would pollute the core widget,
  create a feature-level wrapper instead.
- **Naming.** Core widgets are prefixed with `App` (e.g., `AppButton`,
  `AppTextField`). Feature-specific widgets use the feature context
  (e.g., `_DownloadCard`, `_HistoryItem`).
- **Core widgets follow all rules.** Every widget in `core/widgets/` must
  follow `code-quality.md` and `ui.md` — `super.key`, `const` constructors,
  `AppLocalizations` for strings, `AppSpacing` for spacing, `textTheme` for
  typography. No exceptions.

## Feature Widget File Placement

- **Private widgets in the same file** are acceptable only when the widget
  is small (under ~30 lines), used only once, and tightly coupled to its
  parent. This is the exception, not the default.
- **Extract to `widgets/`** as a separate file as soon as a widget is used
  more than once, exceeds ~30 lines, or represents a distinct UI concept
  (a card, a list item, a form section, a status view).
- **Group by concern in subfolders** when a feature has many widgets.
  Do not dump all widgets in a flat `widgets/` directory. Group them:

  ```
  widgets/
  ├── history/
  │   ├── download_history_list.dart
  │   └── download_history_item.dart
  ├── download/
  │   ├── download_progress_view.dart
  │   └── download_success_view.dart
  └── form/
      ├── url_input_field.dart
      └── source_selector.dart
  ```

## Dependency Wiring

Each feature owns its provider wiring in
`features/feature_name/providers/feature_name_providers.dart`. Core providers
(Dio, theme, router dependencies) are
declared in `core/providers/`. Use Riverpod providers for composition; avoid
service-locator style access. All classes must receive dependencies via
constructor injection. Accessing global singletons inside classes is forbidden.

```dart
// core/providers/core_providers.dart
final dioProvider = Provider<Dio>((ref) => Dio(...));

// features/auth/providers/auth_providers.dart
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

// features/auth/presentation/providers/auth_controller.dart

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
      LoginParams(email, password),
    );
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }
}
```
