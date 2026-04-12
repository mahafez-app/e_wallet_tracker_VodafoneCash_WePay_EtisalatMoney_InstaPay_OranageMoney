// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

class CreateWorkspacePreviewCard extends StatelessWidget {
  const CreateWorkspacePreviewCard({
    super.key,
    required this.workspaceName,
    required this.ownerName,
  });

  final String workspaceName;
  final String ownerName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final previewName = workspaceName.trim().isEmpty
        ? l10n.createWorkspacePreviewFallback
        : workspaceName.trim();

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        gradient: LinearGradient(
          begin: const Alignment(0.18, -0.18),
          end: const Alignment(0.82, 1.18),
          colors: [
            colorScheme.primaryFixed.withAlpha(200),
            colorScheme.primary,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_outlined, color: colorScheme.onPrimary),
              AppSpacing.sm.horizontalSpace,
              Expanded(
                child: Text(
                  l10n.createWorkspacePreviewLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.lg.verticalSpace,
          Text(
            previewName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            l10n.createWorkspacePreviewDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withAlpha(217),
            ),
          ),
          AppSpacing.lg.verticalSpace,
          Wrap(
            spacing: AppSpacing.sm.responsiveWidth,
            runSpacing: AppSpacing.sm.responsiveHeight,
            children: [
              _PreviewChip(
                label: l10n.workspaceMembersCount(1),
                icon: Icons.group_outlined,
              ),
              _PreviewChip(
                label: ownerName.isEmpty
                    ? l10n.workspaceOwner
                    : '${l10n.workspaceOwner}: $ownerName',
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: AppResponsive.symmetricPadding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withAlpha(31),
        borderRadius: BorderRadius.circular(999.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.responsiveRadius, color: colorScheme.onPrimary),
          AppSpacing.xs.horizontalSpace,
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
