import '../error/result.dart';

abstract interface class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

abstract interface class NoParamsUseCase<T> {
  Future<Result<T>> call();
}

abstract interface class StreamUseCase<T, P> {
  Stream<Result<T>> call(P params);
}

abstract interface class NoParamsStreamUseCase<T> {
  Stream<Result<T>> call();
}
