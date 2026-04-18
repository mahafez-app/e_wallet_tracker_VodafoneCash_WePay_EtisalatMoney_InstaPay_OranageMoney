import '../domain/enums/wallet_provider.dart';

abstract final class EgyptianPhoneNumber {
  static const int mobileNumberLength = 11;

  static const Map<String, WalletProvider> _prefixToProvider = {
    '010': WalletProvider.vodafoneCash,
    '011': WalletProvider.etisalatCash,
    '012': WalletProvider.orangeMoney,
    '015': WalletProvider.wePay,
  };

  static String normalize(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.startsWith('0020') && digitsOnly.length == 14) {
      return '0${digitsOnly.substring(4)}';
    }

    if (digitsOnly.startsWith('20') && digitsOnly.length == 12) {
      return '0${digitsOnly.substring(2)}';
    }

    if (digitsOnly.startsWith('1') && digitsOnly.length == 10) {
      return '0$digitsOnly';
    }

    return digitsOnly;
  }

  static String? tryNormalizeMobile(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return null;
    }

    final normalizedPhoneNumber = normalize(phoneNumber);
    if (!isValidMobileNumber(normalizedPhoneNumber)) {
      return null;
    }

    return normalizedPhoneNumber;
  }

  static bool isValidMobileNumber(String phoneNumber) {
    final normalizedPhoneNumber = normalize(phoneNumber);
    if (normalizedPhoneNumber.length != mobileNumberLength) {
      return false;
    }

    return _prefixToProvider.containsKey(normalizedPhoneNumber.substring(0, 3));
  }

  static WalletProvider? primaryProvider(String phoneNumber) {
    if (!isValidMobileNumber(phoneNumber)) return null;

    return _prefixToProvider[normalize(phoneNumber).substring(0, 3)];
  }

  static Set<WalletProvider> allowedProviders(String phoneNumber) {
    final provider = primaryProvider(phoneNumber);
    if (provider == null) return const <WalletProvider>{};

    return {provider, WalletProvider.instaPay};
  }

  static String formatForDisplay(String phoneNumber) {
    return normalize(phoneNumber);
    // final normalizedPhoneNumber = normalize(phoneNumber);
    // if (!isValidMobileNumber(normalizedPhoneNumber)) {
    //   return normalizedPhoneNumber;
    // }

    // return '${normalizedPhoneNumber.substring(0, 3)} '
    //     '${normalizedPhoneNumber.substring(3, 7)} '
    //     '${normalizedPhoneNumber.substring(7)}';
  }
}
