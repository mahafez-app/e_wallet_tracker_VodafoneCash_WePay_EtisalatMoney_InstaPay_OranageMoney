import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:wallet_tracker/core/domain/enums/wallet_provider.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/theme/app_spacing.dart';
import 'package:wallet_tracker/core/utils/extensions/wallet_provider_ext.dart';

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
        Container(
          padding: AppResponsive.allPadding(AppSpacing.xs),
          decoration: BoxDecoration(
            color: provider.brandColor.withAlpha(25),
            borderRadius: BorderRadius.circular(borderRadius.responsiveRadius),
          ),
          child: Icon(
            provider.icon,
            color: provider.brandColor,
            size: 24.responsiveRadius,
          ),
        ),
        AppSpacing.sm.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.displayName(context),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              phoneNumber,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        Spacer(),
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
      padding: AppResponsive.symmetricPadding(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: provider.brandColor.withAlpha(25),
        borderRadius: BorderRadius.all(Radius.circular(100.responsiveRadius)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.responsiveRadius,
            height: 8.responsiveRadius,
            decoration: BoxDecoration(
              color: provider.brandColor,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.xs.horizontalSpace,
          Text(
            context.l10n.walletStatusActive,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: provider.brandColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
