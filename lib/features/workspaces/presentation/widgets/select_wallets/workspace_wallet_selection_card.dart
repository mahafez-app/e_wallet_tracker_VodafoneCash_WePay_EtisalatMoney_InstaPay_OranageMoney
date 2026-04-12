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
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final backgroundColor = isSelected
        ? theme.colorScheme.primaryContainer.withAlpha(76)
        : colors.cardBackground;
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
      borderRadius: BorderRadius.circular(24.responsiveRadius),
      child: Container(
        padding: AppResponsive.allPadding(AppSpacing.lg),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24.responsiveRadius),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.responsiveWidth : 1.responsiveWidth,
          ),
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
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: AppResponsive.symmetricPadding(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackground,
                    borderRadius: BorderRadius.circular(999.responsiveRadius),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.sm.verticalSpace,
            Text(
              wallet.phoneNumber.formattedEgyptianPhoneNumber,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.md.verticalSpace,
            Text(
              context.l10n.currentBalance,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              wallet.currentBalance.toCurrencyText(context),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
