import '../../../../core/domain/entities/wallet_entity.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

class GetWalletsUseCase implements NoParamsUseCase<List<WalletEntity>> {
  final WalletRepository _repository;

  const GetWalletsUseCase(this._repository);

  @override
  Future<Result<List<WalletEntity>>> call() {
    return _repository.getWallets();
  }
}
