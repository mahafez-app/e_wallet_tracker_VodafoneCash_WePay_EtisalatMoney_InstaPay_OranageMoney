import 'dart:async';
import 'dart:io';

import 'package:mobile_number/mobile_number.dart';

abstract interface class PhoneNumberService {
  Future<List<String>> getDevicePhoneNumbers();
}

class PhoneNumberServiceImpl implements PhoneNumberService {
  static const Duration _lookupTimeout = Duration(seconds: 5);

  @override
  Future<List<String>> getDevicePhoneNumbers() async {
    if (!Platform.isAndroid) return [];

    final hasPermission = await MobileNumber.hasPhonePermission;
    if (!hasPermission) return [];

    return _readPhoneNumbers().timeout(_lookupTimeout);
  }

  Future<List<String>> _readPhoneNumbers() async {
    final simCards = await MobileNumber.getSimCards;
    if (simCards != null && simCards.isNotEmpty) {
      return simCards
          .map((simCard) => simCard.number)
          .whereType<String>()
          .where(_hasUsablePhoneNumber)
          .map(_cleanPhoneNumber)
          .toSet()
          .toList();
    }

    final singleNumber = await MobileNumber.mobileNumber;
    if (_hasUsablePhoneNumber(singleNumber)) {
      return [_cleanPhoneNumber(singleNumber!)];
    }

    return [];
  }

  bool _hasUsablePhoneNumber(String? value) {
    return value != null && value.isNotEmpty && value != 'null';
  }

  String _cleanPhoneNumber(String number) {
    var cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('+20')) {
      cleaned = '0${cleaned.substring(3)}';
    } else if (cleaned.startsWith('20') && cleaned.length == 12) {
      cleaned = '0${cleaned.substring(2)}';
    }
    return cleaned;
  }
}
