import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/app_initializer.dart';
import 'features/settings/providers/settings_providers.dart';

void main() async {
  final dependencies = await initializeApp();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          dependencies.sharedPreferences,
        ),
      ],
      child: const App(),
    ),
  );
}
