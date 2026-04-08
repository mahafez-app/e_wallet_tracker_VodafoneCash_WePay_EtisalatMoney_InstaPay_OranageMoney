import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum WalletProvider {
  vodafoneCash,
  orangeMoney,
  etisalatCash,
  instaPay,
  wePay,
  fawry,
  bank,
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
      case 'fawry':
        return WalletProvider.fawry;
      case 'bank':
        return WalletProvider.bank;
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
      case WalletProvider.fawry:
        return 'fawry';
      case WalletProvider.bank:
        return 'bank';
      case WalletProvider.unknown:
        return 'unknown';
    }
  }
}

extension WalletProviderExt on WalletProvider {
  String get displayName {
    switch (this) {
      case WalletProvider.vodafoneCash:
        return "Vodafone Cash";
      case WalletProvider.orangeMoney:
        return "Orange Money";
      case WalletProvider.etisalatCash:
        return "Etisalat Cash";
      case WalletProvider.instaPay:
        return "InstaPay";
      case WalletProvider.wePay:
        return "WE Pay";
      case WalletProvider.fawry:
        return "Fawry";
      case WalletProvider.bank:
        return "Bank Account";
      case WalletProvider.unknown:
        return "Wallet";
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
      case WalletProvider.fawry:
        return AppColors.fawryYellow;
      case WalletProvider.bank:
        return AppColors.bankSlate;
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
      case WalletProvider.bank:
      case WalletProvider.unknown:
        return AppColors.white;
      case WalletProvider.orangeMoney:
      case WalletProvider.fawry:
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
      case WalletProvider.fawry:
        return Icons.storefront;
      case WalletProvider.bank:
        return Icons.account_balance;
      case WalletProvider.unknown:
        return Icons.account_balance_wallet;
    }
  }
}