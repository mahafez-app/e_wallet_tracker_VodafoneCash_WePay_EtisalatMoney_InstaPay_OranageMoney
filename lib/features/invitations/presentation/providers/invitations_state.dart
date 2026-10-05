import 'package:equatable/equatable.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/invitation_entity.dart';

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
    required this.recentFeedbacks,
  });

  final List<InvitationEntity> invitations;
  final String? processingInvitationId;
  final InvitationActionType? processingAction;
  final InvitationActionFeedback? feedback;
  final List<InvitationActionFeedback> recentFeedbacks;

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
    List<InvitationActionFeedback>? recentFeedbacks,
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
      recentFeedbacks: recentFeedbacks ?? this.recentFeedbacks,
    );
  }

  @override
  List<Object?> get props => [
    invitations,
    processingInvitationId,
    processingAction,
    feedback,
    recentFeedbacks,
  ];
}
