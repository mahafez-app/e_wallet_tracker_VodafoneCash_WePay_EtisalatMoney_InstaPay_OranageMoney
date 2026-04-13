import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../../../wallets/providers/wallets_providers.dart';
import '../../domain/usecases/add_wallets_to_workspace_usecase.dart';
import '../../domain/usecases/get_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';
import 'workspace_wallet_selection_state.dart';

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
    return _loadInitialState();
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

    _updateState(
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

    _updateState(
      _copyWithSubmission(
        currentState,
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.loading,
      ),
    );
    unawaited(_submitValidated(currentState));
  }

  Future<WorkspaceWalletSelectionState> _loadInitialState() async {
    final ownedWalletsFuture = _loadOwnedWallets();
    final workspaceDetailsFuture = _loadWorkspaceDetails();

    final ownedWallets = await ownedWalletsFuture;
    final workspaceDetails = await workspaceDetailsFuture;

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

  Future<List<WalletEntity>> _loadOwnedWallets() async {
    final walletsResult = await ref.read(getWalletsUseCaseProvider)();
    return walletsResult.fold<List<WalletEntity>>(
      (failure) => throw failure,
      (wallets) => wallets,
    );
  }

  Future<WorkspaceDetailsEntity> _loadWorkspaceDetails() async {
    final workspaceResult = await ref.read(getWorkspaceDetailsUseCaseProvider)(
      GetWorkspaceDetailsParams(workspaceId: _workspaceId),
    );
    return workspaceResult.fold(
      (failure) => throw failure,
      (details) => details,
    );
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
    _updateState(
      _copyWithSubmission(
        currentState,
        submissionStatus: WorkspaceWalletSelectionSubmissionStatus.failure,
        submissionFailure: failure,
      ),
    );
  }

  void _setSuccess(
    WorkspaceWalletSelectionState currentState,
    int linkedCount,
  ) {
    _updateState(
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

  WorkspaceWalletSelectionState _copyWithSubmission(
    WorkspaceWalletSelectionState currentState, {
    required WorkspaceWalletSelectionSubmissionStatus submissionStatus,
    Failure? submissionFailure,
  }) {
    return currentState.copyWith(
      submissionStatus: submissionStatus,
      submissionFailure: submissionFailure,
      linkedCount: 0,
    );
  }

  void _updateState(WorkspaceWalletSelectionState nextState) {
    state = AsyncValue.data(nextState);
  }
}
