import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

class DeleteWalletUseCase implements UseCase<void, String> {
  const DeleteWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<void>> call(String walletId) {
    return _repository.deleteWallet(walletId);
  }
}
