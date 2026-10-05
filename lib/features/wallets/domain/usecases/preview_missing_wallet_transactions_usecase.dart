import 'package:mahafez_core/mahafez_core.dart';
import '../entities/missing_wallet_transactions_preview.dart';
import '../repositories/wallet_repository.dart';

final class PreviewMissingWalletTransactionsUseCase
    implements
        UseCase<
          MissingWalletTransactionsPreview,
          PreviewMissingWalletTransactionsParams
        > {
  const PreviewMissingWalletTransactionsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<MissingWalletTransactionsPreview>> call(
    PreviewMissingWalletTransactionsParams params,
  ) {
    return _repository.previewMissingTransactions(params.walletId);
  }
}

final class PreviewMissingWalletTransactionsParams {
  const PreviewMissingWalletTransactionsParams({required this.walletId});

  final String walletId;
}
