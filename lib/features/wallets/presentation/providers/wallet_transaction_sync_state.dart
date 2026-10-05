import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/missing_wallet_transactions_preview.dart';

enum WalletTransactionSyncStatus {
  idle,
  loading,
  ready,
  saving,
  success,
  failure,
}

final class WalletTransactionSyncState {
  const WalletTransactionSyncState({
    this.status = WalletTransactionSyncStatus.idle,
    this.preview,
    this.selectedTransactionIds = const <String>{},
    this.failure,
    this.syncedCount = 0,
  });

  final WalletTransactionSyncStatus status;
  final MissingWalletTransactionsPreview? preview;
  final Set<String> selectedTransactionIds;
  final Failure? failure;
  final int syncedCount;

  bool get isBusy =>
      status == WalletTransactionSyncStatus.loading ||
      status == WalletTransactionSyncStatus.saving;

  WalletTransactionSyncState copyWith({
    WalletTransactionSyncStatus? status,
    MissingWalletTransactionsPreview? preview,
    Set<String>? selectedTransactionIds,
    Failure? failure,
    int? syncedCount,
    bool clearPreview = false,
    bool clearFailure = false,
  }) {
    return WalletTransactionSyncState(
      status: status ?? this.status,
      preview: clearPreview ? null : preview ?? this.preview,
      selectedTransactionIds:
          selectedTransactionIds ?? this.selectedTransactionIds,
      failure: clearFailure ? null : failure ?? this.failure,
      syncedCount: syncedCount ?? this.syncedCount,
    );
  }
}
