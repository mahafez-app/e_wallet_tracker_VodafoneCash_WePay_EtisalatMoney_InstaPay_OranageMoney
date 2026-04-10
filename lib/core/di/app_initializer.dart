import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_tracker/firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
