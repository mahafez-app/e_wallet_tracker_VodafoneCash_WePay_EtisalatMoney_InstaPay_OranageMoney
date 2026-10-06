import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:identity_product/identity_product.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:workspace_product/workspace_product.dart';
import 'package:mahafez_app/generated/l10n.dart';

import '../router/app_routes.dart';
import 'firebase_providers.dart';
import '../utils/extensions/wallet_provider_ext.dart';

final class AppWorkspaceWalletCatalog implements WorkspaceWalletCatalog {
  const AppWorkspaceWalletCatalog({
    required this._queries,
    required this._getOwnedWallets,
  });

  final WalletQueries _queries;
  final Future<List<WalletEntity>> Function() _getOwnedWallets;

  @override
  Future<List<WorkspaceWalletSummary>> getOwnedWallets(String ownerUid) async =>
      (await _getOwnedWallets())
          .where((wallet) => wallet.ownerUid == ownerUid)
          .map(_toSummary)
          .toList();

  @override
  Future<List<WorkspaceWalletSummary>> getByIds(List<String> ids) async =>
      (await _queries.getByIds(ids)).map(_toSummary).toList();

  @override
  Stream<List<WorkspaceWalletSummary>> watchByIds(List<String> ids) => _queries
      .watchByIds(ids)
      .map((wallets) => wallets.map(_toSummary).toList());

  static WorkspaceWalletSummary _toSummary(WalletEntity wallet) =>
      WorkspaceWalletSummary(
        id: wallet.id,
        ownerUid: wallet.ownerUid,
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        currentBalance: wallet.currentBalance,
        totalReceived: wallet.totalReceived,
        totalSent: wallet.totalSent,
        lastActivityAt: wallet.lastBalanceAt,
      );
}

WorkspaceProductConfig createWorkspaceProductConfig(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return WorkspaceProductConfig(
    firestore: firestore,
    identityService: ref.watch(identityServiceProvider),
    currentUserId: () => ref.read(identityCurrentUserProvider)?.uid,
    currentUser: () => ref.read(identityCurrentUserProvider),
    walletCatalog: AppWorkspaceWalletCatalog(
      queries: WalletQueries(
        firestore: firestore,
        auth: ref.watch(firebaseAuthProvider),
      ),
      getOwnedWallets: () async {
        final result = await ref.read(getWalletsUseCaseProvider)();
        return result.fold((failure) => throw failure, (wallets) => wallets);
      },
    ),
    onOpenWallet: (context, walletId) =>
        context.push(AppRoutes.walletDetailsPath(walletId)),
    onOpenTransactions: (context, transactions) => context.push(
      AppRoutes.transactionsPath(),
      extra: MultiWalletTransactionsRouteData(
        title: transactions.title,
        wallets: transactions.wallets
            .map(
              (wallet) => TransactionWalletFilterOption(
                walletId: wallet.walletId,
                walletLabel: wallet.walletLabel,
                memberId: wallet.memberId,
                memberName: wallet.memberName,
              ),
            )
            .toList(),
      ),
    ),
    buildWorkspaceReport: (context, workspaceId, wallets) =>
        WalletTransactionReportScreen(
          walletIds: wallets.map((wallet) => wallet.id).toList(),
          title: S.of(context).reports_workspace_title,
          walletOptions: wallets
              .map(
                (wallet) => WalletReportOption(
                  id: wallet.id,
                  label:
                      '${wallet.provider.displayName(context)} ${wallet.phoneNumber}',
                ),
              )
              .toList(),
        ),
  );
}
