import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wallet_repository.dart';

class AddWalletsParams {
  final String phoneNumber;
  final List<String> providers;
  final String deviceId;

  const AddWalletsParams({
    required this.phoneNumber,
    required this.providers,
    required this.deviceId,
  });
}

class AddWalletsUseCase implements UseCase<void, AddWalletsParams> {
  final WalletRepository _repository;

  const AddWalletsUseCase(this._repository);

  @override
  Future<Result<void>> call(AddWalletsParams params) {
    return _repository.addWallets(
      phoneNumber: params.phoneNumber,
      providers: params.providers,
      deviceId: params.deviceId,
    );
  }
}
