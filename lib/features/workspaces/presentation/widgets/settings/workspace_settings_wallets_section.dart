import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/wallet_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/wallets/app_wallet_tile.dart';
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
                    child: AppWalletTile(
                      wallet: wallet,
                      ownerName: memberNamesByUid[wallet.ownerUid],
                      showOwnerName: true,
                      onActionPressed: (canManageAllWallets ||
                              wallet.ownerUid == currentUserId)
                          ? () => onRemoveWallet(wallet)
                          : null,
                      actionIcon: (canManageAllWallets ||
                              wallet.ownerUid == currentUserId)
                          ? Icons.link_off_rounded
                          : null,
                      actionTooltip:
                          context.l10n.workspaceSettingsRemoveWalletAction,
                      isActionLoading: removingWalletId == wallet.id,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
