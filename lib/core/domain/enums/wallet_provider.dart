import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../theme/app_colors.dart';

enum WalletProvider {
  vodafoneCash,
  orangeMoney,
  etisalatCash,
  instaPay,
  wePay,
  unknown;

  static WalletProvider fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '_')) {
      case 'vodafone_cash':
      case 'vodafone':
        return WalletProvider.vodafoneCash;
      case 'orange_money':
      case 'orange':
        return WalletProvider.orangeMoney;
      case 'etisalat_cash':
      case 'etisalat':
        return WalletProvider.etisalatCash;
      case 'instapay':
        return WalletProvider.instaPay;
      case 'we_pay':
      case 'we':
        return WalletProvider.wePay;

      default:
        return WalletProvider.unknown;
    }
  }

  String get toValue {
    switch (this) {
      case WalletProvider.vodafoneCash:
        return 'vodafone_cash';
      case WalletProvider.orangeMoney:
        return 'orange_money';
      case WalletProvider.etisalatCash:
        return 'etisalat_cash';
      case WalletProvider.instaPay:
        return 'instapay';
      case WalletProvider.wePay:
        return 'we_pay';

      case WalletProvider.unknown:
        return 'unknown';
    }
  }
}

extension WalletProviderExt on WalletProvider {
  String displayName(BuildContext context) {
    final s = S.of(context);
    switch (this) {
      case WalletProvider.vodafoneCash:
        return s.providerVodafone;
      case WalletProvider.orangeMoney:
        return s.providerOrange;
      case WalletProvider.etisalatCash:
        return s.providerEtisalat;
      case WalletProvider.instaPay:
        return s.providerInstapay;
      case WalletProvider.wePay:
        return s.providerWePay;

      case WalletProvider.unknown:
        return s.providerUnknown;
    }
  }

  Color get brandColor {
    switch (this) {
      case WalletProvider.vodafoneCash:
        return AppColors.vodafoneRed;
      case WalletProvider.orangeMoney:
        return AppColors.orangeMoney;
      case WalletProvider.etisalatCash:
        return AppColors.etisalatGreen;
      case WalletProvider.instaPay:
        return AppColors.instaPayNavy;
      case WalletProvider.wePay:
        return AppColors.wePayPurple;

      case WalletProvider.unknown:
        return AppColors.providerUnknownNeutral;
    }
  }
  
  Color get onBrandColor {
        switch (this) {
      case WalletProvider.vodafoneCash:
      case WalletProvider.etisalatCash:
      case WalletProvider.instaPay:
      case WalletProvider.wePay:
      case WalletProvider.unknown:
        return AppColors.white;
      case WalletProvider.orangeMoney:
        return AppColors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case WalletProvider.vodafoneCash:
      case WalletProvider.orangeMoney:
      case WalletProvider.etisalatCash:
      case WalletProvider.wePay:
        return Icons.phone_android;
      case WalletProvider.instaPay:
        return Icons.flash_on;

      case WalletProvider.unknown:
        return Icons.account_balance_wallet;
    }
  }
}