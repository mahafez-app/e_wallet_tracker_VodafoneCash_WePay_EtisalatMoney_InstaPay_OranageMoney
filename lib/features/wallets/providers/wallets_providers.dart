import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/service_providers.dart';
import '../data/datasources/sms_permission_data_source.dart';
import '../data/datasources/wallet_details_remote_data_source.dart';
import '../data/datasources/wallet_remote_data_source.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/repositories/wallet_repository.dart';
import '../domain/usecases/add_wallets_usecase.dart';
import '../domain/usecases/get_device_phone_numbers_usecase.dart';
import '../domain/usecases/get_wallets_usecase.dart';
import '../domain/usecases/sms_permission_usecases.dart';
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

final smsPermissionDataSourceProvider = Provider<SmsPermissionDataSource>(
  (ref) => const SmsPermissionDataSourceImpl(),
);

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remoteDataSource: ref.watch(walletRemoteDataSourceProvider),
    detailsDataSource: ref.watch(walletDetailsRemoteDataSourceProvider),
    permissionDataSource: ref.watch(smsPermissionDataSourceProvider),
    phoneNumberService: ref.watch(phoneNumberServiceProvider),
    deviceInfoService: ref.watch(deviceInfoServiceProvider),
  );
});

final getDevicePhoneNumbersUseCaseProvider =
    Provider<GetDevicePhoneNumbersUseCase>((ref) {
      return GetDevicePhoneNumbersUseCase(ref.watch(walletRepositoryProvider));
    });

final addWalletsUseCaseProvider = Provider<AddWalletsUseCase>((ref) {
  return AddWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final requestSmsPermissionUseCaseProvider =
    Provider<RequestSmsPermissionUseCase>((ref) {
      return RequestSmsPermissionUseCase(ref.watch(walletRepositoryProvider));
    });

final checkSmsPermissionUseCaseProvider = Provider<CheckSmsPermissionUseCase>((
  ref,
) {
  return CheckSmsPermissionUseCase(ref.watch(walletRepositoryProvider));
});

final getWalletDetailsUseCaseProvider = Provider<GetWalletDetailsUseCase>((
  ref,
) {
  return GetWalletDetailsUseCase(ref.watch(walletRepositoryProvider));
});

final getWalletsUseCaseProvider = Provider<GetWalletsUseCase>((ref) {
  return GetWalletsUseCase(ref.watch(walletRepositoryProvider));
});

/// Tracks if the user has been prompted for wallet permissions in the current app session.
final hasPromptedWalletPermissionsSessionProvider = StateProvider<bool>(
  (ref) => false,
);
