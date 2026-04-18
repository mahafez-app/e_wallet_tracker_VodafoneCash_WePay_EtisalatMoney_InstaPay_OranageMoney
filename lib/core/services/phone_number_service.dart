import 'dart:developer';

import 'package:mobile_number/mobile_number.dart';

import '../utils/egyptian_phone_number.dart';

abstract interface class PhoneNumberService {
  Future<List<String>> getDevicePhoneNumbers();
}

final class PhoneNumberServiceImpl implements PhoneNumberService {
  const PhoneNumberServiceImpl();

  static const _tag = 'PhoneNumberService';

  @override
  Future<List<String>> getDevicePhoneNumbers() async {
    try {
      final simCards = await MobileNumber.getSimCards ?? <SimCard>[];
      final normalizedNumbers = simCards
          .map(_normalizeSimPhoneNumber)
          .whereType<String>()
          .toSet()
          .toList(growable: false);

      log(
        'Resolved ${normalizedNumbers.length} device phone number(s).',
        name: _tag,
      );
      return normalizedNumbers;
    } catch (error, stackTrace) {
      log(
        'Failed to resolve device phone numbers.',
        name: _tag,
        error: error,
        stackTrace: stackTrace,
      );
      return const <String>[];
    }
  }

  String? _normalizeSimPhoneNumber(SimCard simCard) {
    final rawPhoneNumber =
        '${simCard.countryPhonePrefix ?? ''}${simCard.number ?? ''}';
    return EgyptianPhoneNumber.tryNormalizeMobile(rawPhoneNumber);
  }
}
