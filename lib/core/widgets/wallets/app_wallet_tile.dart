import 'package:flutter/material.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../theme/app_color_extension.dart';
import '../../theme/app_responsive.dart';
import '../../theme/app_spacing.dart';
import '../../utils/extensions/localization_extension.dart';
import '../../utils/extensions/phone_number_extension.dart';
import '../../utils/extensions/wallet_provider_ext.dart';
import 'wallet_provider_icon.dart';

class AppWalletTile extends StatelessWidget {
  const AppWalletTile({
    super.key,
    required this.wallet,
    this.ownerName,
    this.showOwnerName = false,
    this.onActionPressed,
    this.actionIcon,
    this.actionTooltip,
    this.isActionLoading = false,
    this.actionColor,
  });

  final WalletEntity wallet;
  final String? ownerName;
  final bool showOwnerName;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final String? actionTooltip;
  final bool isActionLoading;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final provider = wallet.provider;
    final resolvedOwnerName = ownerName?.trim().isNotEmpty == true
        ? ownerName!.trim()
        : context.l10n.workspaceUnknownMember;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: AppSpacing.md.responsiveRadius,
            offset: Offset(0, AppSpacing.xs.responsiveHeight),
          ),
        ],
      ),
      child: Row(
        children: [
          WalletProviderIcon(
            provider: provider,
            size: AppSpacing.xxl.responsiveRadius,
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.displayName(context),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  wallet.phoneNumber.formattedEgyptianPhoneNumber,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (showOwnerName)
                  Text(
                    context.l10n.workspaceSettingsWalletOwner(
                      resolvedOwnerName,
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          if (onActionPressed != null && actionIcon != null || isActionLoading)
            IconButton(
              onPressed: isActionLoading ? null : onActionPressed,
              tooltip: actionTooltip,
              icon: isActionLoading
                  ? SizedBox.square(
                      dimension: AppSpacing.lg.responsiveWidth,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.xxs.responsiveWidth,
                      ),
                    )
                  : Icon(
                      actionIcon,
                      color: actionColor ?? theme.colorScheme.error,
                    ),
            ),
        ],
      ),
    );
  }
}
