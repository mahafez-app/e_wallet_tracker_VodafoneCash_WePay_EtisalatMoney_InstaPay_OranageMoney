import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import '../../domain/enums/wallet_provider.dart';
import '../../theme/app_colors.dart';

extension WalletProviderDisplay on WalletProvider {
  String displayName(BuildContext context) => switch (this) {
    WalletProvider.vodafoneCash => context.l10n.providerVodafone,
    WalletProvider.orangeMoney => context.l10n.providerOrange,
    WalletProvider.etisalatCash => context.l10n.providerEtisalat,
    WalletProvider.instaPay => context.l10n.providerInstapay,
    WalletProvider.wePay => context.l10n.providerWePay,
    WalletProvider.unknown => context.l10n.providerUnknown,
  };

  Color get brandColor => switch (this) {
    WalletProvider.vodafoneCash => AppColors.vodafoneRed,
    WalletProvider.orangeMoney => AppColors.orangeMoney,
    WalletProvider.etisalatCash => AppColors.etisalatGreen,
    WalletProvider.instaPay => AppColors.instaPayNavy,
    WalletProvider.wePay => AppColors.wePayPurple,
    WalletProvider.unknown => AppColors.providerUnknownNeutral,
  };

  Color get onBrandColor => switch (this) {
    WalletProvider.vodafoneCash => AppColors.white,
    WalletProvider.etisalatCash => AppColors.white,
    WalletProvider.instaPay => AppColors.white,
    WalletProvider.wePay => AppColors.white,
    WalletProvider.orangeMoney => AppColors.black,
    WalletProvider.unknown => AppColors.black,
  };

  IconData get icon => switch (this) {
    WalletProvider.vodafoneCash => Icons.phone_android,
    WalletProvider.orangeMoney => Icons.phone_android,
    WalletProvider.etisalatCash => Icons.phone_android,
    WalletProvider.wePay => Icons.phone_android,
    WalletProvider.instaPay => Icons.flash_on,
    WalletProvider.unknown => Icons.account_balance_wallet,
  };
}
