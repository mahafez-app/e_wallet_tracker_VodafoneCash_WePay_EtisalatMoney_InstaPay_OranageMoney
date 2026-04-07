import 'package:flutter/widgets.dart';
import 'package:wallet_tracker/generated/l10n.dart';
import '../error/failures.dart';

extension FailureMessaging on BuildContext {
  String failureMessage(Failure failure) {
    final l10n = S.of(this);
    return switch (failure) {
      NetworkFailure() => l10n.errorNetwork,
      AuthFailure(:final code) => switch (code) {
        'user-not-found' => l10n.errorAuthUserNotFound,
        'wrong-password' => l10n.errorAuthWrongPassword,
        'email-already-in-use' => l10n.errorAuthEmailInUse,
        'too-many-requests' => l10n.errorAuthTooManyRequests,
        'user-disabled' => l10n.errorAuthUserDisabled,
        'weak-password' => l10n.errorAuthWeakPassword,
        'invalid-email' => l10n.errorAuthInvalidEmail,
        '401' => l10n.errorUnauthorized,
        _ => l10n.errorAuthGeneric,
      },
      ServerFailure(:final code) => switch (code) {
        '403' => l10n.errorForbidden,
        '404' => l10n.errorNotFound,
        '409' => l10n.errorConflict,
        '422' => l10n.errorUnprocessable,
        '500' => l10n.errorServer,
        _ => l10n.errorServerGeneric,
      },
      PermissionFailure() => l10n.errorPermissionDenied,
      CacheFailure() => l10n.errorCache,
      StorageFailure() => l10n.errorStorage,
      ValidationFailure(:final code) =>
        code != null
            ? l10n.errorValidationWithCode(code)
            : l10n.errorValidation,
      UnknownFailure() => l10n.errorUnknown,
    };
  }
}
