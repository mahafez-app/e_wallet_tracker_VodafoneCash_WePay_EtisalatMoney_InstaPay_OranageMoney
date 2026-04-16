import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/amount_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../domain/entities/report_entity.dart';

class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({super.key, required this.report});

  final ReportEntity report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MainBalanceCard(report: report),
        AppSpacing.xl.verticalSpace,
        Text(
          l10n.reports_performance_label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.md.verticalSpace,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md.responsiveHeight,
          crossAxisSpacing: AppSpacing.md.responsiveWidth,
          childAspectRatio: 1.4,
          children: [
            _MetricCard(
              title: l10n.totalIn,
              amount: '+ ${report.totalIncome.toLocalizedAmount(context)}',
              icon: Icons.arrow_downward,
              color: theme.colorScheme.secondary,
            ),
            _MetricCard(
              title: l10n.totalOut,
              amount: '- ${report.totalOutcome.toLocalizedAmount(context)}',
              icon: Icons.arrow_outward,
              color: theme.colorScheme.error,
            ),
            _MetricCard(
              title: l10n.reports_total_transactions,
              amount: report.transactionCount.toString(),
              icon: Icons.history_rounded,
              color: theme.colorScheme.primary,
            ),
            _MetricCard(
              title: l10n.reports_stat_average,
              amount: () {
                final avg = report.transactionCount > 0
                    ? (report.balanceChange / report.transactionCount)
                    : 0.0;
                return '${avg >= 0 ? '+ ' : '- '}${avg.abs().toLocalizedAmount(context)}';
              }(),
              icon: Icons.calculate_outlined,
              color: theme.colorScheme.tertiary,
            ),
          ],
        ),
      ],
    );
  }
}

class _MainBalanceCard extends StatelessWidget {
  const _MainBalanceCard({required this.report});

  final ReportEntity report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final colors = context.appColors;
    final isPositive = report.balanceChange >= 0;

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.statsGradientStart, colors.statsGradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.statsGradientStart.withAlpha(80),
            blurRadius: 25.responsiveRadius,
            offset: Offset(0, 12.responsiveHeight),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reports_balance_label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.statsOnGradient.withAlpha(200),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+ ' : '- '}${report.balanceChange.abs().toLocalizedAmount(context)}',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colors.statsOnGradient,
                  fontWeight: FontWeight.w900,
                  fontSize: 34.responsiveFont,
                  letterSpacing: -1.0,
                ),
              ),
              AppSpacing.xs.horizontalSpace,
              Padding(
                padding: AppResponsive.onlyPadding(bottom: 8),
                child: Text(
                  l10n.currency,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.statsOnGradient.withAlpha(180),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 15.responsiveRadius,
            offset: Offset(0, 6.responsiveHeight),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: AppResponsive.allPadding(4.responsiveRadius),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.responsiveRadius, color: color),
              ),
              AppSpacing.xs.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          FittedBox(
            child: Text(
              amount,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
