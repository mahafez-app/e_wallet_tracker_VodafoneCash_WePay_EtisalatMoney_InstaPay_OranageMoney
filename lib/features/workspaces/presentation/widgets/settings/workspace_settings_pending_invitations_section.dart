// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

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
        MahafezSpacing.md.verticalSpace,
        if (invitations.isEmpty)
          WorkspaceSettingsEmptyStateCard(
            message: context.l10n.workspaceSettingsPendingInvitationsEmpty,
          )
        else
          Column(
            children: invitations
                .map(
                  (invitation) => Padding(
                    padding: MahafezResponsive.onlyPadding(bottom: MahafezSpacing.md),
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
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MahafezSpacing.lg.responsiveRadius),
      ),
      child: Row(
        children: [
          Container(
            width: MahafezSpacing.xl.responsiveRadius,
            height: MahafezSpacing.xl.responsiveRadius,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withAlpha(51),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.alternate_email_rounded,
              color: theme.colorScheme.tertiary,
              size: MahafezSpacing.lg.responsiveRadius,
            ),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    invitation.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MahafezSpacing.xs.responsiveRadius,
                      height: MahafezSpacing.xs.responsiveRadius,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    MahafezSpacing.xs.horizontalSpace,
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
          MahafezSpacing.md.horizontalSpace,
          TextButton(
            onPressed: isCancelling ? null : onCancel,
            child: isCancelling
                ? SizedBox.square(
                    dimension: MahafezSpacing.lg.responsiveWidth,
                    child: CircularProgressIndicator(
                      strokeWidth: MahafezSpacing.xxs.responsiveWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.error,
                      ),
                    ),
                  )
                : Text(
                    context.l10n.workspaceSettingsCancelInvitationAction,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
