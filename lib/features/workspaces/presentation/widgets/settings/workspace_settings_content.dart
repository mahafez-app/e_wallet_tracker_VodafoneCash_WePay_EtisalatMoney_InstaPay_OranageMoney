import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/wallet_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../domain/entities/workspace_member_entity.dart';
import '../../providers/workspace_settings_state.dart';
import 'workspace_settings_access_section.dart';
import 'workspace_settings_danger_zone_section.dart';
import 'workspace_settings_info_section.dart';
import 'workspace_settings_members_section.dart';
import 'workspace_settings_pending_invitations_section.dart';
import 'workspace_settings_wallets_section.dart';

class WorkspaceSettingsContent extends StatelessWidget {
  const WorkspaceSettingsContent({
    super.key,
    required this.state,
    required this.currentUserId,
    required this.onEditWorkspaceName,
    required this.onInviteMember,
    required this.onRemoveMember,
    required this.onRemoveWallet,
    required this.onCancelInvitation,
    required this.onLeaveWorkspace,
    required this.onDeleteWorkspace,
  });

  final WorkspaceSettingsState state;
  final String? currentUserId;
  final VoidCallback onEditWorkspaceName;
  final VoidCallback onInviteMember;
  final ValueChanged<WorkspaceMemberEntity> onRemoveMember;
  final ValueChanged<WalletEntity> onRemoveWallet;
  final ValueChanged<WorkspacePendingInvitationEntity> onCancelInvitation;
  final VoidCallback onLeaveWorkspace;
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
          AppSpacing.lg.verticalSpace,
          WorkspaceSettingsMembersSection(
            members: state.details.members,
            canManageWorkspace: _canManageWorkspace,
            removingMemberId: state.activeTargetId,
            action: state.action,
            onInviteMember: onInviteMember,
            onRemoveMember: onRemoveMember,
          ),
          AppSpacing.lg.verticalSpace,
          WorkspaceSettingsWalletsSection(
            wallets: state.details.wallets,
            memberNamesByUid: {
              for (final member in state.details.members)
                member.uid: member.displayName,
            },
            currentUserId: currentUserId,
            canManageAllWallets: _canManageWorkspace,
            removingWalletId:
                state.action == WorkspaceSettingsAction.removingWallet
                ? state.activeTargetId
                : null,
            onRemoveWallet: onRemoveWallet,
          ),
          if (_canManageWorkspace) ...[
            AppSpacing.lg.verticalSpace,
            WorkspaceSettingsPendingInvitationsSection(
              invitations: state.pendingInvitations,
              cancellingInvitationId: state.activeTargetId,
              action: state.action,
              onCancelInvitation: onCancelInvitation,
            ),
          ],
          if (_canManageWorkspace) ...[
            AppSpacing.lg.verticalSpace,
            WorkspaceSettingsDangerZoneSection(
              isDeleting: state.isDeletingWorkspace,
              onDeleteWorkspace: onDeleteWorkspace,
            ),
          ] else ...[
            AppSpacing.lg.verticalSpace,
            WorkspaceSettingsAccessSection(
              isLeaving: state.isLeavingWorkspace,
              onLeaveWorkspace: onLeaveWorkspace,
            ),
          ],
        ],
      ),
    );
  }
}
