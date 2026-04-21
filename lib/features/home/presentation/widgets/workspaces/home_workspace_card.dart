// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/domain/entities/workspace_entity.dart';
import '../../../../../core/router/app_routes.dart';
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
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.workspaceDetailsPath(workspace.id)),
      child: Container(
        padding: AppResponsive.allPadding(AppSpacing.xl),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(28.responsiveRadius),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withAlpha(50),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withAlpha(8),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _WorkspaceHeader(
                    name: workspace.name,
                    walletsCount: workspace.walletsCount,
                  ),
                ),
                _WorkspaceLastActivity(
                  latestActivityAt: workspace.latestActivityAt,
                ),
              ],
            ),
            AppSpacing.xl.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: _WorkspaceStat(
                    title: l10n.totalIn,
                    amount: workspace.totalReceived.toCurrencyText(context),
                    icon: Icons.south_west_rounded,
                    color: colors.success,
                  ),
                ),
                AppSpacing.md.horizontalSpace,
                Expanded(
                  child: _WorkspaceStat(
                    title: l10n.totalOut,
                    amount: workspace.totalSent.toCurrencyText(context),
                    icon: Icons.north_east_rounded,
                    color: colors.danger,
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
          width: 48.responsiveRadius,
          height: 48.responsiveRadius,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.workspaceIconBackground,
                colors.workspaceIconBackground.withAlpha(180),
              ],
            ),
            borderRadius: BorderRadius.circular(16.responsiveRadius),
            boxShadow: [
              BoxShadow(
                color: colors.workspaceIconBackground.withAlpha(40),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.corporate_fare_rounded,
            color: colors.workspaceIconForeground,
            size: 24.responsiveRadius,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.xxs.verticalSpace,
              Text(
                l10n.activeWalletsCount(walletsCount),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
          l10n.lastActivity.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            fontSize: 9.responsiveFont,
          ),
        ),
        AppSpacing.xxs.verticalSpace,
        Text(
          timeText,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w900,
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

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppResponsive.allPadding(2.responsiveRadius),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 12.responsiveRadius, color: color),
              ),
              AppSpacing.xs.horizontalSpace,
              Expanded(
                child: FittedBox(
                  alignment: AlignmentDirectional.centerStart,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          FittedBox(
            child: Text(
              amount,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
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
