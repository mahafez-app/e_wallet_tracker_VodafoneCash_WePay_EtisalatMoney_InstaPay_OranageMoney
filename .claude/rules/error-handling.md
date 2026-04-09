# Error Handling — Core Types & Data Layer Policy

The project follows a **Zero Leak** exception policy. Raw exceptions
(`FirebaseException`, `FirebaseException`, `FirebaseAuthException`, `SocketException`,
etc.) must never reach the domain or presentation layers. All errors are caught
in the data layer, mapped to typed `Failure` objects, and returned as
`Result<T>`. User-facing error messages are always resolved in the presentation
layer to support localization.

---

## 1. Result Type (`core/error/result.dart`)

Single canonical definition. Extends `Equatable` for value equality.
`fold()` is the only accepted consumption path in notifiers.

```dart
import 'package:equatable/equatable.dart';
import 'failures.dart';

sealed class Result<T> extends Equatable {
  const Result();

  /// Standard consumption path inside a Notifier.
  /// Use cases must NEVER call fold() — they return Result<T> untouched.
  W fold<W>(
    W Function(Failure failure) onFailure,
    W Function(T data) onSuccess,
  ) => switch (this) {
      FailureResult(:final failure) => onFailure(failure),
      Success(:final data) => onSuccess(data),
    };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    FailureResult() => null,
  };

  Failure? get failureOrNull => switch (this) {
    FailureResult(:final failure) => failure,
    Success() => null,
  };

  @override
  List<Object?> get props => [];
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  List<Object?> get props => [data];
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
```

---

## 2. Failure Hierarchy (`core/error/failures.dart`)

`Failure` carries no user-facing strings — only structured data for logging
and fine-grained UI decisions. All user-facing messages are resolved in the
presentation layer via `context.failureMessage()`.

Adding a new `Failure` subtype requires updating `FailureMessaging` in
`core/utils/failure_extension.dart`. The exhaustive `switch` will produce a
compile error if omitted — this is intentional.

```dart
import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({this.code, this.technicalMessage});

  /// Machine-readable identifier: HTTP status code, Firebase error code, etc.
  final String? code;

  /// For logs and crash reporting only. Never displayed to the user.
  final String? technicalMessage;

  @override
  List<Object?> get props => [code, technicalMessage];
}

/// HTTP / REST API failures (non-auth).
final class ServerFailure extends Failure {
  const ServerFailure({super.code, super.technicalMessage});
}

/// No internet connectivity or connection timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.technicalMessage});
}

/// Firebase Auth specific failures (wrong-password, user-not-found, etc.).
/// Kept separate from ServerFailure for fine-grained UI handling.
final class AuthFailure extends Failure {
  const AuthFailure({super.code, super.technicalMessage});
}

/// Local storage or cache read/write failures.
/// Also used for Firestore offline / unavailable errors.
final class CacheFailure extends Failure {
  const CacheFailure({super.technicalMessage});
}

/// Input or business rule validation failures.
final class ValidationFailure extends Failure {
  const ValidationFailure({super.code, super.technicalMessage});
}

/// Firebase Storage failures (upload, download, delete).
final class StorageFailure extends Failure {
  const StorageFailure({super.code, super.technicalMessage});
}

/// Permission denied: Firestore security rules, OS permissions, etc.
final class PermissionFailure extends Failure {
  const PermissionFailure({super.code, super.technicalMessage});
}

/// Catch-all for unexpected errors that do not fit any category above.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.technicalMessage});
}
```

---

## 3. Failure Mapper (`core/error/failure_mapper.dart`)

An injectable instance class — never static, never a mixin, never a free
function. Maps raw infrastructure exceptions to typed `Failure` objects.
Repositories never parse error codes or exception messages directly.

Match order matters: more specific types (`FirebaseAuthException`) must
precede their supertypes (`FirebaseException`).

```dart
import 'dart:io';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'failures.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(Object error) => switch (error) {
    // — Firebase / REST ——————————————————————————————————————————
    FirebaseException e when _isNetworkError(e) =>
      NetworkFailure(technicalMessage: e.type.name),

    FirebaseException e when e.response?.statusCode == 401 =>
      AuthFailure(
        code: '401',
        technicalMessage: _extractFirebaseMessage(e),
      ),

    FirebaseException e when e.response?.statusCode == 403 =>
      PermissionFailure(
        code: '403',
        technicalMessage: _extractFirebaseMessage(e),
      ),

    FirebaseException e =>
      ServerFailure(
        code: e.response?.statusCode?.toString(),
        technicalMessage: _extractFirebaseMessage(e),
      ),

    // — Firebase Auth ———————————————————————————————————————
    // Must precede FirebaseException — FirebaseAuthException extends it.
    FirebaseAuthException e =>
      AuthFailure(code: e.code, technicalMessage: e.message),

    // — Firebase Storage ————————————————————————————————————
    FirebaseException e when e.plugin == 'firebase_storage' =>
      StorageFailure(code: e.code, technicalMessage: e.message),

    // — Firestore offline ———————————————————————————————————
    FirebaseException e when e.code == 'unavailable' =>
      CacheFailure(technicalMessage: 'Firestore unavailable — device offline'),

    // — Firestore permission denied ————————————————————————
    FirebaseException e when e.code == 'permission-denied' =>
      PermissionFailure(code: e.code, technicalMessage: e.message),

    // — Generic Firebase ————————————————————————————————————
    FirebaseException e =>
      ServerFailure(code: e.code, technicalMessage: e.message),

    // — OS-level connectivity ——————————————————————————————
    SocketException e =>
      NetworkFailure(technicalMessage: e.message),

    // — Catch-all ——————————————————————————————————————————
    _ => UnknownFailure(technicalMessage: error.toString()),
  };

  bool _isNetworkError(FirebaseException e) =>
    e.type == FirebaseExceptionType.connectionError ||
    e.type == FirebaseExceptionType.receiveTimeout ||
    e.type == FirebaseExceptionType.sendTimeout ||
    e.type == FirebaseExceptionType.connectionTimeout;

  String? _extractFirebaseMessage(FirebaseException e) =>
    e.response?.data is Map<String, dynamic>
      ? e.response?.data['message'] as String?
      : e.message;
}
```

---

## 4. Error Wrapper (`core/utils/execute_and_handle_errors.dart`)

Eliminates repetitive try-catch blocks. The positional `call` argument comes
first. `tag` is required for traceable logs. Never omit it.

```dart
import 'dart:developer';
import '../error/failure_mapper.dart';
import '../error/result.dart';

/// For synchronous repository methods. Never convert a naturally synchronous
/// call to Future just to use the async variant.
Result<T> executeAndHandleErrorsSync<T>(
  T Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
}) {
  try {
    return Success(call());
  } catch (e, st) {
    log('[$tag] ${e.runtimeType}: $e', stackTrace: st, name: 'Repository');
    return FailureResult(mapper.map(e));
  }
}

/// For asynchronous repository methods (Firebase, Firebase, etc.).
Future<Result<T>> executeAndHandleErrors<T>(
  Future<T> Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
}) async {
  try {
    return Success(await call());
  } catch (e, st) {
    log('[$tag] ${e.runtimeType}: $e', stackTrace: st, name: 'Repository');
    return FailureResult(mapper.map(e));
  }
}

/// For repository methods that return a Stream.
/// Catches synchronous errors during stream setup only.
/// Per-event errors are mapped inside the stream transform.
Stream<Result<T>> executeStreamAndHandleErrors<T>(
  Stream<T> Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
}) {
  try {
    return call().map<Result<T>>(Success.new).handleError((Object e, StackTrace st) {
      log('[$tag] Stream error ${e.runtimeType}: $e', stackTrace: st, name: 'Repository');
      return FailureResult<T>(mapper.map(e));
    });
  } catch (e, st) {
    log('[$tag] Stream setup error ${e.runtimeType}: $e', stackTrace: st, name: 'Repository');
    return Stream.value(FailureResult(mapper.map(e)));
  }
}
```

---

## 5. Repository Implementation Pattern

Repository methods orchestrate data sources and map DTOs to entities.
All exception handling is delegated to the wrappers above.

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

  @override
  Future<Result<void>> signOut() =>
      executeAndHandleErrors(
        () => _remote.signOut(),
        tag: 'AuthRepository.signOut',
        mapper: _mapper,
      );

  @override
  Stream<Result<UserEntity?>> watchAuthState() =>
      executeStreamAndHandleErrors(
        () => _remote.authStateChanges().map((model) => model?.toEntity()),
        tag: 'AuthRepository.watchAuthState',
        mapper: _mapper,
      );
}
```

---

## 6. Failure Message Extension (`core/utils/failure_extension.dart`)

All user-facing failure messages are resolved here. The `switch` is
exhaustive — a compile error is the intended signal when a new `Failure`
subtype is added without updating this extension.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../error/failures.dart';

extension FailureMessaging on BuildContext {
  String failureMessage(Failure failure) {
    final l10n = AppLocalizations.of(this)!;
    return switch (failure) {
      NetworkFailure() => l10n.errorNetwork,
      AuthFailure(:final code) => switch (code) {
        'user-not-found'      => l10n.errorAuthUserNotFound,
        'wrong-password'      => l10n.errorAuthWrongPassword,
        'email-already-in-use'=> l10n.errorAuthEmailInUse,
        'too-many-requests'   => l10n.errorAuthTooManyRequests,
        'user-disabled'       => l10n.errorAuthUserDisabled,
        'weak-password'       => l10n.errorAuthWeakPassword,
        'invalid-email'       => l10n.errorAuthInvalidEmail,
        '401'                 => l10n.errorUnauthorized,
        _                     => l10n.errorAuthGeneric,
      },
      ServerFailure(:final code) => switch (code) {
        '403' => l10n.errorForbidden,
        '404' => l10n.errorNotFound,
        '409' => l10n.errorConflict,
        '422' => l10n.errorUnprocessable,
        '500' => l10n.errorServer,
        _     => l10n.errorServerGeneric,
      },
      PermissionFailure() => l10n.errorPermissionDenied,
      CacheFailure()      => l10n.errorCache,
      StorageFailure()    => l10n.errorStorage,
      ValidationFailure(:final code) => code != null
        ? l10n.errorValidationWithCode(code)
        : l10n.errorValidation,
      UnknownFailure()    => l10n.errorUnknown,
    };
  }
}
```
