import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';

final class AppBootstrapDependencies {
  const AppBootstrapDependencies({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
}

Future<AppBootstrapDependencies> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final sharedPreferences = await SharedPreferences.getInstance();

    return AppBootstrapDependencies(sharedPreferences: sharedPreferences);
  } catch (error, stackTrace) {
    log(
      'Failed to initialize app dependencies: $error',
      name: 'initializeApp',
      stackTrace: stackTrace,
    );
    rethrow;
  }
}
