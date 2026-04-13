import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/data/models/wallet_dto.dart';

class WorkspaceTransactionsPreviewRemoteService {
  const WorkspaceTransactionsPreviewRemoteService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<TransactionDto>> getWorkspaceTransactionsPreview({
    required List<WalletDto> wallets,
    int limit = 5,
  }) async {
    if (wallets.isEmpty || limit <= 0) {
      return const <TransactionDto>[];
    }

    final snapshots = await Future.wait(
      wallets.map((wallet) => _transactionsQuery(wallet.id).limit(limit).get()),
    );
    final transactions = <TransactionDto>[
      for (var index = 0; index < wallets.length; index++)
        ...snapshots[index].docs.map(
          (document) => TransactionDto.fromFirestore(
            document,
            wallets[index].provider,
            wallets[index].phoneNumber,
            wallets[index].id,
          ),
        ),
    ];

    return _sortAndTrimTransactions(transactions: transactions, limit: limit);
  }

  Stream<List<TransactionDto>> watchWorkspaceTransactionsPreview({
    required List<WalletDto> wallets,
    int limit = 5,
  }) {
    if (wallets.isEmpty || limit <= 0) {
      return Stream.value(const <TransactionDto>[]);
    }

    final streams = wallets.map(
      (wallet) => _transactionsQuery(wallet.id)
          .limit(limit)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (document) => TransactionDto.fromFirestore(
                    document,
                    wallet.provider,
                    wallet.phoneNumber,
                    wallet.id,
                  ),
                )
                .toList(),
          ),
    );

    return Rx.combineLatestList(streams).map(
      (snapshots) => _sortAndTrimTransactions(
        transactions: snapshots.expand((items) => items).toList(),
        limit: limit,
      ),
    );
  }

  Query<Map<String, dynamic>> _transactionsQuery(String walletId) {
    return _firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .orderBy(FieldPath.documentId, descending: true);
  }

  List<TransactionDto> _sortAndTrimTransactions({
    required List<TransactionDto> transactions,
    required int limit,
  }) {
    transactions.sort(_compareTransactions);
    return transactions.take(limit).toList();
  }

  int _compareTransactions(TransactionDto left, TransactionDto right) {
    final dateComparison = right.createdAt.compareTo(left.createdAt);
    if (dateComparison != 0) {
      return dateComparison;
    }

    return right.id.compareTo(left.id);
  }
}
