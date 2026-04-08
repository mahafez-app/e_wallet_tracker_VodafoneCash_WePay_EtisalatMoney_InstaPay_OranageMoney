import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_wallet_card.dart';
import '../../../../generated/l10n.dart';
import 'package:wallet_tracker/core/domain/entities/wallet_entity.dart';

class HomeWalletsSection extends StatelessWidget {
  const HomeWalletsSection({super.key, required this.wallets});

  final List<WalletEntity> wallets;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.homeYourWallets,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                s.homeViewAll,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.responsiveHeight),
        SizedBox(
          height: 151.responsiveHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length + 1, // Add Wallet Button
            separatorBuilder: (_, _) =>
                SizedBox(width: AppSpacing.md.responsiveWidth),
            itemBuilder: (context, index) {
              if (index == wallets.length) {
                return const _AddWalletCard();
              }
              return AppWalletCard(
                provider: wallets[index].provider,
                phoneNumber: wallets[index].phoneNumber,
                balance: wallets[index].currentBalance,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddWalletCard extends StatelessWidget {
  const _AddWalletCard();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      width: 192.responsiveWidth,
      padding: EdgeInsets.symmetric(
        horizontal: 20.responsiveWidth,
        vertical: 33.responsiveHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.addWalletBg,
        border: Border.all(
          width: 2.responsiveWidth,
          color: AppColors.addWalletBorder,
        ),
        borderRadius: BorderRadius.circular(24.responsiveRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.responsiveRadius,
            height: 48.responsiveRadius,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.primary),
          ),
          SizedBox(height: AppSpacing.md.responsiveHeight),
          Text(
            s.homeAddWallet,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
