import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_details_entity.dart';
import '../../domain/usecases/wallet_details_usecases.dart';
import '../../providers/wallets_providers.dart';

final walletDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WalletDetailsController, WalletDetailsEntity, String>(
      WalletDetailsController.new,
    );

class WalletDetailsController extends AsyncNotifier<WalletDetailsEntity> {
  WalletDetailsController(this._walletId);

  final String _walletId;

  @override
  Future<WalletDetailsEntity> build() async {
    final result = await ref.watch(getWalletDetailsUseCaseProvider)(
      GetWalletDetailsParams(walletId: _walletId),
    );

    return result.fold(
      (failure) => throw failure,
      (walletDetails) => walletDetails,
    );
  }
}
