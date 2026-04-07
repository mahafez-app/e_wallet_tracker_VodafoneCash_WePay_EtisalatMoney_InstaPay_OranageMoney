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
