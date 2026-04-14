// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/wallet_entity.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../../core/widgets/wallets/wallet_provider_icon.dart';

class WorkspaceWalletSelectionCard extends StatelessWidget {
  const WorkspaceWalletSelectionCard({
    super.key,
    required this.wallet,
    required this.isSelected,
    required this.isLinked,
    required this.onTap,
  });

  final WalletEntity wallet;
  final bool isSelected;
  final bool isLinked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final statusLabel = isLinked
        ? context.l10n.workspaceWalletAlreadyAdded
        : isSelected
        ? context.l10n.workspaceWalletSelected
        : context.l10n.workspaceWalletAvailable;
    final statusBackground = isLinked
        ? theme.colorScheme.secondaryContainer
        : isSelected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final statusForeground = isLinked
        ? theme.colorScheme.onSecondaryContainer
        : isSelected
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: isLinked ? null : onTap,
      borderRadius: BorderRadius.circular(28.responsiveRadius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: AppResponsive.allPadding(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withAlpha(200),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : isLinked
              ? theme.colorScheme.surfaceContainerHighest.withAlpha(60)
              : colors.cardBackground,
          borderRadius: BorderRadius.circular(28.responsiveRadius),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withAlpha(100)
                : isLinked
                ? theme.colorScheme.outlineVariant.withAlpha(60)
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(60),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                WalletProviderIcon(
                  provider: wallet.provider,
                  size: AppSpacing.xxl.responsiveRadius,
                ),
                AppSpacing.sm.horizontalSpace,
                Expanded(
                  child: Text(
                    wallet.provider.displayName(context),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: AppResponsive.symmetricPadding(
                    horizontal: 10.responsiveRadius,
                    vertical: 6.responsiveRadius,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withAlpha(50) : statusBackground,
                    borderRadius: BorderRadius.circular(10.responsiveRadius),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : statusForeground,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.sm.verticalSpace,
            Text(
              wallet.phoneNumber.formattedEgyptianPhoneNumber,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white.withAlpha(200)
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.md.verticalSpace,
            Text(
              context.l10n.currentBalance,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white.withAlpha(150) : theme.colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              wallet.currentBalance.toCurrencyText(context),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
