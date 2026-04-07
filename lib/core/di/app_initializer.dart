import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_tracker/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase when firebase_options.dart is generated
  // Run: flutterfire configure
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Add other async init here: Hive.initFlutter(), etc.
}
