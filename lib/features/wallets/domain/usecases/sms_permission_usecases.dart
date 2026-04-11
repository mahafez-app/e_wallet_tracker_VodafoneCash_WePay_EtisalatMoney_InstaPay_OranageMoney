import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

class RequestSmsPermissionUseCase implements NoParamsUseCase<bool> {
  final WalletRepository _repository;

  const RequestSmsPermissionUseCase(this._repository);

  @override
  Future<Result<bool>> call() {
    return _repository.requestPermissions();
  }
}

class CheckSmsPermissionUseCase implements NoParamsUseCase<bool> {
  final WalletRepository _repository;

  const CheckSmsPermissionUseCase(this._repository);

  @override
  Future<Result<bool>> call() {
    return _repository.hasPermissions();
  }
}
