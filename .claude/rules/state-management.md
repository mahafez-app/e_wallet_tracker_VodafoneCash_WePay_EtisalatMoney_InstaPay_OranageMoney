# State Management — Riverpod

---

## Provider Type Selection

| Scenario | Provider Type |
|----------|--------------|
| One-shot async (login, fetch, submit) | `AsyncNotifierProvider` |
| Real-time stream (Firestore, Auth state) | `StreamProvider` |
| Synchronous UI state (form, wizard, tabs) | `NotifierProvider` |
| Simple derived / computed value | `Provider` |
| DI wiring (data source, repo, use case) | `Provider` |
| Auth guard stream | `StreamProvider` |

**`StateNotifierProvider` is forbidden.** Use `NotifierProvider` or
`AsyncNotifierProvider` for all new code. Legacy `StateNotifier` code must
be migrated on first touch.

**No code generation.** `riverpod_generator`, `@riverpod` annotation, and
`build_runner` Riverpod output are not used in this project. All providers
are declared manually.

---

## Provider Declaration Rules

- Use `autoDispose` on any feature-level provider that should not outlive its
  screen. Omit `autoDispose` only for app-lifecycle providers (auth state,
  theme, connectivity) or when keepAlive behavior is explicitly required.
- Never access providers from global singletons. All providers are composed
  through Riverpod's `ref`.
- Provider `build()` must be a pure, side-effect-free initialization.
  Side effects (logging, analytics) belong in methods, not `build()`.

### keepAlive Policy

| Provider | `autoDispose` | Notes |
|----------|--------------|-------|
| Dio / HTTP client | No | App lifetime |
| Firebase instances | No | App lifetime |
| Auth state stream | No | App lifetime |
| Theme notifier | No | App lifetime |
| Feature notifiers | Yes | Scoped to screen |
| Feature stream providers | Yes | Cancel subscription on exit |
| Use case providers | Yes | Stateless, cheap to recreate |
| Repository providers | Yes | Stateless, cheap to recreate |

---

## `AsyncNotifierProvider` — One-Shot Async Operations

Use for login, registration, data fetch, form submission, delete, upload.

```dart
// features/auth/presentation/providers/auth_controller.dart
final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, UserEntity?>(
  AuthController.new,
);

class AuthController extends AutoDisposeAsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async => null;

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

## `StreamProvider` — Real-Time Data (Firestore, Auth)

Use for any data that arrives as an ongoing stream. `StreamProvider`
automatically converts stream events to `AsyncValue<T>` — no manual loading
state management.

```dart
// core/providers/auth_state_provider.dart
// App-lifetime — no autoDispose. Used by the router guard.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(watchAuthStateUseCaseProvider)().map(
    (result) => result.fold(
      (failure) => throw failure,      // → AsyncError
      (user) => user,                  // → AsyncData
    ),
  );
});

// features/messages/presentation/providers/messages_provider.dart
final messagesProvider =
    StreamProvider.autoDispose<List<MessageEntity>>((ref) {
  return ref.watch(watchMessagesUseCaseProvider)().map(
    (result) => result.fold(
      (failure) => throw failure,
      (messages) => messages,
    ),
  );
});
```

---

## `NotifierProvider` — Synchronous / Custom UI State

Use only when `AsyncValue` cannot cleanly express the state. Documented
exceptions only (see Allowed Custom State section below).

```dart
// features/onboarding/presentation/providers/onboarding_controller.dart
final onboardingControllerProvider =
    NotifierProvider.autoDispose<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

class OnboardingController extends AutoDisposeNotifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void nextPage() {
    if (state.currentPage >= state.totalPages - 1) return;
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void previousPage() {
    if (state.currentPage <= 0) return;
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  void complete() {
    state = state.copyWith(isCompleted: true);
  }
}
```

---

## Custom State Shape

Prefer `AsyncValue<T>`. A separate `*_state.dart` file is allowed **only**
when one of the following is true, and the reason is documented in a comment
above the provider declaration:

- Multiple independent UI sub-states coexist simultaneously.
- Complex form workflows require structured validation / submission metadata.
- Multi-step wizard flows require explicit transition state.
- The same state type is reused by multiple providers or screens.
- The provider file becomes unreadable without extraction.

Custom state must be:
- Immutable — all fields `final`.
- Manually written — no `freezed` or code generation.
- Defined in the same file as the notifier, or extracted to `*_state.dart`
  only when the file becomes too large.
- Implemented with `copyWith` for updates.

```dart
// Correct — manual immutable state in same file
final class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = 4,
    this.isCompleted = false,
  });

  final int currentPage;
  final int totalPages;
  final bool isCompleted;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isCompleted,
  }) => OnboardingState(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    isCompleted: isCompleted ?? this.isCompleted,
  );

  bool get isLastPage => currentPage >= totalPages - 1;

  @override
  List<Object?> get props => [currentPage, totalPages, isCompleted];
}
```

---

## Thin Notifiers

Notifiers orchestrate use cases only. Business rules, data transformation,
and domain decisions belong in use cases and repositories.

```dart
// ❌ Business logic in notifier — forbidden
Future<void> fetchUser(String id) async {
  final raw = await _api.getUser(id);
  if (raw['role'] == 'admin') {
    // applying business rule in presentation layer — wrong
  }
}

// ✅ Notifier delegates to use case
Future<void> fetchUser(String id) async {
  state = const AsyncLoading();
  final result = await ref.read(getUserUseCaseProvider)(GetUserParams(id: id));
  result.fold(
    (failure) => state = AsyncError(failure, StackTrace.current),
    (user) => state = AsyncData(user),
  );
}
```

---

## Consuming State in Widgets

```dart
// ConsumerWidget for stateless screens
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      const Scaffold(body: SafeArea(child: _ProfileBody()));
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effects — navigation, snackbars, dialogs
    ref.listen<AsyncValue<UserEntity?>>(authControllerProvider, (_, next) {
      if (next.hasError && next.error is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.failureMessage(next.error! as Failure)),
          ),
        );
      }
    });

    final userState = ref.watch(profileProvider);

    return switch (userState) {
      AsyncLoading()         => const AppLoader(),
      AsyncData(:final value) => _ProfileContent(user: value),
      AsyncError()           => AppErrorView(
          message: context.failureMessage(userState.error! as Failure),
          onRetry: () => ref.invalidate(profileProvider),
        ),
    };
  }
}
```

```dart
// ConsumerStatefulWidget — only when local controllers are required
// (TextEditingController, FocusNode, AnimationController, ScrollController)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: _LoginBody(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
    )),
  );
}
```

---

## ref Rules

| Method | When to use |
|--------|-------------|
| `ref.watch(provider)` | Inside `build()` to react to state changes |
| `ref.read(provider)` | Inside callbacks, methods, event handlers |
| `ref.listen(provider, ...)` | Inside `build()` for side effects only |
| `ref.invalidate(provider)` | To force a provider to re-initialize |
| `ref.watch(provider.notifier)` | Never — use `ref.read(provider.notifier).method()` |

```dart
// ❌ ref.watch inside async method — forbidden
Future<void> refresh() async {
  final data = ref.watch(someProvider); // widget lifecycle violation
}

// ❌ ref.watch in callback — forbidden
onPressed: () => ref.watch(counterProvider.notifier).increment()

// ✅ ref.read in callbacks
onPressed: () => ref.read(counterProvider.notifier).increment()

// ✅ ref.watch in build
final state = ref.watch(profileProvider);
```

---

## `ProviderScope` Setup

```dart
// main.dart
void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: App()));
}
```

Override providers only at the `ProviderScope` level. Never use
`ProviderContainer` inside widget trees.

```dart
// Testing
ProviderScope(
  overrides: [
    authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    loginUseCaseProvider.overrideWithValue(MockLoginUseCase()),
  ],
  child: const App(),
)
```

---

## DI vs UI Provider Split (mandatory)

| File | Contains |
|------|---------|
| `features/x/providers/x_providers.dart` | `Provider<DataSource>`, `Provider<Repository>`, `Provider<UseCase>` |
| `features/x/presentation/providers/x_controller.dart` | `AsyncNotifierProvider`, `NotifierProvider`, `StreamProvider` with UI state |

Mixing DI wiring and UI state in one file is forbidden without exception.
