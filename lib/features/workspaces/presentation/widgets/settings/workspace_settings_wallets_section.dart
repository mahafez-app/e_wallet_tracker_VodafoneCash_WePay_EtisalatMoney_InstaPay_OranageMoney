import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/wallet_entity.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../../core/widgets/wallets/wallet_provider_icon.dart';
import 'workspace_settings_empty_state_card.dart';
import 'workspace_settings_section_title.dart';

class WorkspaceSettingsWalletsSection extends StatelessWidget {
  const WorkspaceSettingsWalletsSection({
    super.key,
    required this.wallets,
    required this.memberNamesByUid,
    required this.currentUserId,
    required this.canManageAllWallets,
    required this.removingWalletId,
    required this.onRemoveWallet,
  });

  final List<WalletEntity> wallets;
  final Map<String, String> memberNamesByUid;
  final String? currentUserId;
  final bool canManageAllWallets;
  final String? removingWalletId;
  final ValueChanged<WalletEntity> onRemoveWallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkspaceSettingsSectionTitle(title: context.l10n.workspaceWallets),
        AppSpacing.xs.verticalSpace,
        Text(
          canManageAllWallets
              ? context.l10n.workspaceSettingsWalletsOwnerDescription
              : context.l10n.workspaceSettingsWalletsMemberDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.md.verticalSpace,
        if (wallets.isEmpty)
          WorkspaceSettingsEmptyStateCard(
            message: canManageAllWallets
                ? context.l10n.workspaceSettingsWalletsEmptyOwner
                : context.l10n.workspaceSettingsWalletsEmptyMember,
          )
        else
          Column(
            children: wallets
                .map(
                  (wallet) => Padding(
                    padding: AppResponsive.onlyPadding(bottom: AppSpacing.md),
                    child: _WorkspaceSettingsWalletTile(
                      wallet: wallet,
                      ownerName: memberNamesByUid[wallet.ownerUid],
                      showOwnerName: true,
                      canRemove:
                          canManageAllWallets ||
                          wallet.ownerUid == currentUserId,
                      isRemoving: removingWalletId == wallet.id,
                      onRemove: () => onRemoveWallet(wallet),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _WorkspaceSettingsWalletTile extends StatelessWidget {
  const _WorkspaceSettingsWalletTile({
    required this.wallet,
    required this.ownerName,
    required this.showOwnerName,
    required this.canRemove,
    required this.isRemoving,
    required this.onRemove,
  });

  final WalletEntity wallet;
  final String? ownerName;
  final bool showOwnerName;
  final bool canRemove;
  final bool isRemoving;
  final VoidCallback onRemove;

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
        color: theme.colorScheme.surface,
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
          if (canRemove || isRemoving)
            IconButton(
              onPressed: isRemoving ? null : onRemove,
              tooltip: context.l10n.workspaceSettingsRemoveWalletAction,
              icon: isRemoving
                  ? SizedBox.square(
                      dimension: AppSpacing.lg.responsiveWidth,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.xxs.responsiveWidth,
                      ),
                    )
                  : Icon(
                      Icons.delete_outline_rounded,
                      color: theme.colorScheme.error,
                    ),
            ),
        ],
      ),
    );
  }
}
