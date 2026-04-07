# Error Handling — Flow: DataSource → Repository → UseCase → Provider → UI

---

## Complete Flow Summary

```
DataSource      →  Executes Firebase / Dio / SDK call.
                   Throws on error (never catches internally).

RepositoryImpl  →  executeAndHandleErrors / executeStreamAndHandleErrors wraps:
                     success → Success(entity)
                     error   → logs with tag, maps via FailureMapper,
                               returns FailureResult(failure)

UseCase         →  Calls repository. Returns Result<T> / Stream<Result<T>>
                   untouched. Never folds. Never switches. Pure pass-through.

Provider        →  AsyncNotifierProvider / StreamProvider:
                     state = AsyncLoading()
                     await useCase(params)
                     result.fold(
                       failure → state = AsyncError(failure, stackTrace)
                       data    → state = AsyncData(data)
                     )

Screen          →  ref.listen  → side effects (SnackBar, navigation, dialog)
                   ref.watch   → switch on AsyncValue → render UI
                   context.failureMessage(failure) → localized string
```

---

## Data Source (throws, never catches)

```dart
// features/auth/data/datasources/auth_remote_data_source.dart
abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> signOut();
  Stream<UserModel?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth;

  final FirebaseAuth _auth;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Stream<UserModel?> authStateChanges() =>
      _auth.authStateChanges().map(
        (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
      );
}
```

---

## Repository (catches, maps, wraps)

```dart
// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    FailureMapper failureMapper = const FailureMapper(),
  })  : _remote = remote,
        _mapper = failureMapper;

  final AuthRemoteDataSource _remote;
  final FailureMapper _mapper;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) =>
      executeAndHandleErrors(
        () async {
          final model = await _remote.login(email: email, password: password);
          return model.toEntity();
        },
        tag: 'AuthRepository.login',
        mapper: _mapper,
      );
}
```

---

## Use Case (pure pass-through — never folds)

```dart
// features/auth/domain/usecases/login_use_case.dart
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}

// features/auth/domain/usecases/params/login_params.dart
final class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
```

---

## Provider (folds, sets AsyncValue state)

```dart
// features/auth/presentation/providers/auth_controller.dart
final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserEntity?>(AuthController.new);

class AuthController extends AsyncNotifier<UserEntity?> {
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

## StreamProvider Flow (Firestore real-time)

For real-time Firestore data use `StreamProvider`. The stream wraps
`Stream<Result<T>>` so per-event errors are typed, not thrown.

```dart
// features/messages/presentation/providers/messages_provider.dart
final messagesProvider = StreamProvider.autoDispose<List<MessageEntity>>((ref) {
  return ref
      .watch(watchMessagesUseCaseProvider)()
      .map((result) => result.fold(
            (failure) => throw failure,       // surfaces as AsyncError
            (messages) => messages,           // surfaces as AsyncData
          ));
});
```

```dart
// Use case for stream — pass-through exactly like Future use cases
class WatchMessagesUseCase implements NoParamsStreamUseCase<List<MessageEntity>> {
  const WatchMessagesUseCase(this._repository);
  final MessagesRepository _repository;

  @override
  Stream<Result<List<MessageEntity>>> call() => _repository.watchMessages();
}
```

---

## Screen (listen for effects, watch for UI)

```dart
// features/auth/presentation/screens/login_screen.dart
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(child: _LoginBody()),
  );
}

class _LoginBody extends ConsumerWidget {
  const _LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effects — run once per state change, not on every rebuild.
    ref.listen<AsyncValue<UserEntity?>>(authControllerProvider, (_, next) {
      if (next.hasError && next.error is Failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.failureMessage(next.error! as Failure),
            ),
          ),
        );
      }
      if (next is AsyncData<UserEntity?> && next.value != null) {
        context.go(AppRoutes.home);
      }
    });

    final authState = ref.watch(authControllerProvider);

    return switch (authState) {
      AsyncLoading() => const AppLoader(),
      AsyncData()   => const _LoginForm(),
      AsyncError()  => const _LoginForm(),
    };
  }
}
```

---

## Result Branching Rules

| Location | Rule |
|----------|------|
| `UseCase` | Never calls `fold()`. Returns `Result<T>` untouched. |
| `RepositoryImpl` | Never calls `fold()`. Uses `executeAndHandleErrors` wrapper. |
| `Notifier` | Always uses `fold()`. Sets `AsyncValue` state. |
| `Screen` / widget | Never branches on `Result` directly. Reads `AsyncValue` from provider. |
| Anywhere | Never uses `is Success<T>` or `is FailureResult<T>` checks outside `fold()`. |

---

## Never Do This

```dart
// ❌ Use case inspecting result
final result = await _repository.login(...);
if (result is Success) { ... }   // forbidden

// ❌ Notifier accessing repository directly
final user = await ref.read(authRepositoryProvider).login(...);

// ❌ Branching on Result in the UI
final result = ref.watch(someResultProvider);
if (result.isSuccess) { ... }

// ❌ Presentation layer catching raw exceptions
try {
  await _remote.login(...);
} on FirebaseAuthException catch (e) { ... }
```
