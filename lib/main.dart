import 'dart:developer';

import 'package:flutter/widgets.dart';

import 'app_bootstrap.dart';
import 'core/di/app_initializer.dart';

// lib/main.dart
void main() async {
  final initializationResult = await initializeApp();

  initializationResult.fold((failure) {
    log('BOOTSTRAP FAILED', name: 'main');
    log('Type: ${failure.runtimeType}', name: 'main');
    log('Technical Message: ${failure.technicalMessage}', name: 'main');
    log('Code: ${failure.code}', name: 'main');
  }, (_) => log('BOOTSTRAP SUCCESS', name: 'main'));

  runApp(AppBootstrap(initializationResult: initializationResult));
}
