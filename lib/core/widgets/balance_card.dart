// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/date_extensions.dart';

import '../theme/app_color_extension.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/amount_extension.dart';
import '../utils/extensions/localization_extension.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.sentAmount,
    required this.receivedAmount,
    required this.label,
    this.subtitle,
    this.icon,
    this.statsResetDate,
    this.onReset,
  });

  final double balance;
  final double sentAmount;
  final double receivedAmount;
  final String label;
  final Widget? subtitle;
  final IconData? icon;
  final DateTime? statsResetDate;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              if (onReset != null)
                Material(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12.responsiveRadius),
                  child: InkWell(
                    onTap: onReset,
                    borderRadius: BorderRadius.circular(12.responsiveRadius),
                    child: Padding(
                      padding: AppResponsive.symmetricPadding(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restart_alt_rounded,
                            size: 16.responsiveRadius,
                            color: colors.statsOnGradient,
                          ),
                          AppSpacing.xs.horizontalSpace,
                          Text(
                            l10n.wallet_resetStatsAction,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.statsOnGradient,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.responsiveFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (icon != null)
                Icon(icon, color: colors.statsOnGradient),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          _BalanceDisplay(amount: balance),
          if (subtitle != null) ...[AppSpacing.xs.verticalSpace, subtitle!],
          if (statsResetDate != null) ...[
            AppSpacing.md.verticalSpace,
            _StatsPeriodLabel(date: statsResetDate!),
          ],
          AppSpacing.lg.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  title: l10n.totalOut,
                  amount: '- ${sentAmount.abs().toLocalizedAmount(context)}',
                  amountColor: colors.statsSentColor,
                  icon: Icons.arrow_outward,
                  iconColor: colors.statsSentColor,
                ),
              ),
              AppSpacing.lg.horizontalSpace,
              Expanded(
                child: _StatBox(
                  title: l10n.totalIn,
                  amount: '+ ${receivedAmount.abs().toLocalizedAmount(context)}',
                  amountColor: colors.statsReceivedColor,
                  icon: Icons.arrow_downward,
                  iconColor: colors.statsReceivedColor,
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
  const _BalanceDisplay({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount.toLocalizedAmount(context),
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
            l10n.currency,
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
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String amount;
  final Color amountColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(color: Colors.white.withAlpha(30), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppResponsive.allPadding(2.responsiveRadius),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.responsiveRadius, color: iconColor),
              ),
              AppSpacing.xs.horizontalSpace,
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.statsOnGradient.withAlpha(180),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          FittedBox(
            child: Text(
              amount,
              style: theme.textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsPeriodLabel extends StatelessWidget {
  const _StatsPeriodLabel({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.symmetricPadding(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(10.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            size: 12.responsiveRadius,
            color: colors.statsOnGradient.withAlpha(180),
          ),
          AppSpacing.xs.horizontalSpace,
          Text(
            l10n.wallet_statsFrom(date.toFormattedDate(context)),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.statsOnGradient.withAlpha(200),
              fontWeight: FontWeight.w600,
              fontSize: 10.responsiveFont,
            ),
          ),
        ],
      ),
    );
  }
}
