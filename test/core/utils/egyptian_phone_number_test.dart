import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/core/domain/enums/wallet_provider.dart';
import 'package:wallet_tracker/core/utils/egyptian_phone_number.dart';

void main() {
  group('EgyptianPhoneNumber', () {
    test('normalizes local and international Egyptian formats', () {
      expect(EgyptianPhoneNumber.normalize('01012345678'), '01012345678');
      expect(EgyptianPhoneNumber.normalize('+201012345678'), '01012345678');
      expect(EgyptianPhoneNumber.normalize('201012345678'), '01012345678');
      expect(EgyptianPhoneNumber.normalize('1012345678'), '01012345678');
    });

    test('accepts only supported Egyptian mobile prefixes', () {
      expect(EgyptianPhoneNumber.isValidMobileNumber('01012345678'), isTrue);
      expect(EgyptianPhoneNumber.isValidMobileNumber('01112345678'), isTrue);
      expect(EgyptianPhoneNumber.isValidMobileNumber('01212345678'), isTrue);
      expect(EgyptianPhoneNumber.isValidMobileNumber('01512345678'), isTrue);
      expect(EgyptianPhoneNumber.isValidMobileNumber('01612345678'), isFalse);
      expect(EgyptianPhoneNumber.isValidMobileNumber('12345'), isFalse);
    });

    test('resolves the allowed wallet providers from the prefix', () {
      expect(EgyptianPhoneNumber.allowedProviders('01012345678'), {
        WalletProvider.vodafoneCash,
        WalletProvider.instaPay,
      });
      expect(EgyptianPhoneNumber.allowedProviders('01212345678'), {
        WalletProvider.orangeMoney,
        WalletProvider.instaPay,
      });
      expect(EgyptianPhoneNumber.allowedProviders('01612345678'), isEmpty);
    });

    test('formats valid numbers for display', () {
      expect(
        EgyptianPhoneNumber.formatForDisplay('01012345678'),
        '010 1234 5678',
      );
    });
  });
}
