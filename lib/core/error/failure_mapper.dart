import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'failures.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(Object error) => switch (error) {
    Failure f => f,
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
}
