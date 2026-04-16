// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/domain/entities/wallet_entity.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/wallets/wallet_card.dart';

class WorkspaceWalletsSection extends StatelessWidget {
  const WorkspaceWalletsSection({
    super.key,
    required this.wallets,
    required this.onAddWallets,
  });

  final List<WalletEntity> wallets;
  final VoidCallback onAddWallets;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.workspaceWallets,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              onPressed: onAddWallets,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(l10n.workspaceAddWalletsAction),
            ),
          ],
        ),
        AppSpacing.md.verticalSpace,
        if (wallets.isEmpty)
          _WorkspaceWalletsEmptyState(onAddWallets: onAddWallets)
        else
          Row(
            spacing: AppSpacing.md,
            children: wallets.map((wallet) {
              return GestureDetector(
                onTap: () =>
                    context.push(AppRoutes.walletDetailsPath(wallet.id)),
                child: WalletCard(
                  provider: wallet.provider,
                  phoneNumber: wallet.phoneNumber,
                  balance: wallet.currentBalance,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _WorkspaceWalletsEmptyState extends StatelessWidget {
  const _WorkspaceWalletsEmptyState({super.key, required this.onAddWallets});

  final VoidCallback onAddWallets;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: theme.colorScheme.primary,
            size: 28.responsiveRadius,
          ),
          AppSpacing.md.verticalSpace,
          Text(
            l10n.workspaceWalletsEmptyTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            l10n.workspaceWalletsEmptyDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.md.verticalSpace,
          TextButton.icon(
            onPressed: onAddWallets,
            icon: const Icon(Icons.add_circle_outline),
            label: Text(l10n.workspaceAddWalletsAction),
          ),
        ],
      ),
    );
  }
}
