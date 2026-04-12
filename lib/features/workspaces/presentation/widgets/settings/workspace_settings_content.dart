import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../domain/entities/workspace_member_entity.dart';
import '../../providers/workspace_settings_controller.dart';
import 'workspace_settings_danger_zone_section.dart';
import 'workspace_settings_info_section.dart';
import 'workspace_settings_members_section.dart';
import 'workspace_settings_pending_invitations_section.dart';

class WorkspaceSettingsContent extends StatelessWidget {
  const WorkspaceSettingsContent({
    super.key,
    required this.state,
    required this.currentUserId,
    required this.onEditWorkspaceName,
    required this.onInviteMember,
    required this.onRemoveMember,
    required this.onCancelInvitation,
    required this.onDeleteWorkspace,
  });

  final WorkspaceSettingsState state;
  final String? currentUserId;
  final VoidCallback onEditWorkspaceName;
  final VoidCallback onInviteMember;
  final ValueChanged<WorkspaceMemberEntity> onRemoveMember;
  final ValueChanged<WorkspacePendingInvitationEntity> onCancelInvitation;
  final VoidCallback onDeleteWorkspace;

  bool get _canManageWorkspace =>
      currentUserId == state.details.workspace.ownerUid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppResponsive.onlyPadding(
        start: AppSpacing.lg,
        top: AppSpacing.lg,
        end: AppSpacing.lg,
        bottom: AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkspaceSettingsInfoSection(
            workspaceName: state.details.workspace.name,
            canEdit: _canManageWorkspace,
            onEditTap: _canManageWorkspace ? onEditWorkspaceName : null,
          ),
          AppSpacing.xl.verticalSpace,
          WorkspaceSettingsMembersSection(
            members: state.details.members,
            canManageWorkspace: _canManageWorkspace,
            removingMemberId: state.activeTargetId,
            action: state.action,
            onInviteMember: onInviteMember,
            onRemoveMember: onRemoveMember,
          ),
          AppSpacing.xl.verticalSpace,
          WorkspaceSettingsPendingInvitationsSection(
            invitations: state.pendingInvitations,
            canManageWorkspace: _canManageWorkspace,
            cancellingInvitationId: state.activeTargetId,
            action: state.action,
            onCancelInvitation: onCancelInvitation,
          ),
          if (_canManageWorkspace) ...[
            AppSpacing.xl.verticalSpace,
            WorkspaceSettingsDangerZoneSection(
              isDeleting: state.isDeletingWorkspace,
              onDeleteWorkspace: onDeleteWorkspace,
            ),
          ],
        ],
      ),
    );
  }
}
