# State Management: Riverpod

- **Primary Pattern:** Use Riverpod for all feature state management.
- **Single Logic File by Default:** Keep feature state logic in one provider
  file (for example, `login_controller.dart`). Do not create separate
  `*_state.dart` files by default.
- **AsyncValue First:** Prefer `AsyncNotifierProvider` + `AsyncValue<T>` for
  loading, data, and error states.
- **Notifier Compatibility:** `NotifierProvider` and `StateNotifierProvider`
  are valid when a feature needs explicit custom state modeling.
- **No Codegen for State:** If custom state is needed, define immutable Dart
  state classes manually in the same provider file. Do not use `freezed`.
- **Reference Feature Pattern:** For action-driven features (auth/form flows),
  use `NotifierProvider<FeatureNotifier, FeatureState>` where `FeatureState`
  is a manual immutable class in the same provider file with `copyWith`.
- **Screen Simplicity:** Screens are dumb widgets. They read state with
  `ref.watch`, trigger actions through `ref.read(provider.notifier)`, and keep
  business orchestration in providers.
- **NotifierProvider for Synchronous UI State:** Use `NotifierProvider` only
  for simple synchronous state that does not need async loading/error semantics.
- **No Cubit-Style State Trees:** Do not model UI state as many sealed classes
  (`Initial/Loading/Success/Failure`) unless there is a documented reason that
  `AsyncValue` cannot express cleanly.
- **Allowed Exceptions for `*_state.dart`:** A dedicated state file is allowed
  only when one of these is true and the reason is documented above the
  provider declaration:
  - Multiple independent UI sub-states must coexist at once.
  - Complex form workflows need structured validation/submission metadata.
  - Multi-step wizard flows require explicit transition state.
  - The same state type is reused by multiple providers/screens.
  - The provider file becomes unreadable without extraction.
    In these cases, keep the state immutable, manual (no codegen), and focused
    on UI data only.
- **Failure Object in Error State:** Keep `Failure` typed in error paths.
  For `AsyncValue`, set `AsyncError(failure, stackTrace)` where `failure` is a
  `Failure` subtype.
- **Thin Notifiers:** Notifiers orchestrate use cases only. Business logic
  belongs in use cases and repositories — never in a notifier.
- **Provider Wiring:** Build repositories/use cases through Riverpod provider
  composition in `features/feature_name/providers/feature_name_providers.dart`.
- **DI vs UI Provider Split:**
  - Keep dependency wiring in
    `features/feature_name/providers/feature_name_providers.dart`.
  - Keep UI state providers in `presentation/providers/*_controller.dart` or
    `presentation/providers/*_provider.dart`.
    Do not mix both concerns in one file.
- **No Service Locator in Features:** Do not read dependencies from global
  singletons (`getIt`, static globals) inside feature classes.

## Async Notifier Definition

```dart
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

## Notifier + Custom State Definition

```dart
// features/auth/presentation/providers/auth_provider.dart
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(loginUseCaseProvider)(
      LoginParams(email, password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: failure.technicalMessage,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      ),
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
```

## Providing State

Wrap the app with `ProviderScope` at the top of the tree. Feature providers
are declared near their feature and consumed by screens/widgets.

```dart
void main() {
  runApp(const ProviderScope(child: App()));
}
```

## Consuming State

Use `ConsumerWidget`/`ConsumerStatefulWidget` with `ref.watch` for UI and
`ref.listen` for side effects.

```dart
class LoginBody extends ConsumerWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      if (next.hasError && next.error is Failure) {
        final failure = next.error! as Failure;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);

    return switch (authState) {
      AsyncLoading() => const CircularProgressIndicator.adaptive(),
      AsyncData(:final value) when value != null => const HomeScreen(),
      AsyncData() => const LoginForm(),
      AsyncError() => const LoginForm(),
    };
  }
}
```

## UI Integration Pattern

When integrating providers into screens, follow these patterns:

- Use `ConsumerWidget` for stateless screens.
- Use `ConsumerStatefulWidget` only when local UI controllers are required
  (form key, text controllers, animation/scroll controllers, visibility
  toggles).
- Call `ref.watch(provider)` near the top of `build()` and derive all UI from
  that state.
- Trigger actions from handlers with `ref.read(provider.notifier).action()`.
- Use `ref.listen(provider, ...)` for one-off side effects like snackbars,
  navigation, or dialogs.
- Disable submit/action buttons while loading to prevent duplicate requests.
- Do not store provider state in local mutable fields; always read/watch from
  Riverpod.

```dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return FilledButton(
      onPressed: authState.isLoading
          ? null
          : () => ref.read(authProvider.notifier).login(
                email: _emailController.text,
                password: '***',
              ),
      child: authState.isLoading
          ? const CircularProgressIndicator.adaptive()
          : const Text('Login'),
    );
  }
}
```

## Exception Pattern (Custom State)

If `AsyncValue` is not sufficient, use a custom immutable state type with a
`NotifierProvider` or `StateNotifierProvider`. Keep the state in the same file
unless one of the allowed exception criteria requires extraction.
