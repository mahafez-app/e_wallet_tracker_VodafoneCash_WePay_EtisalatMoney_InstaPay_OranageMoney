import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:identity_product/identity_product.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/datasources/home_remote_data_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/watch_home_dashboard_usecase.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>(
  (ref) => HomeRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    currentUserId: () => ref.read(identityCurrentUserProvider)?.uid,
    walletQueries: WalletQueries(
      firestore: ref.watch(firestoreProvider),
      auth: ref.watch(firebaseAuthProvider),
    ),
  ),
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(remote: ref.watch(homeRemoteDataSourceProvider)),
);

final watchHomeDashboardUseCaseProvider = Provider<WatchHomeDashboardUseCase>(
  (ref) => WatchHomeDashboardUseCase(ref.watch(homeRepositoryProvider)),
);
