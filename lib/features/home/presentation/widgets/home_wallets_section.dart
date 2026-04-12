// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/wallets/wallet_card.dart';
import 'home_section_header.dart';

class HomeWalletsSection extends StatelessWidget {
  const HomeWalletsSection({super.key, required this.wallets});

  final List<WalletEntity> wallets;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: l10n.yourWallets,
          actionLabel: l10n.addWallet,
          icon: Icons.add_card_outlined,
          onPressed: () => context.push(AppRoutes.addWallet),
        ),
        AppSpacing.md.verticalSpace,
        if (wallets.isEmpty)
          const _AddWalletEmptyCard()
        else
          SizedBox(
            height: 151.responsiveHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: wallets.length,
              separatorBuilder: (_, _) => AppSpacing.md.horizontalSpace,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.walletDetailsPath(wallet.id)),
                  child: WalletCard(
                    provider: wallet.provider,
                    phoneNumber: wallet.phoneNumber,
                    balance: wallet.currentBalance,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AddWalletEmptyCard extends StatelessWidget {
  const _AddWalletEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.addWallet),
      child: Container(
        width: double.infinity,
        padding: AppResponsive.allPadding(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
          borderRadius: BorderRadius.circular(24.responsiveRadius),
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
              l10n.createWalletEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              l10n.createWalletEmptyDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
