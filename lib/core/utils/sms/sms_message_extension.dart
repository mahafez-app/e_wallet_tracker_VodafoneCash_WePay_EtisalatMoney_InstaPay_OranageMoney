import 'package:another_telephony/telephony.dart';

extension SmsMessageDateExt on SmsMessage {
  /// Safely converts the native SMS timestamp (which can be null) 
  /// into a Dart [DateTime], defaulting to [DateTime.now()] if missing.
  DateTime get receivedAt => date != null
      ? DateTime.fromMillisecondsSinceEpoch(date!)
      : DateTime.now();
}
