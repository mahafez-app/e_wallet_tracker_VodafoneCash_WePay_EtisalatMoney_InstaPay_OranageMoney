import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';

class HomeGlobalStatsWidget extends StatelessWidget {
  const HomeGlobalStatsWidget({
    super.key,
    required this.totalBalance,
    required this.totalSent,
    required this.totalReceived,
  });

  final double totalBalance;
  final double totalSent;
  final double totalReceived;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      width: double.infinity,
      padding: AppResponsive.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        gradient: LinearGradient(
          begin: const Alignment(0.18, -0.18),
          end: const Alignment(0.82, 1.18),
          colors: [AppColors.primary, AppColors.onPrimaryFixedVariant],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.homeTotalWallets,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primaryContainer,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.responsiveHeight),
          _BalanceDisplay(amount: totalBalance),
          SizedBox(height: AppSpacing.lg.responsiveHeight),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  title: s.homeTotalOut,
                  amount: '- ${totalSent.toStringAsFixed(0)}',
                  amountColor: AppColors.errorContainer,
                ),
              ),
              SizedBox(width: AppSpacing.lg.responsiveWidth),
              Expanded(
                child: _StatBox(
                  title: s.homeTotalIn,
                  amount: '+ ${totalReceived.toStringAsFixed(0)}',
                  amountColor:
                      AppColors.secondaryFixedDim, // 0xFF9DF4C8 alternative
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceDisplay extends StatelessWidget {
  const _BalanceDisplay({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount.toStringAsFixed(2),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.primaryContainer,
            fontSize: 36.responsiveFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: AppSpacing.xs.responsiveWidth),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            s.homeCurrency,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  final String title;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppResponsive.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.primaryContainer),
          ),
          SizedBox(height: AppSpacing.xs.responsiveHeight),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontSize: 14.responsiveFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
