import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../wallets/providers/wallets_providers.dart';
import '../../domain/usecases/add_wallets_to_workspace_usecase.dart';
import '../../domain/usecases/get_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';

const _unsetFailure = Object();

enum WorkspaceWalletSelectionSubmissionStatus {
  idle,
  loading,
  success,
  failure,
}

class WorkspaceWalletSelectionState {
  const WorkspaceWalletSelectionState({
    required this.workspaceName,
    required this.ownedWallets,
    required this.linkedWalletIds,
    required this.selectedWalletIds,
    required this.submissionStatus,
    required this.submissionFailure,
    required this.linkedCount,
  });

  final String workspaceName;
  final List<WalletEntity> ownedWallets;
  final Set<String> linkedWalletIds;
  final Set<String> selectedWalletIds;
  final WorkspaceWalletSelectionSubmissionStatus submissionStatus;
  final Failure? submissionFailure;
  final int linkedCount;

  List<WalletEntity> get selectableWallets => ownedWallets
      .where((wallet) => !linkedWalletIds.contains(wallet.id))
      .toList();

  bool get isSubmitting =>
      submissionStatus == WorkspaceWalletSelectionSubmissionStatus.loading;

  bool get hasSelectableWallets => selectableWallets.isNotEmpty;

  bool get canSubmit =>
      !isSubmitting && (!hasSelectableWallets || selectedWalletIds.isNotEmpty);

  WorkspaceWalletSelectionState copyWith({
    String? workspaceName,
    List<WalletEntity>? ownedWallets,
    Set<String>? linkedWalletIds,
    Set<String>? selectedWalletIds,
    WorkspaceWalletSelectionSubmissionStatus? submissionStatus,
    Object? submissionFailure = _unsetFailure,
    int? linkedCount,
  }) {
    return WorkspaceWalletSelectionState(
      workspaceName: workspaceName ?? this.workspaceName,
      ownedWallets: ownedWallets ?? this.ownedWallets,
      linkedWalletIds: linkedWalletIds ?? this.linkedWalletIds,
      selectedWalletIds: selectedWalletIds ?? this.selectedWalletIds,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: identical(submissionFailure, _unsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
      linkedCount: linkedCount ?? this.linkedCount,
    );
  }
}

final workspaceWalletSelectionControllerProvider = AsyncNotifierProvider
    .autoDispose
    .family<
      WorkspaceWalletSelectionController,
      WorkspaceWalletSelectionState,
      String
    >(WorkspaceWalletSelectionController.new);

class WorkspaceWalletSelectionController
    extends AsyncNotifier<WorkspaceWalletSelectionState> {
  WorkspaceWalletSelectionController(this._workspaceId);

  final String _workspaceId;

  @override
  Future<WorkspaceWalletSelectionState> build() async {
    final walletsFuture = ref.read(getWalletsUseCaseProvider)();
    final workspaceFuture = ref.read(getWorkspaceDetailsUseCaseProvider)(
      GetWorkspaceDetailsParams(workspaceId: _workspaceId),
    );

    final walletsResult = await walletsFuture;
    final workspaceResult = await workspaceFuture;

    final ownedWallets = walletsResult.fold<List<WalletEntity>>(
      (failure) => throw failure,
      (wallets) => wallets,
    );
    final workspaceDetails = workspaceResult.fold(
      (failure) => throw failure,
      (details) => details,
    );

    return WorkspaceWalletSelectionState(
      workspaceName: workspaceDetails.workspace.name,
      ownedWallets: ownedWallets,
      linkedWalletIds: workspaceDetails.wallets
          .map((wallet) => wallet.id)
          .toSet(),
      selectedWalletIds: const <String>{},
      submissionStatus: WorkspaceWalletSelectionSubmissionStatus.idle,
      submissionFailure: null,
      linkedCount: 0,
    );
  }

  void toggleWallet(String walletId) {
    final currentState = state.asData?.value;
    if (currentState == null) return;
    if (currentState.linkedWalletIds.contains(walletId)) return;

    final selectedWalletIds = Set<String>.of(currentState.selectedWalletIds);
    if (selectedWalletIds.contains(walletId)) {
      selectedWalletIds.remove(walletId);
    } else {
      selectedWalletIds.add(walletId);
    }

    state = AsyncValue.data(
      currentState.copyWith(
        selectedWalletIds: selectedWalletIds,
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.idle,
        submissionFailure: null,
        linkedCount: 0,
      ),
    );
  }

  void submit() {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    if (!currentState.hasSelectableWallets) {
      _setSuccess(currentState, 0);
      return;
    }

    if (currentState.selectedWalletIds.isEmpty) {
      _setFailure(
        currentState,
        const ValidationFailure(code: 'workspace-wallet-selection-required'),
      );
      return;
    }

    state = AsyncValue.data(
      currentState.copyWith(
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.loading,
        submissionFailure: null,
        linkedCount: 0,
      ),
    );
    unawaited(_submitValidated(currentState));
  }

  Future<void> _submitValidated(
    WorkspaceWalletSelectionState currentState,
  ) async {
    final result = await ref.read(addWalletsToWorkspaceUseCaseProvider)(
      AddWalletsToWorkspaceParams(
        workspaceId: _workspaceId,
        walletIds: currentState.selectedWalletIds.toList(),
      ),
    );

    if (!ref.mounted) return;

    result.fold(
      (failure) => _setFailure(currentState, failure),
      (linkedCount) => _setSuccess(currentState, linkedCount),
    );
  }

  void _setFailure(
    WorkspaceWalletSelectionState currentState,
    Failure failure,
  ) {
    state = AsyncValue.data(
      currentState.copyWith(
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.failure,
        submissionFailure: failure,
        linkedCount: 0,
      ),
    );
  }

  void _setSuccess(
    WorkspaceWalletSelectionState currentState,
    int linkedCount,
  ) {
    state = AsyncValue.data(
      currentState.copyWith(
        linkedWalletIds: {
          ...currentState.linkedWalletIds,
          ...currentState.selectedWalletIds,
        },
        selectedWalletIds: const <String>{},
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.success,
        submissionFailure: null,
        linkedCount: linkedCount,
      ),
    );
  }
}
