import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../../invitations/domain/entities/workspace_pending_invitation_entity.dart';
import '../../../invitations/providers/invitations_providers.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/workspace_member_entity.dart';
import '../../domain/usecases/delete_workspace_usecase.dart';
import '../../domain/usecases/remove_wallets_from_workspace_usecase.dart';
import '../../domain/usecases/remove_workspace_member_usecase.dart';
import '../../domain/usecases/update_workspace_name_usecase.dart';
import '../../providers/workspaces_providers.dart';
import 'workspace_settings_state.dart';

mixin WorkspaceSettingsControllerCommandsMixin
    on AsyncNotifier<WorkspaceSettingsState> {
  String get workspaceId;

  void clearFeedback() {
    final currentState = state.asData?.value;
    if (currentState?.feedback == null) {
      return;
    }

    state = AsyncValue.data(currentState!.copyWith(feedback: null));
  }

  void refresh() {
    unawaited(reloadState());
  }

  void updateWorkspaceName(String name) {
    final currentState = state.asData?.value;
    final trimmedName = name.trim();
    if (currentState == null ||
        trimmedName.isEmpty ||
        trimmedName == currentState.details.workspace.name) {
      return;
    }

    setLoadingState(WorkspaceSettingsAction.updatingName);
    unawaited(
      runMutation(
        () => ref.read(updateWorkspaceNameUseCaseProvider)(
          UpdateWorkspaceNameParams(
            workspaceId: workspaceId,
            name: trimmedName,
          ),
        ),
        successType: WorkspaceSettingsFeedbackType.workspaceNameUpdated,
      ),
    );
  }

  void removeMember(WorkspaceMemberEntity member) {
    setLoadingState(
      WorkspaceSettingsAction.removingMember,
      targetId: member.uid,
    );
    unawaited(
      runMutation(
        () => ref.read(removeWorkspaceMemberUseCaseProvider)(
          RemoveWorkspaceMemberParams(
            workspaceId: workspaceId,
            memberUid: member.uid,
          ),
        ),
        successType: WorkspaceSettingsFeedbackType.memberRemoved,
        targetId: member.uid,
      ),
    );
  }

  void removeWallet(WalletEntity wallet) {
    setLoadingState(
      WorkspaceSettingsAction.removingWallet,
      targetId: wallet.id,
    );
    unawaited(
      runMutation(
        () => ref.read(removeWalletsFromWorkspaceUseCaseProvider)(
          RemoveWalletsFromWorkspaceParams(
            workspaceId: workspaceId,
            walletIds: [wallet.id],
          ),
        ),
        successType: WorkspaceSettingsFeedbackType.walletRemoved,
        targetId: wallet.id,
      ),
    );
  }

  void cancelInvitation(WorkspacePendingInvitationEntity invitation) {
    setLoadingState(
      WorkspaceSettingsAction.cancellingInvitation,
      targetId: invitation.id,
    );
    unawaited(
      runMutation(
        () => ref.read(cancelInvitationUseCaseProvider)(invitation.id),
        successType: WorkspaceSettingsFeedbackType.invitationCancelled,
        targetId: invitation.id,
      ),
    );
  }

  void leaveWorkspace() {
    final currentUserId = ref.read(currentUserProvider)?.uid;
    if (currentUserId == null) {
      setFailureState(
        const UnknownFailure(technicalMessage: 'User is not logged in.'),
      );
      return;
    }

    setLoadingState(WorkspaceSettingsAction.leavingWorkspace);
    unawaited(
      runMutationWithoutReload(
        () => ref.read(removeWorkspaceMemberUseCaseProvider)(
          RemoveWorkspaceMemberParams(
            workspaceId: workspaceId,
            memberUid: currentUserId,
          ),
        ),
        successType: WorkspaceSettingsFeedbackType.workspaceLeft,
      ),
    );
  }

  void deleteWorkspace() {
    setLoadingState(WorkspaceSettingsAction.deletingWorkspace);
    unawaited(
      runMutationWithoutReload(
        () => ref.read(deleteWorkspaceUseCaseProvider)(
          DeleteWorkspaceParams(workspaceId: workspaceId),
        ),
        successType: WorkspaceSettingsFeedbackType.workspaceDeleted,
      ),
    );
  }

  Future<void> reloadState({WorkspaceSettingsFeedback? feedback});

  void setFailureState(Failure failure);

  void setLoadingState(WorkspaceSettingsAction action, {String? targetId});

  Future<void> runMutation<T>(
    Future<Result<T>> Function() operation, {
    required WorkspaceSettingsFeedbackType successType,
    String? targetId,
  });

  Future<void> runMutationWithoutReload(
    Future<Result<void>> Function() operation, {
    required WorkspaceSettingsFeedbackType successType,
  });
}
