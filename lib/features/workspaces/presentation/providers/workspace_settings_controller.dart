import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/domain/usecases/get_workspace_pending_invitations_usecase.dart';
import '../../../invitations/providers/invitations_providers.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../../domain/entities/workspace_member_entity.dart';
import '../../domain/usecases/delete_workspace_usecase.dart';
import '../../domain/usecases/get_workspace_details_usecase.dart';
import '../../domain/usecases/remove_workspace_member_usecase.dart';
import '../../domain/usecases/update_workspace_name_usecase.dart';
import '../../providers/workspaces_providers.dart';

const _workspaceSettingsUnsetValue = Object();

enum WorkspaceSettingsAction {
  idle,
  updatingName,
  removingMember,
  cancellingInvitation,
  deletingWorkspace,
}

enum WorkspaceSettingsFeedbackType {
  workspaceNameUpdated,
  memberRemoved,
  invitationCancelled,
  workspaceDeleted,
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

  bool isRemovingMember(String memberUid) {
    return action == WorkspaceSettingsAction.removingMember &&
        activeTargetId == memberUid;
  }

  bool isCancellingInvitation(String invitationId) {
    return action == WorkspaceSettingsAction.cancellingInvitation &&
        activeTargetId == invitationId;
  }

  bool get isDeletingWorkspace =>
      action == WorkspaceSettingsAction.deletingWorkspace;

  WorkspaceSettingsState copyWith({
    WorkspaceDetailsEntity? details,
    List<WorkspacePendingInvitationEntity>? pendingInvitations,
    WorkspaceSettingsAction? action,
    Object? activeTargetId = _workspaceSettingsUnsetValue,
    Object? feedback = _workspaceSettingsUnsetValue,
  }) {
    return WorkspaceSettingsState(
      details: details ?? this.details,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      action: action ?? this.action,
      activeTargetId: identical(activeTargetId, _workspaceSettingsUnsetValue)
          ? this.activeTargetId
          : activeTargetId as String?,
      feedback: identical(feedback, _workspaceSettingsUnsetValue)
          ? this.feedback
          : feedback as WorkspaceSettingsFeedback?,
    );
  }
}

final workspaceSettingsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WorkspaceSettingsController, WorkspaceSettingsState, String>(
      WorkspaceSettingsController.new,
    );

class WorkspaceSettingsController
    extends AsyncNotifier<WorkspaceSettingsState> {
  WorkspaceSettingsController(this._workspaceId);

  final String _workspaceId;

  @override
  Future<WorkspaceSettingsState> build() {
    return _loadState();
  }

  void clearFeedback() {
    final currentState = state.asData?.value;
    if (currentState == null || currentState.feedback == null) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(feedback: null));
  }

  void updateWorkspaceName(String name) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty ||
        trimmedName == currentState.details.workspace.name) {
      return;
    }

    _setLoading(WorkspaceSettingsAction.updatingName);
    unawaited(_updateWorkspaceName(trimmedName));
  }

  void removeMember(WorkspaceMemberEntity member) {
    _setLoading(WorkspaceSettingsAction.removingMember, targetId: member.uid);
    unawaited(_removeMember(member));
  }

  void cancelInvitation(WorkspacePendingInvitationEntity invitation) {
    _setLoading(
      WorkspaceSettingsAction.cancellingInvitation,
      targetId: invitation.id,
    );
    unawaited(_cancelInvitation(invitation));
  }

  void deleteWorkspace() {
    _setLoading(WorkspaceSettingsAction.deletingWorkspace);
    unawaited(_deleteWorkspace());
  }

  Future<WorkspaceSettingsState> _loadState() async {
    final detailsResult = await ref.read(getWorkspaceDetailsUseCaseProvider)(
      GetWorkspaceDetailsParams(workspaceId: _workspaceId),
    );
    final details = _getOrThrow(detailsResult);

    final invitationsResult = await ref.read(
      getWorkspacePendingInvitationsUseCaseProvider,
    )(GetWorkspacePendingInvitationsParams(workspaceId: _workspaceId));
    final invitations = _getOrThrow(invitationsResult);

    return WorkspaceSettingsState(
      details: details,
      pendingInvitations: invitations,
      action: WorkspaceSettingsAction.idle,
      activeTargetId: null,
      feedback: null,
    );
  }

  T _getOrThrow<T>(Result<T> result) {
    return result.fold((failure) => throw failure, (data) => data);
  }

  void _setLoading(WorkspaceSettingsAction action, {String? targetId}) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        action: action,
        activeTargetId: targetId,
        feedback: null,
      ),
    );
  }

  Future<void> _updateWorkspaceName(String name) async {
    final result = await ref.read(updateWorkspaceNameUseCaseProvider)(
      UpdateWorkspaceNameParams(workspaceId: _workspaceId, name: name),
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(_setFailure, (workspace) {
      final currentState = state.asData?.value;
      if (currentState == null) {
        return;
      }

      state = AsyncValue.data(
        currentState.copyWith(
          details: currentState.details.copyWith(workspace: workspace),
          action: WorkspaceSettingsAction.idle,
          activeTargetId: null,
          feedback: const WorkspaceSettingsFeedback(
            type: WorkspaceSettingsFeedbackType.workspaceNameUpdated,
          ),
        ),
      );
    });
  }

  Future<void> _removeMember(WorkspaceMemberEntity member) async {
    final result = await ref.read(removeWorkspaceMemberUseCaseProvider)(
      RemoveWorkspaceMemberParams(
        workspaceId: _workspaceId,
        memberUid: member.uid,
      ),
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(_setFailure, (_) {
      final currentState = state.asData?.value;
      if (currentState == null) {
        return;
      }

      final members = currentState.details.members
          .where((item) => item.uid != member.uid)
          .toList();
      state = AsyncValue.data(
        currentState.copyWith(
          details: currentState.details.copyWith(members: members),
          action: WorkspaceSettingsAction.idle,
          activeTargetId: null,
          feedback: WorkspaceSettingsFeedback(
            type: WorkspaceSettingsFeedbackType.memberRemoved,
            targetId: member.uid,
          ),
        ),
      );
    });
  }

  Future<void> _cancelInvitation(
    WorkspacePendingInvitationEntity invitation,
  ) async {
    final result = await ref.read(cancelInvitationUseCaseProvider)(
      invitation.id,
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(_setFailure, (_) {
      final currentState = state.asData?.value;
      if (currentState == null) {
        return;
      }

      final invitations = currentState.pendingInvitations
          .where((item) => item.id != invitation.id)
          .toList();
      state = AsyncValue.data(
        currentState.copyWith(
          pendingInvitations: invitations,
          action: WorkspaceSettingsAction.idle,
          activeTargetId: null,
          feedback: WorkspaceSettingsFeedback(
            type: WorkspaceSettingsFeedbackType.invitationCancelled,
            targetId: invitation.id,
          ),
        ),
      );
    });
  }

  Future<void> _deleteWorkspace() async {
    final result = await ref.read(deleteWorkspaceUseCaseProvider)(
      DeleteWorkspaceParams(workspaceId: _workspaceId),
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(_setFailure, (_) {
      final currentState = state.asData?.value;
      if (currentState == null) {
        return;
      }

      state = AsyncValue.data(
        currentState.copyWith(
          action: WorkspaceSettingsAction.idle,
          activeTargetId: null,
          feedback: const WorkspaceSettingsFeedback(
            type: WorkspaceSettingsFeedbackType.workspaceDeleted,
          ),
        ),
      );
    });
  }

  void _setFailure(Failure failure) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      state = AsyncValue.error(failure, StackTrace.current);
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        action: WorkspaceSettingsAction.idle,
        activeTargetId: null,
        feedback: WorkspaceSettingsFeedback(
          type: WorkspaceSettingsFeedbackType.failure,
          failure: failure,
        ),
      ),
    );
  }
}
