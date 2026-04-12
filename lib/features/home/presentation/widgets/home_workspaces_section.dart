// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import 'home_section_header.dart';
import 'workspaces/home_workspace_card.dart';

class HomeWorkspacesSection extends StatelessWidget {
  const HomeWorkspacesSection({super.key, required this.workspaces});

  final List<WorkspaceEntity> workspaces;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: l10n.workspaces,
          actionLabel: l10n.addWorkspace,
          icon: Icons.add_business_outlined,
          onPressed: () => context.push(AppRoutes.addWorkspace),
        ),
        AppSpacing.md.verticalSpace,
        if (workspaces.isEmpty)
          const _AddWorkspaceEmptyCard()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workspaces.length,
            separatorBuilder: (_, _) => AppSpacing.md.verticalSpace,
            itemBuilder: (context, index) =>
                HomeWorkspaceCard(workspace: workspaces[index]),
          ),
      ],
    );
  }
}

class _AddWorkspaceEmptyCard extends StatelessWidget {
  const _AddWorkspaceEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.addWorkspace),
      child: Container(
        width: double.infinity,
        padding: AppResponsive.allPadding(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
          borderRadius: BorderRadius.circular(24.responsiveRadius),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.storefront_outlined,
              color: theme.colorScheme.primary,
              size: 28.responsiveRadius,
            ),
            AppSpacing.md.verticalSpace,
            Text(
              l10n.createWorkspaceEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.xs.verticalSpace,
            Text(
              l10n.createWorkspaceEmptyDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
