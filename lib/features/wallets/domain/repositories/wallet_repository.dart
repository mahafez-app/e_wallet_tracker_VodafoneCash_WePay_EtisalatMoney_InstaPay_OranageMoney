import '../../../../core/error/result.dart';
import '../../domain/entities/wallet_details_entity.dart';

abstract interface class WalletRepository {
  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required String deviceId,
  });

  Future<Result<bool>> requestSmsPermission();

  Future<Result<bool>> hasSmsPermission();

  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId);
}
