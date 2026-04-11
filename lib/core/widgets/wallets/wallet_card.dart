// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../domain/enums/wallet_provider.dart';
import '../../theme/app_color_extension.dart';
import '../../theme/app_responsive.dart';
import '../../theme/app_spacing.dart';
import '../../utils/extensions/amount_extension.dart';
import '../../utils/extensions/localization_extension.dart';
import '../../utils/extensions/wallet_provider_ext.dart';
import 'wallet_provider_info.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.provider,
    required this.phoneNumber,
    required this.balance,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      width: 290.responsiveWidth,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: BorderDirectional(
          start: BorderSide(
            color: provider.brandColor,
            width: 5.responsiveWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18.responsiveRadius,
            offset: Offset(0, 8.responsiveHeight),
          ),
        ],
      ),
      child: Padding(
        padding: AppResponsive.allPadding(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WalletProviderInfo(provider: provider, phoneNumber: phoneNumber),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentBalance,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                _WalletBalance(balance: balance),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletBalance extends StatelessWidget {
  const _WalletBalance({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          balance.toLocalizedAmount(context),
          style: theme.textTheme.titleLarge?.copyWith(
            color: primary,
            fontSize: 24.responsiveFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.xs.horizontalSpace,
        Padding(
          padding: AppResponsive.onlyPadding(bottom: 4),
          child: Text(
            l10n.currency,
            style: theme.textTheme.labelSmall?.copyWith(
              color: primary,
              fontSize: 12.responsiveFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
