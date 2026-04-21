import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/result.dart';
import '../entities/missing_wallet_transactions_preview.dart';
import '../../domain/entities/wallet_details_entity.dart';

abstract interface class WalletRepository {
  Future<Result<List<WalletEntity>>> getWallets();

  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
  });

  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId);

  Future<Result<MissingWalletTransactionsPreview>> previewMissingTransactions(
    String walletId,
  );

  Future<Result<void>> deleteWallet(String walletId);

  Future<Result<void>> resetWalletStats(String walletId);

  Future<Result<void>> updateWalletBalance({
    required String walletId,
    required double balance,
  });
}
