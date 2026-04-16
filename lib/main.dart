import 'package:flutter/widgets.dart';

import 'app_bootstrap.dart';
import 'core/di/app_initializer.dart';

// lib/main.dart
void main() async {
  final initializationResult = await initializeApp();

  initializationResult.fold((failure) {
    // Print the technical message and the type of failure
    print('❌ BOOTSTRAP FAILED');
    print('Type: ${failure.runtimeType}');
    print('Technical Message: ${failure.technicalMessage}');
    print('Code: ${failure.code}');
  }, (dependencies) => print('✅ BOOTSTRAP SUCCESS'));

  runApp(AppBootstrap(initializationResult: initializationResult));
}
