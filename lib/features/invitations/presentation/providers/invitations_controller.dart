import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/invitation_entity.dart';
import '../../domain/enums/invitation_status.dart';
import '../../providers/invitations_providers.dart';
import 'invitations_state.dart';

final invitationsControllerProvider =
    AsyncNotifierProvider.autoDispose<InvitationsController, InvitationsState>(
      InvitationsController.new,
    );

class InvitationsController extends AsyncNotifier<InvitationsState> {
  @override
  Future<InvitationsState> build() async {
    final pendingResult = await ref
        .read(getPendingInvitationsUseCaseProvider)
        .call();
    final recentFeedbacks = await _loadRecentFeedbacks();

    return pendingResult.fold(
      (failure) => throw failure,
      (invitations) => InvitationsState(
        invitations: invitations,
        processingInvitationId: null,
        processingAction: null,
        feedback: null,
        recentFeedbacks: recentFeedbacks,
      ),
    );
  }

  void acceptInvitation(String invitationId) {
    unawaited(
      _respondToInvitation(
        invitationId: invitationId,
        action: InvitationActionType.accept,
      ),
    );
  }

  void declineInvitation(String invitationId) {
    unawaited(
      _respondToInvitation(
        invitationId: invitationId,
        action: InvitationActionType.decline,
      ),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> _respondToInvitation({
    required String invitationId,
    required InvitationActionType action,
  }) async {
    final currentState = state.asData?.value;
    if (currentState?.processingInvitationId != null) {
      return;
    }

    final invitation = _findInvitation(currentState, invitationId);
    if (currentState == null || invitation == null) {
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        processingInvitationId: invitationId,
        processingAction: action,
        feedback: null,
      ),
    );

    final result = action == InvitationActionType.accept
        ? await ref.read(acceptInvitationUseCaseProvider)(invitationId)
        : await ref.read(declineInvitationUseCaseProvider)(invitationId);
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => _handleFailure(currentState, invitation, action, failure),
      (_) => _handleSuccess(currentState, invitation, action),
    );
  }

  void _handleFailure(
    InvitationsState currentState,
    InvitationEntity invitation,
    InvitationActionType action,
    Failure failure,
  ) {
    state = AsyncValue.data(
      currentState.copyWith(
        processingInvitationId: null,
        processingAction: null,
        feedback: InvitationActionFeedback.failure(
          action: action,
          invitation: invitation,
          failure: failure,
        ),
      ),
    );
  }

  void _handleSuccess(
    InvitationsState currentState,
    InvitationEntity invitation,
    InvitationActionType action,
  ) {
    final feedback = InvitationActionFeedback.success(
      action: action,
      invitation: invitation,
    );

    state = AsyncValue.data(
      currentState.copyWith(
        invitations: currentState.invitations
            .where((item) => item.id != invitation.id)
            .toList(),
        processingInvitationId: null,
        processingAction: null,
        feedback: feedback,
        recentFeedbacks: _appendFeedback(
          currentState.recentFeedbacks,
          feedback,
        ),
      ),
    );
  }

  List<InvitationActionFeedback> _appendFeedback(
    List<InvitationActionFeedback> current,
    InvitationActionFeedback feedback,
  ) {
    final deduplicated = current.where(
      (item) => item.invitation.id != feedback.invitation.id,
    );
    return [feedback, ...deduplicated].take(2).toList();
  }

  Future<List<InvitationActionFeedback>> _loadRecentFeedbacks() async {
    final result = await ref
        .read(getRecentRespondedInvitationsUseCaseProvider)
        .call();
    return result.fold(
      (_) => const <InvitationActionFeedback>[],
      (invitations) => invitations.map(_mapRecentFeedback).toList(),
    );
  }

  InvitationActionFeedback _mapRecentFeedback(InvitationEntity invitation) {
    final action = invitation.status == InvitationStatus.accepted
        ? InvitationActionType.accept
        : InvitationActionType.decline;
    return InvitationActionFeedback.success(
      action: action,
      invitation: invitation,
    );
  }

  InvitationEntity? _findInvitation(
    InvitationsState? currentState,
    String invitationId,
  ) {
    if (currentState == null) {
      return null;
    }

    for (final invitation in currentState.invitations) {
      if (invitation.id == invitationId) {
        return invitation;
      }
    }

    return null;
  }
}
