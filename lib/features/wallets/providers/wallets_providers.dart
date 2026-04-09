import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/sms_permission_data_source.dart';
import '../data/datasources/wallet_remote_data_source.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/repositories/wallet_repository.dart';
import '../domain/usecases/add_wallets_usecase.dart';
import '../domain/usecases/sms_permission_usecases.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final smsPermissionDataSourceProvider = Provider<SmsPermissionDataSource>((ref) {
  return const SmsPermissionDataSourceImpl();
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remoteDataSource: ref.watch(walletRemoteDataSourceProvider),
    permissionDataSource: ref.watch(smsPermissionDataSourceProvider),
  );
});

final addWalletsUseCaseProvider = Provider<AddWalletsUseCase>((ref) {
  return AddWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final requestSmsPermissionUseCaseProvider = Provider<RequestSmsPermissionUseCase>((ref) {
  return RequestSmsPermissionUseCase(ref.watch(walletRepositoryProvider));
});

final checkSmsPermissionUseCaseProvider = Provider<CheckSmsPermissionUseCase>((ref) {
  return CheckSmsPermissionUseCase(ref.watch(walletRepositoryProvider));
});
