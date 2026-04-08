import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_extension.dart';
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
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: AppResponsive.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        gradient: LinearGradient(
          begin: const Alignment(0.18, -0.18),
          end: const Alignment(0.82, 1.18),
          colors: [colors.statsGradientStart, colors.statsGradientEnd],
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
                  color: colors.statsOnGradient,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: colors.statsOnGradient,
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
                  amountColor: colors.statsSentColor,
                ),
              ),
              SizedBox(width: AppSpacing.lg.responsiveWidth),
              Expanded(
                child: _StatBox(
                  title: s.homeTotalIn,
                  amount: '+ ${totalReceived.toStringAsFixed(0)}',
                  amountColor: colors.statsReceivedColor,
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
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount.toStringAsFixed(2),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colors.statsOnGradient,
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
              color: colors.statsOnGradient,
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
    final colors = context.appColors;
    return Container(
      padding: AppResponsive.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.statsOnGradient.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.statsOnGradient,
            ),
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
