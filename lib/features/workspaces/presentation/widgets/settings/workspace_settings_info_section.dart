// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
        MahafezSpacing.md.verticalSpace,
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
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(MahafezSpacing.lg.responsiveRadius),
        onTap: onTap,
        child: Container(
          padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
          decoration: BoxDecoration(
            color: context.mahafezColors.cardBackground,
            borderRadius: BorderRadius.circular(MahafezSpacing.lg.responsiveRadius),
            boxShadow: [
              BoxShadow(
                color: colors.cardShadow,
                blurRadius: MahafezSpacing.md.responsiveRadius,
                offset: Offset(0, MahafezSpacing.xs.responsiveHeight),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: MahafezSpacing.xxxl.responsiveRadius,
                height: MahafezSpacing.xxxl.responsiveRadius,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(
                    MahafezSpacing.md.responsiveRadius,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.storefront_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              MahafezSpacing.lg.horizontalSpace,
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
                  size: MahafezSpacing.xl.responsiveRadius,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
