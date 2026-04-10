import '../../../generated/l10n.dart';

enum TransactionType {
  receive,
  send;

  String get label => switch (this) {
    TransactionType.receive => S.current.transactionTypeReceive,
    TransactionType.send => S.current.transactionTypeSend,
  };

  factory TransactionType.fromString(String str) {
    return switch (str) {
      'send' => TransactionType.send,
      'receive' => TransactionType.receive,
      _ => throw ArgumentError('Invalid transaction type string: $str'),
    };
  }
}
