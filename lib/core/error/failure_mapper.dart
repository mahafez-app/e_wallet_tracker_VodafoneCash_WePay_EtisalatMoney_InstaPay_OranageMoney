import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahafez_core/mahafez_core.dart';
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
    // — OS-level / Platform leaks ——————————————————————————
    PlatformException e
        when e.code == 'firebase_firestore' &&
            (e.message?.contains('UNAVAILABLE') ?? false) =>
      NetworkFailure(technicalMessage: 'Firestore unavailable — ${e.message}'),
    PlatformException e => UnknownFailure(technicalMessage: e.message),
    SocketException e => NetworkFailure(technicalMessage: e.message),
    // — Catch-all ——————————————————————————————————————————
    _ => UnknownFailure(technicalMessage: error.toString()),
  };
}
