import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(Object error) => switch (error) {
    // — Dio / REST ——————————————————————————————————————————
    DioException e when _isNetworkError(e) => NetworkFailure(
      technicalMessage: e.type.name,
    ),
    DioException e when e.response?.statusCode == 401 => AuthFailure(
      code: '401',
      technicalMessage: _extractDioMessage(e),
    ),
    DioException e when e.response?.statusCode == 403 => PermissionFailure(
      code: '403',
      technicalMessage: _extractDioMessage(e),
    ),
    DioException e => ServerFailure(
      code: e.response?.statusCode?.toString(),
      technicalMessage: _extractDioMessage(e),
    ),
    // — Firebase Auth ———————————————————————————————————————
    // Must precede FirebaseException — FirebaseAuthException extends it.
    FirebaseAuthException e => AuthFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    // — Firestore offline ———————————————————————————————————
    FirebaseException e when e.code == 'unavailable' => CacheFailure(
      technicalMessage: 'Firestore unavailable — device offline',
    ),
    // — Firestore permission denied ————————————————————————
    FirebaseException e when e.code == 'permission-denied' => PermissionFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    // — Generic Firebase ————————————————————————————————————
    FirebaseException e => ServerFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    // — OS-level connectivity ——————————————————————————————
    SocketException e => NetworkFailure(technicalMessage: e.message),
    // — Catch-all ——————————————————————————————————————————
    _ => UnknownFailure(technicalMessage: error.toString()),
  };

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionTimeout;

  String? _extractDioMessage(DioException e) =>
      e.response?.data is Map<String, dynamic>
      ? e.response?.data['message'] as String?
      : e.message;
}
