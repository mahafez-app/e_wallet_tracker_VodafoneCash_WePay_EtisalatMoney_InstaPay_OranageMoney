import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

class GetDevicePhoneNumbersUseCase implements NoParamsUseCase<List<String>> {
  const GetDevicePhoneNumbersUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<List<String>>> call() {
    return _repository.getDevicePhoneNumbers();
  }
}
