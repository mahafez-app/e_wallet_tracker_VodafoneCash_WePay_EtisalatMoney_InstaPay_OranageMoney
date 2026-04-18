import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

final class UpdateWalletBalanceParams {
  const UpdateWalletBalanceParams({
    required this.walletId,
    required this.balance,
  });

  final String walletId;
  final double balance;
}

final class UpdateWalletBalanceUseCase
    implements UseCase<void, UpdateWalletBalanceParams> {
  const UpdateWalletBalanceUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<void>> call(UpdateWalletBalanceParams params) {
    return _repository.updateWalletBalance(
      walletId: params.walletId,
      balance: params.balance,
    );
  }
}
