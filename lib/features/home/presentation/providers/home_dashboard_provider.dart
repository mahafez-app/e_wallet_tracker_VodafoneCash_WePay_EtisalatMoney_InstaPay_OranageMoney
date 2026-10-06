import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:identity_product/identity_product.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:workspace_product/workspace_product.dart';

import '../../domain/entities/home_dashboard_entity.dart';
import '../../../../core/providers/firebase_providers.dart';

final homeDashboardProvider = StreamProvider.autoDispose<HomeDashboardEntity>((
  ref,
) {
  final currentUser = ref.watch(identityCurrentUserProvider);
  if (currentUser == null) {
    return const Stream<HomeDashboardEntity>.empty();
  }

  final walletQueries = WalletQueries(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
  return Rx.combineLatest3(
    walletQueries.watchMine(),
    ref.watch(workspaceSummariesStreamProvider),
    ref.watch(pendingInvitationsCountStreamProvider),
    (wallets, workspaces, invitationsCount) => HomeDashboardEntity(
      totalBalance: wallets.fold<double>(
        0,
        (sum, wallet) => sum + wallet.currentBalance,
      ),
      totalReceived: wallets.fold<double>(
        0,
        (sum, wallet) => sum + wallet.totalReceived,
      ),
      totalSent: wallets.fold<double>(
        0,
        (sum, wallet) => sum + wallet.totalSent,
      ),
      wallets: wallets,
      workspaces: workspaces,
      invitationsCount: invitationsCount,
    ),
  );
});
