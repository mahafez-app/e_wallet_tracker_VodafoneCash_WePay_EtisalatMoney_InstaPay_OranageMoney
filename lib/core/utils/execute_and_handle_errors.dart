import 'dart:developer';
import '../error/failure_mapper.dart';
import '../error/result.dart';

/// For synchronous repository methods. Never convert a naturally synchronous
/// call to Future just to use the async variant.
Result<T> executeAndHandleErrorsSync<T>(
  T Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
  String logName = 'Repository',
}) {
  try {
    return Success(call());
  } catch (e, st) {
    log('[$tag] ${e.runtimeType}: $e', stackTrace: st, name: logName);
    return FailureResult(mapper.map(e));
  }
}

/// For asynchronous repository methods (Dio, Firebase, etc.).
Future<Result<T>> executeAndHandleErrors<T>(
  Future<T> Function() call, {
  required String tag,
  FailureMapper mapper = const FailureMapper(),
  String logName = 'Repository',
}) async {
  try {
    return Success(await call());
  } catch (e, st) {
    log('[$tag] ${e.runtimeType}: $e', stackTrace: st, name: logName);
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
  String logName = 'Repository',
}) {
  try {
    return call().map<Result<T>>(Success.new).handleError((
      Object e,
      StackTrace st,
    ) {
      log(
        '[$tag] Stream error ${e.runtimeType}: $e',
        stackTrace: st,
        name: logName,
      );
      return FailureResult<T>(mapper.map(e));
    });
  } catch (e, st) {
    log(
      '[$tag] Stream setup error ${e.runtimeType}: $e',
      stackTrace: st,
      name: logName,
    );
    return Stream.value(FailureResult(mapper.map(e)));
  }
}
