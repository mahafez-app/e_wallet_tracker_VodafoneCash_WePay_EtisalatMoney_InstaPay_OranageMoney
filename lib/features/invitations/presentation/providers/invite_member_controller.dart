import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/usecases/create_invitation_usecase.dart';
import '../../providers/invitations_providers.dart';

const _inviteMemberUnsetFailure = Object();

enum InviteMemberSubmissionStatus { idle, loading, success, failure }

class InviteMemberState {
  const InviteMemberState({
    required this.email,
    required this.submissionStatus,
    required this.failure,
  });

  const InviteMemberState.initial()
    : email = '',
      submissionStatus = InviteMemberSubmissionStatus.idle,
      failure = null;

  final String email;
  final InviteMemberSubmissionStatus submissionStatus;
  final Failure? failure;

  bool get isSubmitting =>
      submissionStatus == InviteMemberSubmissionStatus.loading;

  InviteMemberState copyWith({
    String? email,
    InviteMemberSubmissionStatus? submissionStatus,
    Object? failure = _inviteMemberUnsetFailure,
  }) {
    return InviteMemberState(
      email: email ?? this.email,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      failure: identical(failure, _inviteMemberUnsetFailure)
          ? this.failure
          : failure as Failure?,
    );
  }
}

final inviteMemberControllerProvider = NotifierProvider.autoDispose
    .family<InviteMemberController, InviteMemberState, String>(
      InviteMemberController.new,
    );

class InviteMemberController extends Notifier<InviteMemberState> {
  InviteMemberController(this._workspaceId);

  final String _workspaceId;

  @override
  InviteMemberState build() => const InviteMemberState.initial();

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
      submissionStatus: InviteMemberSubmissionStatus.idle,
      failure: null,
    );
  }

  void submit() {
    final email = state.email.trim();
    state = state.copyWith(
      submissionStatus: InviteMemberSubmissionStatus.loading,
      failure: null,
    );
    unawaited(_submitValidated(email));
  }

  Future<void> _submitValidated(String email) async {
    final result = await ref.read(createInvitationUseCaseProvider)(
      CreateInvitationParams(workspaceId: _workspaceId, email: email),
    );
    if (!ref.mounted) {
      return;
    }

    result.fold(
      (failure) => state = state.copyWith(
        submissionStatus: InviteMemberSubmissionStatus.failure,
        failure: failure,
      ),
      (_) => state = state.copyWith(
        submissionStatus: InviteMemberSubmissionStatus.success,
        failure: null,
      ),
    );
  }
}
