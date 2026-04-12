// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/workspace_entity.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

class HomeWorkspaceCard extends StatelessWidget {
  const HomeWorkspaceCard({super.key, required this.workspace});

  final WorkspaceEntity workspace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: AppResponsive.allPadding(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          border: Border.all(color: colors.cardBorder),
          borderRadius: BorderRadius.circular(16.responsiveRadius),
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _WorkspaceHeader(
                  name: workspace.name,
                  walletsCount: workspace.walletsCount,
                ),
                _WorkspaceLastActivity(
                  latestActivityAt: workspace.latestActivityAt,
                ),
              ],
            ),
            AppSpacing.lg.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _WorkspaceStat(
                    title: l10n.totalIn,
                    amount: workspace.totalReceived.toCurrencyText(
                      context,
                      decimalDigits: 0,
                    ),
                    amountColor: colorScheme.secondary,
                  ),
                ),
                AppSpacing.md.horizontalSpace,
                Expanded(
                  child: _WorkspaceStat(
                    title: l10n.totalOut,
                    amount: workspace.totalSent.toCurrencyText(
                      context,
                      decimalDigits: 0,
                    ),
                    amountColor: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({
    super.key,
    required this.name,
    required this.walletsCount,
  });

  final String name;
  final int walletsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final l10n = context.l10n;

    return Row(
      children: [
        Container(
          width: 40.responsiveRadius,
          height: 40.responsiveRadius,
          decoration: BoxDecoration(
            color: colors.workspaceIconBackground,
            borderRadius: BorderRadius.circular(12.responsiveRadius),
          ),
          child: Icon(Icons.storefront, color: colors.workspaceIconForeground),
        ),
        AppSpacing.md.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              l10n.activeWalletsCount(walletsCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkspaceLastActivity extends StatelessWidget {
  const _WorkspaceLastActivity({super.key, required this.latestActivityAt});

  final DateTime? latestActivityAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final timeText = latestActivityAt?.toTimeAgo(context) ?? l10n.justNow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l10n.lastActivity,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          timeText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WorkspaceStat extends StatelessWidget {
  const _WorkspaceStat({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  final String title;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(127),
        borderRadius: BorderRadius.circular(12.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
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
