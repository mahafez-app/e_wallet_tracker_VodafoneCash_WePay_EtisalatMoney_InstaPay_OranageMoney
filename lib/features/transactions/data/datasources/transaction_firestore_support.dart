import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../mappers/transaction_search_terms.dart';

class TransactionFirestoreSupport {
  const TransactionFirestoreSupport({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> walletDocument(String walletId) =>
      _firestore.collection('wallets').doc(walletId);

  CollectionReference<Map<String, dynamic>> txCollection(String walletId) =>
      walletDocument(walletId).collection('transactions');

  Future<({WalletProvider provider, String phoneNumber, String ownerUid})>
  walletMeta(
    String walletId,
  ) async {
    final doc = await walletDocument(walletId).get();
    final wallet = WalletDto.fromFirestore(doc);
    return (
      provider: wallet.provider,
      phoneNumber: wallet.phoneNumber,
      ownerUid: wallet.ownerUid,
    );
  }

  Query<Map<String, dynamic>> applyFilters(
    Query<Map<String, dynamic>> query, {
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
  }) {
    var filteredQuery = query;
    if (type != null) {
      filteredQuery = filteredQuery.where('type', isEqualTo: type.name);
    }
    if (paidStatusFilter != TransactionPaidStatusFilter.all) {
      filteredQuery = filteredQuery.where(
        'isPaid',
        isEqualTo: paidStatusFilter == TransactionPaidStatusFilter.paid,
      );
    }
    final normalizedSuffix = TransactionSearchTerms.normalizeDigits(
      counterpartySuffixQuery,
    );
    if (normalizedSuffix.length >= 2) {
      filteredQuery = filteredQuery.where(
        'counterpartySuffixes',
        arrayContains: normalizedSuffix,
      );
    }
    if (dateRange != null) {
      filteredQuery = filteredQuery
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start),
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end),
          );
    }
    return filteredQuery;
  }

  Query<Map<String, dynamic>> walletTransactionsQuery(String walletId) =>
      txCollection(walletId)
          .orderBy('createdAt', descending: true)
          .orderBy(FieldPath.documentId, descending: true);

  TransactionDateRange todayRange() {
    final now = DateTime.now();
    return TransactionDateRange(
      start: DateTime(now.year, now.month, now.day),
      end: now,
    );
  }

  WalletTransactionsPageCursor toWalletCursor(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final createdAt =
        (document.data()['createdAt'] as Timestamp? ?? Timestamp.now())
            .toDate();

    return WalletTransactionsPageCursor(
      createdAt: createdAt,
      transactionId: document.id,
    );
  }
}
