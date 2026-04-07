// File generated for Firebase project wiring in this workspace.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

final class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web in this project.',
      );
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      TargetPlatform.macOS => ios,
      _ => throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      ),
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaCIVvmOsJ3riqbe_J5GJjYhIIaBFZPco',
    appId: '1:467978053763:android:e4863e0e095e4fc75dd3b6',
    messagingSenderId: '467978053763',
    projectId: 'wallet-tracker-radyhaggag',
    storageBucket: 'wallet-tracker-radyhaggag.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEcJReAfMO9JejZzRRJgTbtMKq49ApTZ8',
    appId: '1:467978053763:ios:dae8db17a3b8172b5dd3b6',
    messagingSenderId: '467978053763',
    projectId: 'wallet-tracker-radyhaggag',
    storageBucket: 'wallet-tracker-radyhaggag.firebasestorage.app',
    iosBundleId: 'com.radyhaggag.mahafez',
  );
}
