import '../../../../core/error/result.dart';
import '../repositories/wallet_repository.dart';

final class LinkSubscriptionIdParams {
  const LinkSubscriptionIdParams({
    required this.walletId,
    required this.subscriptionId,
  });

  final String walletId;
  final int subscriptionId;
}

final class LinkSubscriptionIdUseCase {
  const LinkSubscriptionIdUseCase(this._repository);

  final WalletRepository _repository;

  Future<Result<void>> call(LinkSubscriptionIdParams params) {
    return _repository.linkSubscriptionId(
      walletId: params.walletId,
      subscriptionId: params.subscriptionId,
    );
  }
}
