import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../../firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _logSimInfo();
}

void _logSimInfo() {
  Telephony.instance.simOperator
      .then((op) => log('SIM operator code: $op', name: 'AppInit'))
      .catchError((Object e) => log('SIM operator code error: $e', name: 'AppInit'));

  Telephony.instance.simOperatorName
      .then((op) => log('SIM operator name: $op', name: 'AppInit'))
      .catchError((Object e) => log('SIM operator name error: $e', name: 'AppInit'));
}
