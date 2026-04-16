import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/cache_providers.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/service_providers.dart';
import '../data/datasources/wallet_details_remote_data_source.dart';
import '../data/datasources/wallet_remote_data_source.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/repositories/wallet_repository.dart';
import '../domain/usecases/add_wallets_usecase.dart';
import '../domain/usecases/delete_wallet_usecase.dart';
import '../domain/usecases/get_wallets_usecase.dart';
import '../domain/usecases/link_subscription_id_usecase.dart';
import '../domain/usecases/wallet_details_usecases.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final walletDetailsRemoteDataSourceProvider =
    Provider<WalletDetailsRemoteDataSource>((ref) {
  return WalletDetailsRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remoteDataSource: ref.watch(walletRemoteDataSourceProvider),
    detailsDataSource: ref.watch(walletDetailsRemoteDataSourceProvider),
    deviceInfoService: ref.watch(deviceInfoServiceProvider),
    walletMetaCache: ref.watch(walletMetaCacheProvider),
  );
});



final addWalletsUseCaseProvider = Provider<AddWalletsUseCase>((ref) {
  return AddWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final getWalletDetailsUseCaseProvider = Provider<GetWalletDetailsUseCase>(
  (ref) => GetWalletDetailsUseCase(ref.watch(walletRepositoryProvider)),
);

final getWalletsUseCaseProvider = Provider<GetWalletsUseCase>((ref) {
  return GetWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final deleteWalletUseCaseProvider = Provider<DeleteWalletUseCase>((ref) {
  return DeleteWalletUseCase(ref.watch(walletRepositoryProvider));
});

final linkSubscriptionIdUseCaseProvider =
    Provider<LinkSubscriptionIdUseCase>((ref) {
  return LinkSubscriptionIdUseCase(ref.watch(walletRepositoryProvider));
});
