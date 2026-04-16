import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/domain/enums/transaction_type.dart';
import '../../domain/entities/report_entity.dart';

abstract interface class ReportRemoteDataSource {
  Future<ReportEntity> getWalletReport({
    required String walletId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<ReportEntity> getWorkspaceReport({
    required String workspaceId,
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  const ReportRemoteDataSourceImpl({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  @override
  Future<ReportEntity> getWalletReport({
    required String walletId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final query = firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

    final snapshot = await query.get();
    return _aggregateReport(snapshot.docs);
  }

  @override
  Future<ReportEntity> getWorkspaceReport({
    required String workspaceId,
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (walletIds.isEmpty) {
      return const ReportEntity(
        totalIncome: 0,
        totalOutcome: 0,
        balanceChange: 0,
        transactionCount: 0,
        transactionsByDay: {},
        receivedTransactionCount: 0,
        sentTransactionCount: 0,
      );
    }
    
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [];

    final futures = walletIds.map((walletId) {
      return firestore
          .collection('wallets')
          .doc(walletId)
          .collection('transactions')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
    });

    final snapshots = await Future.wait(futures);
    for (final snapshot in snapshots) {
      allDocs.addAll(snapshot.docs);
    }

    return _aggregateReport(allDocs);
  }

  ReportEntity _aggregateReport(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    double totalIncome = 0;
    double totalOutcome = 0;
    int count = 0;
    int receivedCount = 0;
    int sentCount = 0;
    final Map<DateTime, double> byDay = {};

    for (final doc in docs) {
      try {
        final data = doc.data();
        final typeStr = data['type'] as String?;
        if (typeStr == null) continue;
        final type = TransactionType.fromString(typeStr);
        final amount = (data['amount'] as num? ?? 0.0).toDouble();
        final dateTs = data['createdAt'] as Timestamp?;
        if (dateTs == null) continue;
        final date = dateTs.toDate();

        count++;
        if (type == TransactionType.receive) {
          totalIncome += amount;
          receivedCount++;
        } else if (type == TransactionType.send) {
          totalOutcome += amount;
          sentCount++;
        }

        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final dayDate = DateTime.parse(dateStr);
        final currentDayAmount = byDay[dayDate] ?? 0.0;

        if (type == TransactionType.receive) {
          byDay[dayDate] = currentDayAmount + amount;
        } else if (type == TransactionType.send) {
          byDay[dayDate] = currentDayAmount - amount;
        }
      } catch (e, st) {
        log('Error parsing transaction doc for report: \\${e.toString()}', name: 'ReportRemoteDataSource', stackTrace: st);
      }
    }

    return ReportEntity(
      totalIncome: totalIncome,
      totalOutcome: totalOutcome,
      balanceChange: totalIncome - totalOutcome,
      transactionCount: count,
      transactionsByDay: byDay,
      receivedTransactionCount: receivedCount,
      sentTransactionCount: sentCount,
    );
  }
}
