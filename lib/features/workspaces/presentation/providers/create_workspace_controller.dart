import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/workspace_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/create_workspace_usecase.dart';
import '../../providers/workspaces_providers.dart';

const _unsetFailure = Object();
const _unsetWorkspaceId = Object();

enum CreateWorkspaceSubmissionStatus { idle, loading, success, failure }

final class CreateWorkspaceState {
  const CreateWorkspaceState({
    required this.name,
    required this.submissionStatus,
    required this.submissionFailure,
    required this.createdWorkspaceId,
  });

  const CreateWorkspaceState.initial()
    : name = '',
      submissionStatus = CreateWorkspaceSubmissionStatus.idle,
      submissionFailure = null,
      createdWorkspaceId = null;

  final String name;
  final CreateWorkspaceSubmissionStatus submissionStatus;
  final Failure? submissionFailure;
  final String? createdWorkspaceId;

  bool get isSubmitting =>
      submissionStatus == CreateWorkspaceSubmissionStatus.loading;

  bool get canSubmit => name.trim().isNotEmpty && !isSubmitting;

  CreateWorkspaceState copyWith({
    String? name,
    CreateWorkspaceSubmissionStatus? submissionStatus,
    Object? submissionFailure = _unsetFailure,
    Object? createdWorkspaceId = _unsetWorkspaceId,
  }) {
    return CreateWorkspaceState(
      name: name ?? this.name,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: identical(submissionFailure, _unsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
      createdWorkspaceId: identical(createdWorkspaceId, _unsetWorkspaceId)
          ? this.createdWorkspaceId
          : createdWorkspaceId as String?,
    );
  }
}

final createWorkspaceControllerProvider =
    NotifierProvider.autoDispose<
      CreateWorkspaceController,
      CreateWorkspaceState
    >(CreateWorkspaceController.new);

class CreateWorkspaceController extends Notifier<CreateWorkspaceState> {
  @override
  CreateWorkspaceState build() => const CreateWorkspaceState.initial();

  void updateName(String name) {
    state = state.copyWith(
      name: name,
      submissionStatus: CreateWorkspaceSubmissionStatus.idle,
      submissionFailure: null,
      createdWorkspaceId: null,
    );
  }

  void submit() {
    final trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      _setSubmissionFailure(
        const ValidationFailure(code: 'workspace-name-required'),
      );
      return;
    }

    state = state.copyWith(
      submissionStatus: CreateWorkspaceSubmissionStatus.loading,
      submissionFailure: null,
      createdWorkspaceId: null,
    );
    unawaited(_submitValidated(trimmedName));
  }

  Future<void> _submitValidated(String name) async {
    final result = await ref.read(createWorkspaceUseCaseProvider)(
      CreateWorkspaceParams(name: name),
    );
    if (!ref.mounted) return;

    result.fold(_setSubmissionFailure, _setSubmissionSuccess);
  }

  void _setSubmissionFailure(Failure failure) {
    state = state.copyWith(
      submissionStatus: CreateWorkspaceSubmissionStatus.failure,
      submissionFailure: failure,
      createdWorkspaceId: null,
    );
  }

  void _setSubmissionSuccess(WorkspaceEntity workspace) {
    state = state.copyWith(
      submissionStatus: CreateWorkspaceSubmissionStatus.success,
      submissionFailure: null,
      createdWorkspaceId: workspace.id,
    );
  }
}
