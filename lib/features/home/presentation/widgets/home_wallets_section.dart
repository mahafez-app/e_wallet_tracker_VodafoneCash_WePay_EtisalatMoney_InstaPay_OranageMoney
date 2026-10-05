// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/router/app_routes.dart';
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
        MahafezSpacing.md.verticalSpace,
        if (wallets.isEmpty)
          const _AddWalletEmptyCard()
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: MahafezSpacing.md,
              children: wallets.map((wallet) {
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.walletDetailsPath(wallet.id)),
                  child: WalletCard(
                    provider: wallet.provider,
                    phoneNumber: wallet.phoneNumber,
                    balance: wallet.currentBalance,
                  ),
                );
              }).toList(),
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
        padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(15),
          borderRadius: BorderRadius.circular(28.responsiveRadius),
          border: Border.all(
            color: theme.colorScheme.primary.withAlpha(40),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(40),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(50),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: theme.colorScheme.primary,
                size: 28.responsiveRadius,
              ),
            ),
            MahafezSpacing.md.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.addWallet.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 10.responsiveFont,
                    ),
                  ),
                  MahafezSpacing.xxs.verticalSpace,
                  Text(
                    l10n.createWalletEmptyTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
