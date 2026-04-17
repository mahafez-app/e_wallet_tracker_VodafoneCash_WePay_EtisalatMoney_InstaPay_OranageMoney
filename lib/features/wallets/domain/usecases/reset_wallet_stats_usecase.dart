import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

final class ResetWalletStatsUseCase implements UseCase<void, String> {
  const ResetWalletStatsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.resetWalletStats(params);
}
