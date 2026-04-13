import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/result.dart';
import '../utils/execute_and_handle_errors.dart';
import '../../firebase_options.dart';

final class AppBootstrapDependencies {
  const AppBootstrapDependencies({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
}

Future<Result<AppBootstrapDependencies>> initializeApp() {
  return executeAndHandleErrors(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      final sharedPreferences = await SharedPreferences.getInstance();

      return AppBootstrapDependencies(sharedPreferences: sharedPreferences);
    },
    tag: 'initializeApp',
    logName: 'Bootstrap',
  );
}
