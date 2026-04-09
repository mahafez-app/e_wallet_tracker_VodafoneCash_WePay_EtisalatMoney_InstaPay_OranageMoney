import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../domain/enums/wallet_provider.dart';
import '../theme/app_color_extension.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';

class AppWalletCard extends StatelessWidget {
  const AppWalletCard({
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
    final s = S.of(context);
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      width: 288.responsiveWidth,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18.responsiveRadius,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        child: Stack(
          children: [
            // Main content (kept inside padding)
            Padding(
              padding: AppResponsive.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WalletProviderInfo(
                        provider: provider,
                        phoneNumber: phoneNumber,
                      ),
                      _WalletStatusBadge(provider: provider),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.homeTotalWallets,
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

            // Start-aligned vertical bar: RTL-aware, responsive, and theme/provider color
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: AppSpacing.xs.responsiveWidth,
                color: provider.brandColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletProviderInfo extends StatelessWidget {
  const _WalletProviderInfo({
    required this.provider,
    required this.phoneNumber,
  });

  final WalletProvider provider;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: AppResponsive.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: provider.brandColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            provider.icon,
            color: provider.brandColor,
            size: 24.responsiveRadius,
          ),
        ),
        SizedBox(width: AppSpacing.sm.responsiveWidth),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.displayName,
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
      ],
    );
  }
}

class _WalletStatusBadge extends StatelessWidget {
  const _WalletStatusBadge({required this.provider});

  final WalletProvider provider;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.responsiveWidth,
        vertical: 4.responsiveHeight,
      ),
      decoration: BoxDecoration(
        color: provider.brandColor,
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Text(
        s.walletStatusActive,
        style: theme.textTheme.labelSmall?.copyWith(
          color: provider.onBrandColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WalletBalance extends StatelessWidget {
  const _WalletBalance({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          balance.toStringAsFixed(2),
          style: theme.textTheme.titleLarge?.copyWith(
            color: primary,
            fontSize: 24.responsiveFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: AppSpacing.xs.responsiveWidth),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            s.homeCurrency,
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
