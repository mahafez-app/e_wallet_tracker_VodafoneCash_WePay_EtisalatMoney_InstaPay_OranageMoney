// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import 'workspace_settings_section_title.dart';

class WorkspaceSettingsInfoSection extends StatelessWidget {
  const WorkspaceSettingsInfoSection({
    super.key,
    required this.workspaceName,
    required this.canEdit,
    this.onEditTap,
  });

  final String workspaceName;
  final bool canEdit;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkspaceSettingsSectionTitle(
          title: context.l10n.workspaceSettingsInfoSection,
        ),
        AppSpacing.md.verticalSpace,
        _WorkspaceInfoCard(
          name: workspaceName,
          canEdit: canEdit,
          onTap: onEditTap,
        ),
      ],
    );
  }
}

class _WorkspaceInfoCard extends StatelessWidget {
  const _WorkspaceInfoCard({
    required this.name,
    required this.canEdit,
    required this.onTap,
  });

  final String name;
  final bool canEdit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
        onTap: onTap,
        child: Container(
          padding: AppResponsive.allPadding(AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.appColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: AppSpacing.md.responsiveRadius,
                offset: Offset(0, AppSpacing.xs.responsiveHeight),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xxxl.responsiveRadius,
                height: AppSpacing.xxxl.responsiveRadius,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.md.responsiveRadius,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.storefront_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              AppSpacing.lg.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.workspaceNameLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (canEdit) ...[
                Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.outline,
                  size: AppSpacing.xl.responsiveRadius,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
