import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/app_initializer.dart';

// The top-level background SMS handler is declared in SmsTransactionService
// and registered via Telephony.instance.listenIncomingSms inside that service.
// It must be a top-level function annotated @pragma('vm:entry-point') — both
// requirements are satisfied in core/services/sms_transaction_service.dart.

void main() async {
  await initializeApp();
  Telephony.instance.simOperator
      .then((operator) {
        debugPrint('SIM operator code: $operator');
      })
      .catchError((e) {
        debugPrint('Failed to get SIM operator code: $e');
      });

  Telephony.instance.simOperatorName
      .then((operator) {
        debugPrint('SIM operator: $operator');
      })
      .catchError((e) {
        debugPrint('Failed to get SIM operator: $e');
      });
  runApp(const ProviderScope(child: App()));
}
