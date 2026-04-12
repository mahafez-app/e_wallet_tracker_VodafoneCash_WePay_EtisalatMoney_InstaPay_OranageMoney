// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../providers/workspace_settings_state.dart';
import 'workspace_settings_empty_state_card.dart';
import 'workspace_settings_section_title.dart';

class WorkspaceSettingsPendingInvitationsSection extends StatelessWidget {
  const WorkspaceSettingsPendingInvitationsSection({
    super.key,
    required this.invitations,
    required this.cancellingInvitationId,
    required this.action,
    required this.onCancelInvitation,
  });

  final List<WorkspacePendingInvitationEntity> invitations;
  final String? cancellingInvitationId;
  final WorkspaceSettingsAction action;
  final ValueChanged<WorkspacePendingInvitationEntity> onCancelInvitation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkspaceSettingsSectionTitle(
          title: context.l10n.workspaceSettingsPendingInvitationsSection,
        ),
        AppSpacing.md.verticalSpace,
        if (invitations.isEmpty)
          WorkspaceSettingsEmptyStateCard(
            message: context.l10n.workspaceSettingsPendingInvitationsEmpty,
          )
        else
          Column(
            children: invitations
                .map(
                  (invitation) => Padding(
                    padding: AppResponsive.onlyPadding(bottom: AppSpacing.md),
                    child: _WorkspacePendingInvitationTile(
                      invitation: invitation,
                      isCancelling:
                          action ==
                              WorkspaceSettingsAction.cancellingInvitation &&
                          cancellingInvitationId == invitation.id,
                      onCancel: () => onCancelInvitation(invitation),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _WorkspacePendingInvitationTile extends StatelessWidget {
  const _WorkspacePendingInvitationTile({
    required this.invitation,
    required this.isCancelling,
    required this.onCancel,
  });

  final WorkspacePendingInvitationEntity invitation;
  final bool isCancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.lg.responsiveRadius),
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xl.responsiveRadius,
            height: AppSpacing.xl.responsiveRadius,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withAlpha(51),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.alternate_email_rounded,
              color: theme.colorScheme.tertiary,
              size: AppSpacing.lg.responsiveRadius,
            ),
          ),
          AppSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.xs.responsiveRadius,
                      height: AppSpacing.xs.responsiveRadius,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.xs.horizontalSpace,
                    Text(
                      context.l10n.invitationsPendingStatus,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: isCancelling ? null : onCancel,
            child: isCancelling
                ? SizedBox.square(
                    dimension: AppSpacing.lg.responsiveWidth,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSpacing.xxs.responsiveWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.error,
                      ),
                    ),
                  )
                : Text(
                    context.l10n.workspaceSettingsCancelInvitationAction,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
