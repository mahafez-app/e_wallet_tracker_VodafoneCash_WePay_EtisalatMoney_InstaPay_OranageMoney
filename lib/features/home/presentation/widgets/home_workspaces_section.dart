import 'package:flutter/material.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../../generated/l10n.dart';

class HomeWorkspacesSection extends StatelessWidget {
  const HomeWorkspacesSection({super.key, required this.workspaces});

  final List<WorkspaceEntity> workspaces;

  @override
  Widget build(BuildContext context) {
    if (workspaces.isEmpty) return const SizedBox.shrink();

    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.homeWorkspaces,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
          ],
        ),
        SizedBox(height: AppSpacing.md.responsiveHeight),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workspaces.length,
          separatorBuilder: (_, _) =>
              SizedBox(height: AppSpacing.md.responsiveHeight),
          itemBuilder: (context, index) {
            return _WorkspaceCard(workspace: workspaces[index]);
          },
        ),
      ],
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({required this.workspace});

  final WorkspaceEntity workspace;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: AppResponsive.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.workspaceCardBorder),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 2,
            offset: Offset(0, 1),
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
          SizedBox(height: AppSpacing.lg.responsiveHeight),
          Row(
            children: [
              Expanded(
                child: _WorkspaceStat(
                  title: s.homeTotalIn,
                  amount:
                      '${workspace.totalReceived.toStringAsFixed(0)} ${s.homeCurrency}',
                  amountColor: AppColors.secondary,
                ),
              ),
              SizedBox(width: AppSpacing.md.responsiveWidth),
              Expanded(
                child: _WorkspaceStat(
                  title: s.homeTotalOut,
                  amount:
                      '${workspace.totalSent.toStringAsFixed(0)} ${s.homeCurrency}',
                  amountColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({required this.name, required this.walletsCount});

  final String name;
  final int walletsCount;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Container(
          width: 40.responsiveRadius,
          height: 40.responsiveRadius,
          decoration: BoxDecoration(
            color: AppColors.workspaceIconBg,
            borderRadius: BorderRadius.circular(12.responsiveRadius),
          ),
          child: const Icon(
            Icons.storefront,
            color: AppColors.onSecondaryContainer,
          ),
        ),
        SizedBox(width: AppSpacing.md.responsiveWidth),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              s.homeActiveWallets(walletsCount),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkspaceLastActivity extends StatelessWidget {
  const _WorkspaceLastActivity({required this.latestActivityAt});

  final DateTime? latestActivityAt;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final timeStr = latestActivityAt?.toTimeAgo(context) ?? s.homeJustNow;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          s.homeLastActivity,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
        ),
        Text(
          timeStr,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WorkspaceStat extends StatelessWidget {
  const _WorkspaceStat({
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
        color: AppColors.signInFieldBg, // F0F3FF
        borderRadius: BorderRadius.circular(12.responsiveRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
          ),
          SizedBox(height: AppSpacing.xs.responsiveHeight),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
