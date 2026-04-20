enum TransactionType {
  receive,
  send;

  factory TransactionType.fromString(String str) {
    return switch (str) {
      'send' => TransactionType.send,
      'receive' => TransactionType.receive,
      _ => throw ArgumentError('Invalid transaction type string: $str'),
    };
  }
}
