import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';

import '../../../generated/l10n.dart';

extension TransactionShareExtension on TransactionEntity {
  /// Formats the transaction into a localized text receipt suitable for sharing.
  String toShareText(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat.yMMMMEEEEd(locale).format(createdAt);
    final timeStr = DateFormat.jm(locale).format(createdAt);
    final isReceive = type == TransactionType.receive;
    final sign = isReceive ? '+' : '-';

    final typeLabel = isReceive
        ? S.of(context).transactionTypeReceive
        : S.of(context).transactionTypeSend;

    final receiptHeader = S.of(context).transaction_receiptHeader(typeLabel);
    final amountLabel = S.of(context).transaction_amount;
    final walletLabel = S.of(context).transaction_wallet;
    final dateLabel = S.of(context).transaction_date;
    final currency = S.of(context).currency;

    final baseText =
        '''
$receiptHeader
────────────────────
$amountLabel: $sign${amount.toStringAsFixed(2)} $currency
$walletLabel: $phoneNumber
$dateLabel: $dateStr · $timeStr
''';

    final referenceText = referenceNumber != null
        ? '${S.of(context).transaction_referenceNumber}: $referenceNumber\n'
        : '';

    final messageText = message != null ? '$message\n' : '';

    return (baseText + referenceText + messageText).trim();
  }
}
