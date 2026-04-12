import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/app_initializer.dart';

void main() async {
  await initializeApp();
  runApp(const ProviderScope(child: App()));
}
