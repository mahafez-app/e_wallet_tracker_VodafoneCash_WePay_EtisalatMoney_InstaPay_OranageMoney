import 'dart:async';
import 'dart:io';

import 'package:mobile_number/mobile_number.dart';

import '../utils/egyptian_phone_number.dart';

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
          .map(EgyptianPhoneNumber.normalize)
          .where(EgyptianPhoneNumber.isValidMobileNumber)
          .toSet()
          .toList();
    }

    final singleNumber = await MobileNumber.mobileNumber;
    if (_hasUsablePhoneNumber(singleNumber)) {
      final normalizedPhoneNumber = EgyptianPhoneNumber.normalize(
        singleNumber!,
      );
      if (EgyptianPhoneNumber.isValidMobileNumber(normalizedPhoneNumber)) {
        return [normalizedPhoneNumber];
      }
    }

    return [];
  }

  bool _hasUsablePhoneNumber(String? value) {
    return value != null && value.isNotEmpty && value != 'null';
  }
}
