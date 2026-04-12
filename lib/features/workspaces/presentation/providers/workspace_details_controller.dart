import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/providers/transaction_events_provider.dart';
import '../../domain/entities/workspace_details_entity.dart';
import '../../domain/usecases/watch_workspace_details_usecase.dart';
import '../../providers/workspaces_providers.dart';

final workspaceDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WorkspaceDetailsController, WorkspaceDetailsEntity, String>(
      WorkspaceDetailsController.new,
    );

class WorkspaceDetailsController extends AsyncNotifier<WorkspaceDetailsEntity> {
  WorkspaceDetailsController(this._workspaceId);

  final String _workspaceId;
  StreamSubscription<Object?>? _workspaceDetailsSubscription;

  @override
  Future<WorkspaceDetailsEntity> build() async {
    _listenTransactionUpdates();
    final stream = ref.read(watchWorkspaceDetailsUseCaseProvider)(
      WatchWorkspaceDetailsParams(workspaceId: _workspaceId),
    );
    final completer = Completer<WorkspaceDetailsEntity>();

    ref.onDispose(() => _workspaceDetailsSubscription?.cancel());

    _workspaceDetailsSubscription = stream.listen((next) {
      next.fold(
        (failure) {
          if (!completer.isCompleted) {
            completer.completeError(failure);
            return;
          }

          state = AsyncValue.error(failure, StackTrace.current);
        },
        (details) {
          state = AsyncValue.data(details);
          if (!completer.isCompleted) {
            completer.complete(details);
          }
        },
      );
    });

    return completer.future;
  }

  void _listenTransactionUpdates() {
    ref.listen<TransactionEntity?>(transactionUpdatesProvider, (
      _,
      updatedTransaction,
    ) {
      if (updatedTransaction == null) return;
      _applyUpdatedTransaction(updatedTransaction);
    });
  }

  void _applyUpdatedTransaction(TransactionEntity updatedTransaction) {
    final currentDetails = state.asData?.value;
    if (currentDetails == null) return;

    final transactionIndex = currentDetails.recentTransactions.indexWhere(
      (transaction) =>
          transaction.id == updatedTransaction.id &&
          transaction.walletId == updatedTransaction.walletId,
    );

    if (transactionIndex == -1) return;

    final updatedTransactions = List<TransactionEntity>.of(
      currentDetails.recentTransactions,
    );
    updatedTransactions[transactionIndex] = updatedTransaction;
    updatedTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = AsyncValue.data(
      WorkspaceDetailsEntity(
        workspace: currentDetails.workspace,
        wallets: currentDetails.wallets,
        members: currentDetails.members,
        recentTransactions: updatedTransactions,
      ),
    );
  }
}
