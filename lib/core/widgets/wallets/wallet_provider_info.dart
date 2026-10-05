import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';
import 'package:wallet_tracker/core/utils/extensions/phone_number_extension.dart';
import 'package:wallet_tracker/core/utils/extensions/wallet_provider_ext.dart';

import 'wallet_provider_icon.dart';

class WalletProviderInfo extends StatelessWidget {
  const WalletProviderInfo({
    super.key,
    required this.provider,
    required this.phoneNumber,
    this.borderRadius = 20.0,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        WalletProviderIcon(provider: provider, size: 40.responsiveRadius),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  provider.displayName(context).toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.xs.verticalSpace,
              FittedBox(
                child: Text(
                  phoneNumber.formattedEgyptianPhoneNumber,
                  maxLines: 1,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.md.horizontalSpace,
        _WalletStatusBadge(provider: provider),
      ],
    );
  }
}

class _WalletStatusBadge extends StatelessWidget {
  const _WalletStatusBadge({required this.provider});

  final WalletProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppResponsive.symmetricPadding(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: provider.brandColor.withAlpha(30),
        borderRadius: BorderRadius.all(Radius.circular(8.responsiveRadius)),
        border: Border.all(
          color: provider.brandColor.withAlpha(60),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.responsiveRadius,
            height: 6.responsiveRadius,
            decoration: BoxDecoration(
              color: provider.brandColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: provider.brandColor.withAlpha(150),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          AppSpacing.xs.horizontalSpace,
          Text(
            context.l10n.walletStatusActive.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: provider.brandColor,
              fontWeight: FontWeight.w900,
              fontSize: 9.responsiveFont,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
