import 'dart:io';

import 'package:mobile_number/mobile_number.dart';

abstract interface class PhoneNumberService {
  Future<List<String>> getDevicePhoneNumbers();
}

class PhoneNumberServiceImpl implements PhoneNumberService {
  @override
  Future<List<String>> getDevicePhoneNumbers() async {
    if (!Platform.isAndroid) return [];

    try {
      final hasPermission = await MobileNumber.hasPhonePermission;
      if (!hasPermission) {
        await MobileNumber.requestPhonePermission;
        final granted = await MobileNumber.hasPhonePermission;
        if (!granted) return [];
      }

      final simCards = await MobileNumber.getSimCards;
      if (simCards == null || simCards.isEmpty) {
        final singleNumber = await MobileNumber.mobileNumber;
        if (singleNumber != null &&
            singleNumber.isNotEmpty &&
            singleNumber != 'null') {
          return [_cleanPhoneNumber(singleNumber)];
        }
        return [];
      }

      final numbers = <String>{};
      for (final sim in simCards) {
        final number = sim.number;
        if (number != null && number.isNotEmpty && number != 'null') {
          numbers.add(_cleanPhoneNumber(number));
        }
      }
      return numbers.toList();
    } catch (e) {
      return [];
    }
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
