import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_tracker/core/domain/entities/wallet_entity.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_wallet_card.dart';
import '../../../../generated/l10n.dart';

class HomeWalletsSection extends StatelessWidget {
  const HomeWalletsSection({super.key, required this.wallets});

  final List<WalletEntity> wallets;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.yourWallets,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.md.verticalSpace,
        SizedBox(
          height: 151.responsiveHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length + 1,
            separatorBuilder: (_, _) => AppSpacing.md.horizontalSpace,
            itemBuilder: (context, index) {
              if (index == wallets.length) return const _AddWalletCard();
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
    final theme = Theme.of(context);
    final colors = context.appColors;
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.addWallet),
      child: Container(
        width: 192.responsiveWidth,
        padding: AppResponsive.symmetricPadding(horizontal: 20, vertical: 33),
        decoration: BoxDecoration(
          color: colors.addWalletBackground,
          border: Border.all(
            width: 2.responsiveWidth,
            color: colors.addWalletBorderColor,
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
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: primary),
            ),
            AppSpacing.md.verticalSpace,
            Text(
              s.addWallet,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
