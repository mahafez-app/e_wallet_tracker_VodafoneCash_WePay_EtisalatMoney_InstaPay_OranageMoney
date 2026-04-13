import 'package:flutter/widgets.dart';

import 'app_bootstrap.dart';
import 'core/di/app_initializer.dart';

void main() async {
  final initializationResult = await initializeApp();
  runApp(AppBootstrap(initializationResult: initializationResult));
}
