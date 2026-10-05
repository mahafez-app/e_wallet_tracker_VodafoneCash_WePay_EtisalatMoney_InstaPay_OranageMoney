// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/router/app_routes.dart';
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
        MahafezSpacing.md.verticalSpace,
        if (workspaces.isEmpty)
          const _AddWorkspaceEmptyCard()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workspaces.length,
            separatorBuilder: (_, _) => MahafezSpacing.md.verticalSpace,
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
        padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withAlpha(15),
          borderRadius: BorderRadius.circular(28.responsiveRadius),
          border: Border.all(
            color: theme.colorScheme.secondary.withAlpha(40),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withAlpha(40),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withAlpha(50),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.corporate_fare_rounded,
                color: theme.colorScheme.secondary,
                size: 28.responsiveRadius,
              ),
            ),
            MahafezSpacing.md.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.addWorkspace.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 10.responsiveFont,
                    ),
                  ),
                  MahafezSpacing.xxs.verticalSpace,
                  Text(
                    l10n.createWorkspaceEmptyTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
