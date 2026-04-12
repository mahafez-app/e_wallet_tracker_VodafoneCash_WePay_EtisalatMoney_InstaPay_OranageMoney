// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import 'workspace_settings_section_title.dart';

class WorkspaceSettingsDangerZoneSection extends StatelessWidget {
  const WorkspaceSettingsDangerZoneSection({
    super.key,
    required this.isDeleting,
    required this.onDeleteWorkspace,
  });

  final bool isDeleting;
  final VoidCallback onDeleteWorkspace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkspaceSettingsSectionTitle(
          title: context.l10n.workspaceSettingsDangerZone,
          isDanger: true,
        ),
        AppSpacing.md.verticalSpace,
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
            onTap: isDeleting ? null : onDeleteWorkspace,
            child: Container(
              padding: AppResponsive.allPadding(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withAlpha(25),
                borderRadius: BorderRadius.circular(
                  AppSpacing.lg.responsiveRadius,
                ),
                border: Border.all(
                  color: theme.colorScheme.error.withAlpha(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.responsiveRadius,
                    height: 40.responsiveRadius,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.md.responsiveRadius,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  AppSpacing.lg.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.workspaceSettingsDeleteWorkspaceAction,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          context
                              .l10n
                              .workspaceSettingsDeleteWorkspaceDescription,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDeleting)
                    SizedBox.square(
                      dimension: AppSpacing.lg.responsiveWidth,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSpacing.xxs.responsiveWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.error,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_left_rounded,
                      color: theme.colorScheme.error.withAlpha(100),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
