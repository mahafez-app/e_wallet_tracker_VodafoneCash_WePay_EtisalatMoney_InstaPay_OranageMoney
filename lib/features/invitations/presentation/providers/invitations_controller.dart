import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/invitation_entity.dart';
import '../../providers/invitations_providers.dart';

enum InvitationActionType { accept, decline }

final class InvitationActionFeedback extends Equatable {
  const InvitationActionFeedback.success({
    required this.action,
    required this.invitation,
  }) : failure = null;

  const InvitationActionFeedback.failure({
    required this.action,
    required this.invitation,
    required this.failure,
  });

  final InvitationActionType action;
  final InvitationEntity invitation;
  final Failure? failure;

  bool get isSuccess => failure == null;

  @override
  List<Object?> get props => [action, invitation, failure];
}

const _invitationsUnsetValue = Object();

class InvitationsState extends Equatable {
  const InvitationsState({
    required this.invitations,
    required this.processingInvitationId,
    required this.processingAction,
    required this.feedback,
  });

  final List<InvitationEntity> invitations;
  final String? processingInvitationId;
  final InvitationActionType? processingAction;
  final InvitationActionFeedback? feedback;

  bool isAccepting(String invitationId) =>
      processingInvitationId == invitationId &&
      processingAction == InvitationActionType.accept;

  bool isDeclining(String invitationId) =>
      processingInvitationId == invitationId &&
      processingAction == InvitationActionType.decline;

  InvitationsState copyWith({
    List<InvitationEntity>? invitations,
    Object? processingInvitationId = _invitationsUnsetValue,
    Object? processingAction = _invitationsUnsetValue,
    Object? feedback = _invitationsUnsetValue,
  }) {
    return InvitationsState(
      invitations: invitations ?? this.invitations,
      processingInvitationId:
          identical(processingInvitationId, _invitationsUnsetValue)
          ? this.processingInvitationId
          : processingInvitationId as String?,
      processingAction: identical(processingAction, _invitationsUnsetValue)
          ? this.processingAction
          : processingAction as InvitationActionType?,
      feedback: identical(feedback, _invitationsUnsetValue)
          ? this.feedback
          : feedback as InvitationActionFeedback?,
    );
  }

  @override
  List<Object?> get props => [
    invitations,
    processingInvitationId,
    processingAction,
    feedback,
  ];
}

final invitationsControllerProvider =
    AsyncNotifierProvider.autoDispose<InvitationsController, InvitationsState>(
      InvitationsController.new,
    );

class InvitationsController extends AsyncNotifier<InvitationsState> {
  @override
  Future<InvitationsState> build() async {
    final result = await ref.read(getPendingInvitationsUseCaseProvider).call();
    return result.fold(
      (failure) => throw failure,
      (invitations) => InvitationsState(
        invitations: invitations,
        processingInvitationId: null,
        processingAction: null,
        feedback: null,
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
      (failure) => state = AsyncValue.data(
        currentState.copyWith(
          processingInvitationId: null,
          processingAction: null,
          feedback: InvitationActionFeedback.failure(
            action: action,
            invitation: invitation,
            failure: failure,
          ),
        ),
      ),
      (_) => state = AsyncValue.data(
        currentState.copyWith(
          invitations: currentState.invitations
              .where((invitation) => invitation.id != invitationId)
              .toList(),
          processingInvitationId: null,
          processingAction: null,
          feedback: InvitationActionFeedback.success(
            action: action,
            invitation: invitation,
          ),
        ),
      ),
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
