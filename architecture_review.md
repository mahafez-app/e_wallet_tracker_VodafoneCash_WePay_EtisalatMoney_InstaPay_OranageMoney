# Architecture Review & Refactoring Report — wallet_tracker

---

## Step 1 — Current Problems (Direct Analysis)

### Architecture Violations

| Problem | Location | Severity |
|---|---|---|
| **DTOs live in `core/data/models/`** — shared between all features, but they contain DTO-layer Firebase types. They should live inside each feature's `data/models/`. | `core/data/models/wallet_dto.dart`, `transaction_dto.dart` | High |
| **Entities live in `core/domain/entities/`** — `WalletEntity`, `TransactionEntity` are shared across 3 features. This is acceptable if genuinely shared, but `WalletEntity` currently imports `WalletProvider` which imports `AppColors` and `BuildContext` — **breaking the domain purity rule.** | `core/domain/enums/wallet_provider.dart` | Critical |
| **`WalletProvider` enum imports Flutter+AppColors into domain** — `displayName(BuildContext)`, `brandColor`, `onBrandColor`, `icon` properties live on the enum. This means the domain layer depends on the presentation layer, inverting the dependency. | `core/domain/enums/wallet_provider.dart` | Critical |
| **Home data source duplicates wallet-fetching logic** — `HomeRemoteDataSourceImpl.watchUserWallets()` queries Firestore for wallets. `WalletRemoteDataSourceImpl.getWallets()` does the same query imperatively. These are two divergent implementations of the same data concern. | `home_remote_data_source.dart` vs `wallet_remote_data_source.dart` | High |
| **`TransactionsController` calls `ref.watch` inside `build()`** — A Notifier's `build()` should set up the initial state. Calling `ref.watch(getTransactionsUseCaseProvider)` and immediately invoking `call()` inside `build()` is the `AsyncNotifier` pattern misbehaved as a glorified `FutureProvider`. | `transactions_controller.dart` | Medium |
| **`AddWalletSubmitController` does two jobs** — It submits the wallet AND checks SMS permissions to decide on navigation destination. Permission checking is a separate concern that should not be inside the submit controller. | `add_wallet_controller.dart` | High |
| **`_HomeBody` calls `ref.read(checkAndPromptSmsPermissionProvider)` inside `ref.listen`** — This is UI-layer orchestration of a business rule check. The decision of "should I prompt?" belongs in a controller, not a widget listener. | `home_screen.dart` | High |
| **`checkAndPromptSmsPermissionProvider` is a `Provider<Future<void> Function(...)>`** — This anti-pattern smuggles async side-effects into a sync Provider. The pattern is creative but breaks the testability contract and makes the intent opaque. | `home_sms_prompt_controller.dart` | Medium |
| **`_HomeBody` does not follow the mandatory two-layer split rule** — The `_HomeBody` ConsumerWidget handles `ref.listen`, state switch, AND renders the full data tree inline (no sub-decomposition). | `home_screen.dart` | Medium |
| **`AuthController` wraps use-case calls and returns `Result<T>` to callers** — Notifiers must not return business results to widgets. Return values bypass `ref.listen` and couple widgets to the controller's internal domain. | `auth_controller.dart` | High |
| **`main.dart` contains side-effect calls** (`Telephony.instance.simOperator`) — `main.dart` must contain only `main()` + top-level app widget. Side-effect calls belong in `initializeApp()`. | `main.dart` | Medium |
| **`WalletRepositoryImpl` wraps `executeAndHandleErrors` with its own private `_executeAndHandleErrors` method** — Unnecessary indirection. Call the top-level function directly. | `wallet_repository_impl.dart` | Low |
| **`home_sms_prompt_controller.dart` imports from wallets feature** — `wallets_providers.dart` is imported in `home_sms_prompt_controller.dart`, creating a cross-feature presentation dependency. | `home_sms_prompt_controller.dart` | High |
| **`transactions_providers.dart` mixes DI wiring with SMS listener wiring** — `smsReadinessProvider` and `smsTransactionListenerProvider` should live in a dedicated `sms_providers.dart` or within the wallets feature. | `transactions_providers.dart` | Medium |
| **`_FeatureItem` widget in `sms_permissions_screen.dart` has no `super.key`** — Every widget including private ones must declare `{super.key}`. | `sms_permissions_screen.dart:143` | Low |
| **Dead/commented-out code in production files** — `LoginForm` has a large commented-out "forgot password" block. Comments should be TODO-marked or deleted. | `login_form.dart` | Low |
| **`_TransactionsBody` uses `64` as a hardcoded icon size** — `Icon(Icons.receipt_long_outlined, size: 64)`. Must use `64.responsiveRadius`. | `transactions_screen.dart` | Low |
| **`TransactionsScreen.build()` contains logic** — Title computation with conditional `ref.watch` lives in `build()` of the outer Screen widget. The Screen layer should only contain Scaffold; logic belongs in Body. | `transactions_screen.dart` | Medium |

---

## Step 2 — Target Folder Structure

Only showing the deltas (what changes and why):

```
lib/
├── core/
│   ├── data/
│   │   └── models/
│   │       └── workspace_dto.dart          ← KEEP (shared across features)
│   │       (wallet_dto.dart)               ← MOVE to features/wallets/data/models/
│   │       (transaction_dto.dart)          ← MOVE to features/transactions/data/models/
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── wallet_entity.dart          ← KEEP (shared domain)
│   │   │   └── transaction_entity.dart     ← KEEP (shared domain)
│   │   └── enums/
│   │       ├── wallet_provider.dart        ← SPLIT: keep only pure value logic
│   │       └── transaction_type.dart       ← KEEP
│   ├── providers/
│   │   ├── firebase_providers.dart         ← KEEP
│   │   ├── service_providers.dart          ← KEEP
│   │   └── sms_providers.dart              ← NEW: extract SMS listener wiring here
│   ├── utils/
│   │   └── extensions/
│   │       ├── wallet_provider_ext.dart    ← NEW: Flutter-layer WalletProvider extensions
│   │       └── ...
│   └── ...
│
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── home_controller.dart    ← RENAME: was home_controller.dart (StreamProvider)
│   │       │   └── home_sms_controller.dart ← RENAME: replace Function-provider anti-pattern
│   │       └── screens/
│   │           └── home_screen.dart        ← REFACTOR: extract _HomeDataView, move logic out
│   │
│   ├── wallets/
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── wallet_dto.dart         ← MOVE here from core/data/models/
│   │   └── presentation/
│   │       └── providers/
│   │           └── add_wallet_controller.dart ← REFACTOR: remove permission check from submit
│   │
│   ├── transactions/
│   │   ├── data/
│   │   │   └── models/
│   │   │       └── transaction_dto.dart    ← MOVE here from core/data/models/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── transactions_controller.dart ← REFACTOR to proper AsyncNotifier pattern
│   │       └── screens/
│   │           └── transactions_screen.dart ← REFACTOR: move title logic to Body
│   │
│   └── auth/
│       └── presentation/
│           └── providers/
│               └── auth_controller.dart    ← REFACTOR: remove Result<T> return values
```

---

## Step 3 — Riverpod Standardization

The project already uses the correct split (DI file vs presentation controller file). The inconsistencies are:

### Problem 1: `Provider<Future<void> Function(...)>` Anti-Pattern

```dart
// ❌ BEFORE — home_sms_prompt_controller.dart
final checkAndPromptSmsPermissionProvider =
    Provider.autoDispose<Future<void> Function(bool, void Function())>((ref) {
  return (bool hasWallets, void Function() onPrompt) async {
    // ... logic
  };
});

// Used in widget: ref.read(checkAndPromptSmsPermissionProvider)(hasWallets, navigateFn)
```

**Why it's wrong:** This pattern turns the Provider into a factory for anonymous async functions. It is not observable, not testable via `ProviderContainer`, and hides side-effects inside a sync provider. The widget is controlling the side-effect orchestration.

```dart
// ✅ AFTER — home_sms_controller.dart
final homeSmsControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeSmsController, void>(
      HomeSmsController.new,
    );

class HomeSmsController extends AsyncNotifier<void> {
  @override
  void build() {}

  /// Call once when the dashboard data arrives.
  /// Navigates to SMS permission screen if not yet granted.
  Future<void> checkAndPromptIfNeeded({
    required bool hasWallets,
    required VoidCallback navigate,
  }) async {
    if (!hasWallets) return;

    final hasPrompted = ref.read(hasPromptedSmsPermissionSessionProvider);
    if (hasPrompted) return;
    ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;

    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    result.fold((_) => null, (hasPermission) {
      if (!hasPermission) navigate();
    });
  }
}
```

The widget then does:
```dart
ref.listen(homeDashboardProvider, (_, next) {
  if (next case AsyncData(:final value)) {
    ref.read(homeSmsControllerProvider.notifier).checkAndPromptIfNeeded(
      hasWallets: value.wallets.isNotEmpty,
      navigate: () {
        if (context.mounted) context.push(AppRoutes.smsPermissions);
      },
    );
  }
});
```

### Problem 2: `AuthController` Returning `Result<T>` to Widgets

```dart
// ❌ BEFORE
Future<Result<UserEntity>> signInWithGoogle() async { ... return result; }

// Used in widget:
final result = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
result.fold(...); // Widget consuming domain Result
```

**Why it's wrong:** Widgets must never consume `Result<T>`. They must only observe state. Use `ref.listen` for side effects.

```dart
// ✅ AFTER — AuthController methods return void
Future<void> signInWithGoogle() async {
  state = state.copyWith(loadingMethod: AuthLoadingMethod.google, error: null);
  final result = await _signInWithGoogle();
  result.fold(
    (failure) => state = state.copyWith(
      loadingMethod: AuthLoadingMethod.none,
      error: failure,
    ),
    (_) => state = state.copyWith(loadingMethod: AuthLoadingMethod.none),
  );
}

// Widget uses ref.listen for navigation:
ref.listen(authNotifierProvider, (_, next) {
  if (next.error != null) {
    AppSnackbar.show(context, message: next.error!.toLocalizedString(context));
  }
});
// GoRouter handles navigation via authStateChangesProvider
```

### Problem 3: `TransactionsController` Uses `ref.watch` Inside `build()` to Call a UseCase

```dart
// ❌ BEFORE
@override
Future<List<TransactionEntity>> build() async {
  final result = await ref.watch(getTransactionsUseCaseProvider)(  // ← ref.watch to get a UseCase
    GetTransactionsParams(walletId: _walletId),
  );
  ...
}
```

`ref.watch` inside AsyncNotifier's `build()` on a `Provider` does not create a meaningful dependency — the provider is not a stream. This is semantic noise. The correct pattern:

```dart
// ✅ AFTER
@override
Future<List<TransactionEntity>> build() async {
  final result = await ref.read(getTransactionsUseCaseProvider)(
    GetTransactionsParams(walletId: _walletId),
  );

  return result.fold(
    (failure) => throw failure,
    (transactions) => transactions,
  );
}
```

### Standard Riverpod Pattern Decision Table

| Scenario | Provider Type |
|---|---|
| Sync singleton (Firebase instance, service) | `Provider<T>` |
| Async singleton needing FutureProvider | `FutureProvider<T>` |
| Stream of data (real-time Firestore) | `StreamProvider<T>` |
| UI state with mutations | `NotifierProvider<N, S>` |
| UI state with async init | `AsyncNotifierProvider<N, S>` |
| Scoped to a parameter (e.g. walletId) | `.family` variant |
| Disposed when not in use | `.autoDispose` modifier |
| Session-scoped flag (no class needed) | `StateProvider<T>` (acceptable for primitives only) |

---

## Step 4 — Before → After Refactoring Examples

### 4a. `WalletProvider` — Domain Purity Fix

```dart
// ❌ BEFORE — domain enum imports Flutter SDK and AppColors
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';

enum WalletProvider { ... }

extension WalletProviderExt on WalletProvider {
  String displayName(BuildContext context) => ...  // Flutter in domain!
  Color get brandColor => ...                       // AppColors in domain!
  IconData get icon => ...                          // Flutter in domain!
}
```

```dart
// ✅ AFTER — core/domain/enums/wallet_provider.dart (pure Dart)
enum WalletProvider {
  vodafoneCash,
  orangeMoney,
  etisalatCash,
  instaPay,
  wePay,
  unknown;

  static WalletProvider fromString(String value) { ... } // pure logic, kept

  String get toValue => switch (this) {                  // pure logic, kept
    WalletProvider.vodafoneCash => 'vodafone_cash',
    ...
  };
}
```

```dart
// ✅ AFTER — core/utils/extensions/wallet_provider_ext.dart (Flutter layer only)
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';
import '../../domain/enums/wallet_provider.dart';

extension WalletProviderDisplay on WalletProvider {
  String displayName(BuildContext context) => switch (this) { ... };
  Color get brandColor => switch (this) { ... };
  Color get onBrandColor => switch (this) { ... };
  IconData get icon => switch (this) { ... };
}
```

All widgets that use `.displayName()`, `.brandColor`, `.icon` already import the correct layer — this is a purely structural fix that requires no widget changes, only the import of the extension file.

---

### 4b. `home_screen.dart` — Screen/Body Decomposition

```dart
// ❌ BEFORE — _HomeBody does too much (listen + switch + full render inline)
class _HomeBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(smsTransactionListenerProvider);
    final dashboardState = ref.watch(homeDashboardProvider);

    ref.listen(homeDashboardProvider, (previous, next) {
      if (next case AsyncData(:final value)) {
        ref.read(checkAndPromptSmsPermissionProvider)(   // ← anti-pattern
          value.wallets.isNotEmpty,
          () { if (context.mounted) context.push(AppRoutes.smsPermissions); },
        );
      }
    });

    return switch (dashboardState) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncData(:final value) => RefreshIndicator( ... long inline tree ... ),
      AsyncError(:final error) => Center(child: Text(error.toString())),
    };
  }
}
```

```dart
// ✅ AFTER — each responsibility is one named widget
class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep SMS listener alive.
    ref.watch(smsTransactionListenerProvider);

    // Side-effect: prompt for SMS permission when data arrives.
    ref.listen(homeDashboardProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        ref.read(homeSmsControllerProvider.notifier).checkAndPromptIfNeeded(
          hasWallets: value.wallets.isNotEmpty,
          navigate: () {
            if (context.mounted) context.push(AppRoutes.smsPermissions);
          },
        );
      }
    });

    return switch (ref.watch(homeDashboardProvider)) {
      AsyncLoading() => const AppLoader(),
      AsyncData(:final value) => _HomeDataView(dashboard: value),
      AsyncError(:final error) => _HomeErrorView(error: error),
    };
  }
}

class _HomeDataView extends StatelessWidget {
  const _HomeDataView({required this.dashboard});
  final HomeDashboardEntity dashboard;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => _refresh(context),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeaderWidget(invitationsCount: dashboard.invitationsCount),
          Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxl,
              children: [
                HomeGlobalStatsWidget(
                  totalBalance: dashboard.totalBalance,
                  totalSent: dashboard.totalSent,
                  totalReceived: dashboard.totalReceived,
                  walletCount: dashboard.wallets.length,
                ),
                HomeWalletsSection(wallets: dashboard.wallets),
                HomeWorkspacesSection(workspaces: dashboard.workspaces),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  void _refresh(BuildContext context) {
    // Obtain ref via ProviderScope.containerOf or pass it in.
    // Simplest: this widget remains stateless and the Parent Body handles refresh.
    // For clean decomposition, keep onRefresh in _HomeBody and pass a VoidCallback.
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      error is Failure
          ? (error as Failure).toLocalizedString(context)
          : S.of(context).errorUnknown,
    ),
  );
}
```

---

### 4c. `AddWalletSubmitController` — Single Responsibility

```dart
// ❌ BEFORE — submit() also checks SMS permission and decides navigation destination
Future<void> submit() async {
  ...
  await result.fold(
    (failure) async { state = AsyncError(failure, StackTrace.current); },
    (_) async {
      ref.read(addWalletControllerProvider.notifier).reset();
      final checkPerm = ref.read(checkSmsPermissionUseCaseProvider); // ← 2nd concern
      final permResult = await checkPerm();
      final hasPerm = permResult.dataOrNull == true;
      state = AsyncData(hasPerm
          ? AddWalletResult.successHome
          : AddWalletResult.successNeedPermission);  // ← routing decision in domain
    },
  );
}
```

The submit controller's responsibility is to add wallets. Navigation decisions are a presentation concern. The `AddWalletResult` enum encoding routing intent in a submit result is a domain leak.

```dart
// ✅ AFTER — submit only succeeds or fails; navigation is driven by ref.listen in widget
final addWalletSubmitProvider =
    AsyncNotifierProvider.autoDispose<AddWalletSubmitController, void>(
      AddWalletSubmitController.new,
    );

class AddWalletSubmitController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> submit() async {
    state = const AsyncLoading();

    final walletState = ref.read(addWalletControllerProvider);
    if (walletState.phoneNumber.isEmpty) {
      state = AsyncError(
        const ValidationFailure(code: 'wallet-phone-required'),
        StackTrace.current,
      );
      return;
    }
    if (walletState.selectedProviders.isEmpty) {
      state = AsyncError(
        const ValidationFailure(code: 'wallet-provider-required'),
        StackTrace.current,
      );
      return;
    }

    final deviceInfoService = ref.read(deviceInfoServiceProvider);
    final deviceId = await deviceInfoService.getDeviceId();
    final deviceName = await deviceInfoService.getDeviceName();

    final result = await ref.read(addWalletsUseCaseProvider)(
      AddWalletsParams(
        phoneNumber: walletState.phoneNumber,
        providers: walletState.selectedProviders.map((e) => e.toValue).toList(),
        deviceId: '$deviceName ($deviceId)',
      ),
    );

    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) {
        ref.read(addWalletControllerProvider.notifier).reset();
        state = const AsyncData(null);
      },
    );
  }
}
```

The widget's `ref.listen` then drives navigation:

```dart
ref.listen<AsyncValue<void>>(addWalletSubmitProvider, (previous, next) async {
  if (next is AsyncError) {
    final error = next.error;
    AppSnackbar.show(
      context,
      message: error is Failure
          ? error.toLocalizedString(context)
          : error.toString(),
      type: AppSnackbarType.error,
    );
    return;
  }

  if (next is AsyncData && previous?.isLoading == true) {
    if (!context.mounted) return;
    final hasPerm = await _checkPermission(ref);
    if (!context.mounted) return;
    if (hasPerm) {
      context.go(AppRoutes.home);
    } else {
      ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;
      context.push(AppRoutes.smsPermissions);
    }
  }
});

Future<bool> _checkPermission(WidgetRef ref) async {
  final result = await ref.read(checkSmsPermissionUseCaseProvider)();
  return result.dataOrNull == true;
}
```

---

### 4d. `TransactionsScreen` — Move Logic Out of Screen.build()

```dart
// ❌ BEFORE — Screen.build() computes a title with conditional ref.watch
@override
Widget build(BuildContext context, WidgetRef ref) {
  String title = s.allTransactions;
  if (walletId != null) {
    final walletState = ref.watch(walletDetailsControllerProvider(walletId!));
    title = walletState.when(...);  // logic in Screen layer
  }
  return Scaffold(appBar: AppBar(title: Text(title)), body: ...);
}
```

```dart
// ✅ AFTER — Screen is dumb; Body resolves its own title
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, this.walletId});
  final String? walletId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: _TransactionsTitle(walletId: walletId),
      centerTitle: false,
    ),
    body: SafeArea(child: _TransactionsBody(walletId: walletId)),
  );
}

class _TransactionsTitle extends ConsumerWidget {
  const _TransactionsTitle({required this.walletId});
  final String? walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    if (walletId == null) return Text(s.allTransactions);
    final walletState = ref.watch(walletDetailsControllerProvider(walletId!));
    final title = walletState.maybeWhen(
      data: (_) => s.walletTransactions,
      orElse: () => s.transactionsHistory,
    );
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    ));
  }
}
```

---

### 4e. `main.dart` — Remove Side Effects

```dart
// ❌ BEFORE
void main() async {
  await initializeApp();
  Telephony.instance.simOperator.then(...).catchError(...);  // side effects
  Telephony.instance.simOperatorName.then(...).catchError(...);
  runApp(const ProviderScope(child: App()));
}

// ✅ AFTER — main.dart
void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: App()));
}

// core/di/app_initializer.dart
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _logSimInfo();  // debug only, extracted
}

void _logSimInfo() {
  Telephony.instance.simOperator
      .then((op) => log('SIM operator code: $op', name: 'AppInit'))
      .catchError((Object e) => log('SIM operator error: $e', name: 'AppInit'));
  Telephony.instance.simOperatorName
      .then((op) => log('SIM operator name: $op', name: 'AppInit'))
      .catchError((Object e) => log('SIM operator name error: $e', name: 'AppInit'));
}
```

---

### 4f. `_FeatureItem` in `sms_permissions_screen.dart` — Missing `super.key`

```dart
// ❌ BEFORE
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
```

```dart
// ✅ AFTER
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    super.key,          // ← added
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
```

---

### 4g. `transactions_providers.dart` — Extract SMS Wiring

```dart
// ❌ BEFORE — smsReadinessProvider and smsTransactionListenerProvider
//            live in transactions_providers.dart even though they depend
//            on wallets and are not specific to transactions.

// ✅ AFTER — core/providers/sms_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../../features/transactions/providers/transactions_providers.dart';
import '../../features/wallets/providers/wallets_providers.dart';
import '../domain/entities/wallet_entity.dart';
import '../services/sms_transaction_service.dart';

typedef SmsReadiness = ({bool isPermitted, List<WalletEntity> wallets});

final smsReadinessProvider = FutureProvider<SmsReadiness>((ref) async {
  final permissionResult =
      await ref.read(checkSmsPermissionUseCaseProvider).call();
  final isPermitted = permissionResult.fold((_) => false, (g) => g);

  if (!isPermitted) {
    return (isPermitted: false, wallets: const <WalletEntity>[]);
  }

  final walletResult = await ref.read(getWalletsUseCaseProvider).call();
  final wallets = walletResult.fold((_) => <WalletEntity>[], (w) => w);

  return (isPermitted: true, wallets: wallets);
});

final smsTransactionListenerProvider =
    Provider<SmsTransactionService?>((ref) {
  final readiness = ref.watch(smsReadinessProvider).value;
  if (readiness == null || !readiness.isPermitted) return null;

  final service = SmsTransactionService(
    wallets: readiness.wallets,
    saveTransactionUseCase: ref.watch(saveTransactionUseCaseProvider),
  );
  service.startListening();
  ref.onDispose(service.stopListening);
  return service;
});
```

---

## Step 5 — Reusable Abstractions

### Already Excellent (Do Not Change)

| Abstraction | File | Quality |
|---|---|---|
| `Result<T>` sealed class | `core/error/result.dart` | Production-grade |
| `Failure` hierarchy | `core/error/failures.dart` | Production-grade |
| `FailureMapper` | `core/error/failure_mapper.dart` | Production-grade |
| `executeAndHandleErrors` | `core/utils/execute_and_handle_errors.dart` | Production-grade |
| `FirestoreService` | `core/network/firestore_service.dart` | Well-designed, though underutilized in wallets feature |
| `AppResponsive` + extensions | `core/theme/app_responsive.dart` | Production-grade |
| `FailureMessaging` extension on `BuildContext` | `core/utils/extensions/failure_extension.dart` | Production-grade |
| SMS parser pipeline | `core/utils/sms/` | Well-structured |

### Abstractions to Create

#### 1. `wallet_provider_ext.dart` — Flutter-Layer Enum Extensions

Move all `BuildContext`/`Color`/`IconData` logic out of the domain enum.
**File:** `core/utils/extensions/wallet_provider_ext.dart`

#### 2. `core/providers/sms_providers.dart` — SMS Lifecycle Providers

Described in 4g above de-duplicates responsibility from `transactions_providers.dart`.

#### 3. `AppErrorView` Core Widget

Currently error states render as `Center(child: Text(error.toString()))` everywhere. Extract:

```dart
// core/widgets/app_error_view.dart
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final message = error is Failure
        ? (error as Failure).toLocalizedString(context)
        : S.of(context).errorUnknown;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.responsiveRadius,
            color: Theme.of(context).colorScheme.error,
          ),
          AppSpacing.md.verticalSpace,
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          if (onRetry != null) ...[
            AppSpacing.lg.verticalSpace,
            AppButton(label: S.of(context).retry, onPressed: onRetry!),
          ],
        ],
      ),
    );
  }
}
```

Use everywhere instead of `Center(child: Text(...))`.

---

## Step 6 — Rewritten AGENTS.md

> See the companion artifact: `agents_rewrite.md`

---

## Priority Action List

| Priority | Action | Impact |
|---|---|---|
| 🔴 P0 | Extract Flutter extensions from `WalletProvider` enum into `wallet_provider_ext.dart` | Domain purity |
| 🔴 P0 | Replace `Provider<Function>` with `AsyncNotifier` in `home_sms_prompt_controller.dart` | Correctness |
| 🔴 P0 | Change `AuthController` methods to return `void`, not `Result<T>` | Architecture |
| 🟠 P1 | Move `smsReadinessProvider` and `smsTransactionListenerProvider` to `core/providers/sms_providers.dart` | Cohesion |
| 🟠 P1 | Remove permission check from `AddWalletSubmitController.submit()`, drive navigation from widget `ref.listen` | SRP |
| 🟠 P1 | Fix side-effect calls in `main.dart` → move to `initializeApp()` | Standards |
| 🟡 P2 | Add `super.key` to `_FeatureItem` in `sms_permissions_screen.dart` | Rules |
| 🟡 P2 | Fix hardcoded `size: 64` in `transactions_screen.dart` → `64.responsiveRadius` | Rules |
| 🟡 P2 | Decompose `_HomeBody` into `_HomeDataView` + `_HomeErrorView` | Rules |
| 🟡 P2 | Move `TransactionsScreen` title logic into `_TransactionsTitle` widget | Rules |
| 🟢 P3 | Move `WalletDto` and `TransactionDto` to feature-specific `data/models/` | Cohesion |
| 🟢 P3 | Create `AppErrorView` core widget | DRY |
| 🟢 P3 | Delete commented-out "forgot password" block in `login_form.dart` | Cleanliness |
| 🟢 P3 | Replace private `_executeAndHandleErrors` in `WalletRepositoryImpl` with direct call | DRY |
