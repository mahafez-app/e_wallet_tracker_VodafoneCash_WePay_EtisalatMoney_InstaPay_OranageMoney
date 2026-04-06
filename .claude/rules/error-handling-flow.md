# Error Handling — Flow: UseCase → Provider → UI

## 6. Use Case Implementation

Use cases call the repository and return `Result<T>` untouched. They never
fold, switch, or inspect the result — that is strictly the provider's job.

```dart
class LoginUseCase extends UseCase<User, LoginParams> {
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<User>> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}
```

## 7. Consuming Results in Providers

The provider sets loading, calls the use case, then uses `fold()` to set
`AsyncValue` state. The full `Failure` object is passed into `AsyncError`.

```dart
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
```

## 8. Resolving Failure Messages (`core/utils/failure_extension.dart`)

All user-facing messages are resolved through a single `BuildContext`
extension. The switch is exhaustive — adding a new `Failure` subtype without
updating this extension causes a compile error.

```dart
extension FailureMessaging on BuildContext {
  String failureMessage(Failure failure) {
    final l10n = AppLocalizations.of(this)!;
    return switch (failure) {
      NetworkFailure() => l10n.networkError,
      ServerFailure(:final code) => switch (code) {
          '401' => l10n.unauthorizedError,
          '403' => l10n.forbiddenError,
          '404' => l10n.notFoundError,
          _ => l10n.serverError,
        },
      CacheFailure() => l10n.cacheError,
      ValidationFailure(:final code) => code != null
          ? l10n.validationErrorWithCode(code)
          : l10n.validationError,
      UnknownFailure() => l10n.unknownError,
    };
  }
}
```

## 9. Displaying Errors in the UI

Use `ref.listen` for side effects only. Use `ref.watch` for rebuilding UI.

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

## Full Flow Summary

```
RemoteDataSource  →  executes API / SDK call, throws on error

RepositoryImpl    →  executeAndHandleErrors wraps the call:
                       • on success → Success(entity)
                       • on error   → logs with tag, maps to Failure,
                                      returns FailureResult(failure)

UseCase           →  calls repository, returns Result<T> untouched.
                     Never folds. Never switches. Pure pass-through.

Provider          →  state = AsyncLoading
                     call use case
                     result.fold(
                       (failure) → state = AsyncError(Failure, stackTrace),
                       (data)    → state = AsyncData(data),
                     )

Screen            →  ref.listen for side effects, ref.watch for UI:
                       • UI       → switch on AsyncValue → render UI
                       • Side fx  → context.failureMessage(failure) → SnackBar
```
