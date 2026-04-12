import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/domain/usecases/watch_workspace_pending_invitations_usecase.dart';
import '../../../invitations/providers/invitations_providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../../domain/usecases/watch_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';
import 'workspace_settings_state.dart';

mixin WorkspaceSettingsControllerLiveSyncMixin
    on AsyncNotifier<WorkspaceSettingsState> {
  StreamSubscription<
    (
      Result<WorkspaceDetailsEntity>,
      Result<List<WorkspacePendingInvitationEntity>>,
    )
  >?
  _liveSubscription;

  String get workspaceId;

  void bindLiveState({required String ownerUid}) {
    final currentUserId = ref.read(currentUserProvider)?.uid;
    final detailsStream = ref.read(watchWorkspaceDetailsUseCaseProvider)(
      WatchWorkspaceDetailsParams(workspaceId: workspaceId),
    );
    final invitationsStream = currentUserId == ownerUid
        ? ref.read(watchWorkspacePendingInvitationsUseCaseProvider)(
            WatchWorkspacePendingInvitationsParams(workspaceId: workspaceId),
          )
        : Stream.value(
            const Success<List<WorkspacePendingInvitationEntity>>([]),
          );

    _liveSubscription?.cancel();
    ref.onDispose(() => _liveSubscription?.cancel());
    _liveSubscription = Rx.combineLatest2(
      detailsStream,
      invitationsStream,
      (details, invitations) => (details, invitations),
    ).listen(_applyLiveUpdate);
  }

  void _applyLiveUpdate(
    (
      Result<WorkspaceDetailsEntity>,
      Result<List<WorkspacePendingInvitationEntity>>,
    )
    event,
  ) {
    if (!ref.mounted) {
      return;
    }

    final detailsFailure = event.$1.failureOrNull;
    final invitationsFailure = event.$2.failureOrNull;
    final failure = detailsFailure ?? invitationsFailure;
    if (failure != null) {
      final currentState = state.asData?.value;
      if (currentState == null) {
        state = AsyncValue.error(failure, StackTrace.current);
        return;
      }

      setFailureState(failure);
      return;
    }

    final details = event.$1.dataOrNull;
    final pendingInvitations = event.$2.dataOrNull;
    if (details == null || pendingInvitations == null) {
      return;
    }

    final currentState = state.asData?.value;
    if (currentState == null) {
      state = AsyncValue.data(
        WorkspaceSettingsState(
          details: details,
          pendingInvitations: pendingInvitations,
          action: WorkspaceSettingsAction.idle,
          activeTargetId: null,
          feedback: null,
        ),
      );
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        details: details,
        pendingInvitations: pendingInvitations,
      ),
    );
  }

  void setFailureState(Failure failure);
}
