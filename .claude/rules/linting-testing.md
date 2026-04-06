# Linting & Testing

## analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-raw-types: true
  errors:
    missing_return: error

linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    avoid_dynamic_calls: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    always_declare_return_types: true
    unawaited_futures: true
```

- **Zero Warnings:** Do not present any code until `flutter analyze` returns
  zero issues. Warnings are not acceptable in production code.
- **Formatting:** Run `dart format .` before presenting code.

## Testing

- **File Structure:** Mirror the `lib/` structure exactly under `test/`.

```
test/
├── core/
│   └── error/
│       └── failure_mapper_test.dart
└── features/
    └── auth/
        ├── data/repositories/auth_repository_test.dart
        ├── domain/usecases/login_usecase_test.dart
        └── presentation/providers/auth_controller_test.dart
```

- **Priority Order:** Use cases and Notifiers first, then repositories, then
  widget tests, then integration tests.
- **No Flutter in Domain Tests:** Domain layer tests must not import any
  Flutter package. Pure Dart only.
- **Fakes over Mocks:** Write handwritten fakes for repository interfaces.
  Use `mocktail` only when a fake would be impractically complex.
- **Pattern:** Arrange-Act-Assert consistently across all test types.
- **Assertions:** Use `package:checks` over the default `matcher` API.

## Notifier Tests

Use `ProviderContainer` for Notifier testing. Always test both success and
failure
paths. Assert data values, not just types.

```dart
test('sets AsyncData<User?> on successful login', () async {
  final container = ProviderContainer(
    overrides: [
      loginUseCaseProvider.overrideWithValue(FakeLoginUseCase()),
    ],
  );
  addTearDown(container.dispose);

  await container.read(authControllerProvider.notifier).login(
        email: 'user@test.com',
        password: 'password123',
      );

  expect(container.read(authControllerProvider), AsyncData<User?>(fakeUser));
});

test('sets AsyncError with Failure on login error', () async {
  final container = ProviderContainer(
    overrides: [
      loginUseCaseProvider.overrideWithValue(FailingLoginUseCase()),
    ],
  );
  addTearDown(container.dispose);

  await container.read(authControllerProvider.notifier).login(
        email: 'user@test.com',
        password: 'wrong',
      );

  final state = container.read(authControllerProvider);
  expect(state.hasError, true);
  expect(state.error, const NetworkFailure());
});
```

## Repository Tests

Test that exceptions are correctly mapped to typed `Failure` objects.

```dart
test('returns ServerFailure on DioException', () async {
  when(
    () => mockDataSource.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenThrow(DioException(requestOptions: RequestOptions()));

  final result = await repository.login(
    email: 'test@test.com',
    password: 'password',
  );

  expect(result, isA<FailureResult<User>>());
});
```

## Use Case Tests

Use cases are thin — test that they delegate to the repository and return
the result untouched.

```dart
test('returns repository result untouched', () async {
  when(
    () => mockRepository.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => Success(fakeUser));

  final result = await useCase(LoginParams('test@test.com', 'password'));

  expect(result, Success(fakeUser));
});
```
