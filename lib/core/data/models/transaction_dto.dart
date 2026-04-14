import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/enums/wallet_provider.dart';
import '../../../features/transactions/data/mappers/transaction_search_terms.dart';

final class TransactionDto extends TransactionEntity {
  const TransactionDto({
    required super.id,
    required super.type,
    required super.amount,
    required super.createdAt,
    required super.walletId,
    required super.walletOwnerUid,
    required super.provider,
    required super.phoneNumber,
    super.counterpartyNumber,
    super.referenceNumber,
    super.isPaid,
    super.message,
  });

  factory TransactionDto.fromFirestore(
    DocumentSnapshot doc,
    WalletProvider provider,
    String phoneNumber,
    String walletId,
    String walletOwnerUid,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionDto(
      id: doc.id,
      type: TransactionType.fromString(data['type']),
      amount: (data['amount'] as num? ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      provider: provider,
      phoneNumber: phoneNumber,
      counterpartyNumber: data['counterpartyNumber'] as String?,
      referenceNumber: data['referenceNumber'] as String?,
      isPaid: data['isPaid'] as bool? ?? false,
      message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'type': type.name,
    'amount': amount,
    'createdAt': Timestamp.fromDate(createdAt),
    'counterpartyNumber': counterpartyNumber,
    'counterpartySuffixes': TransactionSearchTerms.counterpartySuffixes(
      counterpartyNumber,
    ),
    'referenceNumber': referenceNumber,
    'isPaid': type == TransactionType.receive ? (isPaid ?? false) : isPaid,
    'message': message,
  };

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    type: type,
    amount: amount,
    createdAt: createdAt,
    walletId: walletId,
    walletOwnerUid: walletOwnerUid,
    provider: provider,
    phoneNumber: phoneNumber,
    counterpartyNumber: counterpartyNumber,
    referenceNumber: referenceNumber,
    isPaid: isPaid,
    message: message,
  );

  factory TransactionDto.fromEntity(TransactionEntity entity) => TransactionDto(
    id: entity.id,
    type: entity.type,
    amount: entity.amount,
    createdAt: entity.createdAt,
    walletId: entity.walletId,
    walletOwnerUid: entity.walletOwnerUid,
    provider: entity.provider,
    phoneNumber: entity.phoneNumber,
    counterpartyNumber: entity.counterpartyNumber,
    referenceNumber: entity.referenceNumber,
    isPaid: entity.isPaid,
    message: entity.message,
  );
}
