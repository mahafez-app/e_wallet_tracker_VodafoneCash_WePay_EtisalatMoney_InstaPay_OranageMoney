import 'package:equatable/equatable.dart';
import 'failures.dart';

sealed class Result<T> extends Equatable {
  const Result();

  /// Standard consumption path inside a Notifier.
  /// Use cases must NEVER call fold() — they return `Result<T>` untouched.
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
