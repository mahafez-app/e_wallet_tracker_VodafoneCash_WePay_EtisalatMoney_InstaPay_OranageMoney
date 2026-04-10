import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../theme/app_color_extension.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.sentAmount,
    required this.receivedAmount,
    required this.label,
    this.subtitle,
    this.icon,
  });

  final double balance;
  final double sentAmount;
  final double receivedAmount;
  final String label;
  final Widget? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.xl),
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
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.statsOnGradient,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: colors.statsOnGradient,
                ),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          _BalanceDisplay(amount: balance),
          if (subtitle != null) ...[
            AppSpacing.xs.verticalSpace,
            subtitle!,
          ],
          AppSpacing.lg.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  title: s.totalOut,
                  amount: '- ${sentAmount.toStringAsFixed(0)}',
                  amountColor: colors.statsSentColor,
                ),
              ),
              AppSpacing.lg.horizontalSpace,
              Expanded(
                child: _StatBox(
                  title: s.totalIn,
                  amount: '+ ${receivedAmount.toStringAsFixed(0)}',
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
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount.toStringAsFixed(2),
          style: theme.textTheme.displaySmall?.copyWith(
            color: colors.statsOnGradient,
            fontSize: 36.responsiveFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSpacing.xs.horizontalSpace,
        Padding(
          padding: AppResponsive.onlyPadding(bottom: 6),
          child: Text(
            s.currency,
            style: theme.textTheme.titleMedium?.copyWith(
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
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.statsOnGradient.withAlpha(25), // 0.1
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.statsOnGradient,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            amount,
            style: theme.textTheme.titleSmall?.copyWith(
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
