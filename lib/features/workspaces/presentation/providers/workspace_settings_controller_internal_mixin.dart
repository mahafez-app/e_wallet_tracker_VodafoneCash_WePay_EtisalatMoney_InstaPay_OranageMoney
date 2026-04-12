import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/domain/usecases/get_workspace_pending_invitations_usecase.dart';
import '../../../invitations/providers/invitations_providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/get_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';
import 'workspace_settings_state.dart';

mixin WorkspaceSettingsControllerInternalMixin
    on AsyncNotifier<WorkspaceSettingsState> {
  String get workspaceId;

  Future<WorkspaceSettingsState> loadState() async {
    final detailsResult = await ref.read(getWorkspaceDetailsUseCaseProvider)(
      GetWorkspaceDetailsParams(workspaceId: workspaceId),
    );
    final details = _getOrThrow(detailsResult);
    final currentUserId = ref.read(currentUserProvider)?.uid;
    final pendingInvitations = await _loadPendingInvitations(
      currentUserId: currentUserId,
      ownerUid: details.workspace.ownerUid,
    );

    return WorkspaceSettingsState(
      details: details,
      pendingInvitations: pendingInvitations,
      action: WorkspaceSettingsAction.idle,
      activeTargetId: null,
      feedback: null,
    );
  }

  Future<List<WorkspacePendingInvitationEntity>> _loadPendingInvitations({
    required String? currentUserId,
    required String ownerUid,
  }) async {
    if (currentUserId != ownerUid) {
      return const <WorkspacePendingInvitationEntity>[];
    }

    final invitationsResult = await ref.read(
      getWorkspacePendingInvitationsUseCaseProvider,
    )(GetWorkspacePendingInvitationsParams(workspaceId: workspaceId));
    return _getOrThrow(invitationsResult);
  }

  T _getOrThrow<T>(Result<T> result) {
    return result.fold((failure) => throw failure, (data) => data);
  }

  void setLoadingState(WorkspaceSettingsAction action, {String? targetId}) {
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

  Future<void> runMutation<T>(
    Future<Result<T>> Function() operation, {
    required WorkspaceSettingsFeedbackType successType,
    String? targetId,
  }) async {
    final result = await operation();
    if (!ref.mounted) {
      return;
    }

    result.fold(
      setFailureState,
      (_) => reloadState(
        feedback: WorkspaceSettingsFeedback(
          type: successType,
          targetId: targetId,
        ),
      ),
    );
  }

  Future<void> runMutationWithoutReload(
    Future<Result<void>> Function() operation, {
    required WorkspaceSettingsFeedbackType successType,
  }) async {
    final result = await operation();
    if (!ref.mounted) {
      return;
    }

    result.fold(setFailureState, (_) => _setSuccessFeedback(type: successType));
  }

  Future<void> reloadState({WorkspaceSettingsFeedback? feedback}) async {
    final currentState = state.asData?.value;

    try {
      final refreshedState = await loadState();
      if (!ref.mounted) {
        return;
      }

      state = AsyncValue.data(refreshedState.copyWith(feedback: feedback));
    } on Failure catch (failure) {
      if (!ref.mounted) {
        return;
      }

      if (currentState == null) {
        state = AsyncValue.error(failure, StackTrace.current);
        return;
      }

      setFailureState(failure);
    }
  }

  void _setSuccessFeedback({required WorkspaceSettingsFeedbackType type}) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        action: WorkspaceSettingsAction.idle,
        activeTargetId: null,
        feedback: WorkspaceSettingsFeedback(type: type),
      ),
    );
  }

  void setFailureState(Failure failure) {
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
