import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../theme/app_colors.dart';
import '../app_assets.dart';

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

  String? get iconAssetPath => switch (this) {
    WalletProvider.vodafoneCash => AppAssets.iconVodafone,
    WalletProvider.orangeMoney => AppAssets.iconOrange,
    WalletProvider.etisalatCash => AppAssets.iconEtisalat,
    WalletProvider.wePay => AppAssets.iconWe,
    WalletProvider.instaPay => AppAssets.iconInstaPay,
    WalletProvider.unknown => null,
  };
}
