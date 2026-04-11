import 'package:equatable/equatable.dart';

import '../enums/transaction_type.dart';
import '../enums/wallet_provider.dart';

base class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
    this.counterpartyNumber,
    this.referenceNumber,
    this.isPaid,
    this.message,
  });

  /// Unique ID for this transaction record (UUID generated locally).
  final String id;

  /// Whether this is a receive or send transaction.
  final TransactionType type;

  /// The amount transferred in EGP.
  final double amount;

  /// The date and time of the transaction, parsed from the SMS body.
  /// Falls back to SMS received time if not found.
  final DateTime createdAt;

  /// The ID of the wallet this transaction belongs to in your app.
  final String walletId;

  /// The wallet provider (VF-Cash, Bank Al-Ahly, etc).
  final WalletProvider provider;

  /// YOUR wallet's phone number — the account that sent or received.
  /// e.g. 01030096242
  final String phoneNumber;

  /// The OTHER party's phone number — extracted from the SMS body.
  /// Who sent you money, or who you sent money to.
  /// Null for providers that don't include a number (e.g. bank transfers).
  final String? counterpartyNumber;

  /// The provider's reference/operation number for this transaction.
  /// e.g. "018959810019". Useful for disputes, not shown in the main UI.
  final String? referenceNumber;

  /// For receive transactions: whether you have paid this person back.
  /// Managed manually by the user inside the app.
  final bool? isPaid;

  /// The raw SMS body. Stored for debugging and re-parsing if formats change.
  final String? message;

  TransactionEntity copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    DateTime? createdAt,
    String? walletId,
    WalletProvider? provider,
    String? phoneNumber,
    String? counterpartyNumber,
    String? referenceNumber,
    bool? isPaid,
    String? message,
  }) => TransactionEntity(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
    walletId: walletId ?? this.walletId,
    provider: provider ?? this.provider,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    counterpartyNumber: counterpartyNumber ?? this.counterpartyNumber,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    isPaid: isPaid ?? this.isPaid,
    message: message ?? this.message,
  );

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    createdAt,
    walletId,
    provider,
    phoneNumber,
    counterpartyNumber,
    referenceNumber,
    isPaid,
    message,
  ];
}
