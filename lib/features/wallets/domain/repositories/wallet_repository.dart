import '../../../../core/error/result.dart';
import '../../../../core/domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_details_entity.dart';

abstract interface class WalletRepository {
  Future<Result<List<String>>> getDevicePhoneNumbers();

  Future<Result<List<WalletEntity>>> getWallets();

  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
  });

  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId);
}
