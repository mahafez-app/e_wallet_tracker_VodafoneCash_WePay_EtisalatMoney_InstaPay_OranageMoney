import '../../../../core/error/result.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_details_entity.dart';

abstract interface class WalletRepository {
  Future<Result<List<WalletEntity>>> getWallets();

  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required String deviceId,
  });

  Future<Result<bool?>> requestSmsPermission();

  Future<Result<bool>> hasSmsPermission();

  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId);
}
