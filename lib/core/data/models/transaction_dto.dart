import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/enums/wallet_provider.dart';

final class TransactionDto extends TransactionEntity {
  const TransactionDto({
    required super.id,
    required super.type,
    required super.amount,
    required super.createdAt,
    required super.walletId,
    required super.provider,
    required super.phoneNumber,
    super.isPaid,
    super.message,
  });

  factory TransactionDto.fromFirestore(
    DocumentSnapshot doc,
    WalletProvider provider,
    String phoneNumber,
    String walletId,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionDto(
      id: doc.id,
      type: TransactionType.fromString(data['type']),
      amount: (data['amount'] as num? ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      walletId: walletId,
      provider: provider,
      phoneNumber: phoneNumber,
      isPaid: data['isPaid'] as bool?,
      message: data['message'] as String?,
    );
  }

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    type: type,
    amount: amount,
    createdAt: createdAt,
    walletId: walletId,
    provider: provider,
    phoneNumber: phoneNumber,
    isPaid: isPaid,
    message: message,
  );
}
