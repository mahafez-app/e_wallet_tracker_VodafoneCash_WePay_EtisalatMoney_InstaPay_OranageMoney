# Error Handling & Failure Mapping — Core Types

The project follows a **Zero Leak** exception policy. Raw exceptions
(DioException, FirebaseException, etc.) must never reach the domain or
presentation layers. All errors are caught in the data layer, mapped to typed
`Failure` objects, and returned as `Result<T>`. User-facing error messages are
always resolved in the presentation layer to support localization.

## 1. Result Type (`core/error/result.dart`)

Single canonical definition. Extends `Equatable` so results are comparable
in tests. `fold()` is the standard way to consume a result inside a Notifier.

```dart
sealed class Result<T> extends Equatable {
  const Result();

  /// The standard way to consume a Result in a Notifier.
  /// onFailure → set failure state.
  /// onSuccess → set success state.
  /// Use cases must never call fold() — they return Result<T> untouched.
  W fold<W>(
    W Function(Failure failure) onFailure,
    W Function(T data) onSuccess,
  ) {
    return switch (this) {
      FailureResult(:final failure) => onFailure(failure),
      Success(:final data) => onSuccess(data),
    };
  }

  @override
  List<Object?> get props => [];
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);

  @override
  List<Object?> get props => [failure];
}
```

## 2. Failure Hierarchy (`core/error/failures.dart`)

`Failure` carries no user-facing strings — only structured data for logging
and fine-grained UI decisions. All user-facing messages are resolved in the
presentation layer via `context.failureMessage()`.

```dart
sealed class Failure extends Equatable {
  /// [code] — machine-readable identifier (HTTP status, Firebase code, etc.)
  /// [technicalMessage] — for logs only, never displayed to the user.
  final String? code;
  final String? technicalMessage;

  const Failure({this.code, this.technicalMessage});

  @override
  List<Object?> get props => [code, technicalMessage];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.code, super.technicalMessage});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.technicalMessage});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.technicalMessage});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.code, super.technicalMessage});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.technicalMessage});
}
```

## 3. Failure Mapper (`core/error/failure_mapper.dart`)

An injectable instance class — never static. Maps raw infrastructure
exceptions to typed `Failure` objects. Repositories never parse error codes
or exception messages directly. `technicalMessage` is for logging only.

```dart
class FailureMapper {
  const FailureMapper();

  Failure map(Object error) {
    return switch (error) {
      DioException e when e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout =>
        NetworkFailure(technicalMessage: e.type.name),
      DioException e => ServerFailure(
          code: e.response?.statusCode?.toString(),
          technicalMessage: e.response?.data?['message'] as String?,
        ),
      FirebaseException e => ServerFailure(
          code: e.code,
          technicalMessage: e.message,
        ),
      _ => UnknownFailure(technicalMessage: error.toString()),
    };
  }
}
```

## 4. Repository Handler (`core/utils/repository_handler.dart`)

A top-level function that eliminates repetitive try-catch blocks. The
positional `call` argument always comes first. `tag` is required.

```dart
Future<Result<T>> executeAndHandleErrors<T>(
  Future<T> Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
}) async {
  try {
    return Success(await call());
  } catch (e, st) {
    log('[$tag] ${e.runtimeType}: $e', stackTrace: st);
    return FailureResult(mapper.map(e));
  }
}
```

## 5. Repository Implementation

Repository methods are concise — they orchestrate data sources and map DTOs
to entities. All exception handling is delegated to `executeAndHandleErrors`.

```dart
@override
Future<Result<User>> login({
  required String email,
  required String password,
}) =>
    executeAndHandleErrors(
      () async {
        final model = await _remoteDataSource.login(
          email: email,
          password: password,
        );
        return model.toEntity();
      },
      tag: 'AuthRepository.login',
    );
```
