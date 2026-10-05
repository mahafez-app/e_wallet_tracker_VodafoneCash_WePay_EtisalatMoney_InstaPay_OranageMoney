import 'package:mahafez_core/mahafez_core.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../domain/entities/workspace_details_entity.dart';

const workspaceSettingsUnsetValue = Object();

enum WorkspaceSettingsAction {
  idle,
  updatingName,
  removingMember,
  cancellingInvitation,
  deletingWorkspace,
  removingWallet,
  leavingWorkspace,
}

enum WorkspaceSettingsFeedbackType {
  workspaceNameUpdated,
  memberRemoved,
  invitationCancelled,
  workspaceDeleted,
  walletRemoved,
  workspaceLeft,
  failure,
}

class WorkspaceSettingsFeedback {
  const WorkspaceSettingsFeedback({
    required this.type,
    this.failure,
    this.targetId,
  });

  final WorkspaceSettingsFeedbackType type;
  final Failure? failure;
  final String? targetId;
}

class WorkspaceSettingsState {
  const WorkspaceSettingsState({
    required this.details,
    required this.pendingInvitations,
    required this.action,
    required this.activeTargetId,
    required this.feedback,
  });

  final WorkspaceDetailsEntity details;
  final List<WorkspacePendingInvitationEntity> pendingInvitations;
  final WorkspaceSettingsAction action;
  final String? activeTargetId;
  final WorkspaceSettingsFeedback? feedback;

  bool get isUpdatingName => action == WorkspaceSettingsAction.updatingName;

  bool get isDeletingWorkspace =>
      action == WorkspaceSettingsAction.deletingWorkspace;

  bool get isLeavingWorkspace =>
      action == WorkspaceSettingsAction.leavingWorkspace;

  bool isRemovingMember(String memberUid) {
    return action == WorkspaceSettingsAction.removingMember &&
        activeTargetId == memberUid;
  }

  bool isCancellingInvitation(String invitationId) {
    return action == WorkspaceSettingsAction.cancellingInvitation &&
        activeTargetId == invitationId;
  }

  bool isRemovingWallet(String walletId) {
    return action == WorkspaceSettingsAction.removingWallet &&
        activeTargetId == walletId;
  }

  WorkspaceSettingsState copyWith({
    WorkspaceDetailsEntity? details,
    List<WorkspacePendingInvitationEntity>? pendingInvitations,
    WorkspaceSettingsAction? action,
    Object? activeTargetId = workspaceSettingsUnsetValue,
    Object? feedback = workspaceSettingsUnsetValue,
  }) {
    return WorkspaceSettingsState(
      details: details ?? this.details,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      action: action ?? this.action,
      activeTargetId: identical(activeTargetId, workspaceSettingsUnsetValue)
          ? this.activeTargetId
          : activeTargetId as String?,
      feedback: identical(feedback, workspaceSettingsUnsetValue)
          ? this.feedback
          : feedback as WorkspaceSettingsFeedback?,
    );
  }
}
