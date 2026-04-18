import '../domain/enums/transaction_type.dart';
import '../utils/egyptian_phone_number.dart';
import '../utils/sms/sms_parse_result.dart';

typedef ParsedInboxSmsRecord = ({
  DateTime createdAt,
  String body,
  SmsParseResult parseResult,
});

final class InboxSmsHistoryMatcher {
  const InboxSmsHistoryMatcher._();

  static List<ParsedInboxSmsRecord> resolveWalletHistory({
    required List<ParsedInboxSmsRecord> records,
    required String targetPhoneNumber,
    required List<String> sameProviderPhoneNumbers,
  }) {
    final resolution = _resolve(
      records: records,
      targetPhoneNumber: targetPhoneNumber,
      sameProviderPhoneNumbers: sameProviderPhoneNumbers,
    );
    return resolution.targetRecords;
  }

  static double? resolveLatestBalance({
    required List<ParsedInboxSmsRecord> records,
    required String targetPhoneNumber,
    required List<String> sameProviderPhoneNumbers,
  }) {
    final resolution = _resolve(
      records: records,
      targetPhoneNumber: targetPhoneNumber,
      sameProviderPhoneNumbers: sameProviderPhoneNumbers,
    );

    for (final record in resolution.targetRecords.reversed) {
      final balance = record.parseResult.balance;
      if (balance != null) {
        return balance;
      }
    }

    return null;
  }

  static _HistoryResolution _resolve({
    required List<ParsedInboxSmsRecord> records,
    required String targetPhoneNumber,
    required List<String> sameProviderPhoneNumbers,
  }) {
    final normalizedTargetPhoneNumber = EgyptianPhoneNumber.tryNormalizeMobile(
      targetPhoneNumber,
    );
    if (normalizedTargetPhoneNumber == null) {
      return const _HistoryResolution(targetRecords: <ParsedInboxSmsRecord>[]);
    }

    final normalizedProviderPhoneNumbers =
        sameProviderPhoneNumbers
            .map(EgyptianPhoneNumber.tryNormalizeMobile)
            .whereType<String>()
            .toSet()
          ..add(normalizedTargetPhoneNumber);

    if (normalizedProviderPhoneNumbers.length <= 1) {
      return _HistoryResolution(targetRecords: records);
    }

    final sortedRecords = List<ParsedInboxSmsRecord>.from(records)
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));
    final mentions = sortedRecords
        .map(
          (record) => _resolveMention(
            mentionedPhoneNumbers: record.parseResult.mentionedPhoneNumbers,
            normalizedTargetPhoneNumber: normalizedTargetPhoneNumber,
            normalizedProviderPhoneNumbers: normalizedProviderPhoneNumbers,
          ),
        )
        .toList(growable: false);

    final targetIndexes = <int>{
      for (var index = 0; index < mentions.length; index += 1)
        if (mentions[index] == _WalletMention.target) index,
    };

    var changed = true;
    while (changed) {
      changed = false;
      final currentTargetIndexes = targetIndexes.toList()..sort();

      for (final index in currentTargetIndexes) {
        final previousIndex = index - 1;
        if (_canAdoptIndex(
          candidateIndex: previousIndex,
          currentIndex: index,
          mentions: mentions,
          records: sortedRecords,
          targetIndexes: targetIndexes,
        )) {
          changed = targetIndexes.add(previousIndex) || changed;
        }

        final nextIndex = index + 1;
        if (_canAdoptIndex(
          candidateIndex: nextIndex,
          currentIndex: index,
          mentions: mentions,
          records: sortedRecords,
          targetIndexes: targetIndexes,
        )) {
          changed = targetIndexes.add(nextIndex) || changed;
        }
      }
    }

    final targetRecords = <ParsedInboxSmsRecord>[];
    for (var index = 0; index < sortedRecords.length; index += 1) {
      if (targetIndexes.contains(index)) {
        targetRecords.add(sortedRecords[index]);
      }
    }

    return _HistoryResolution(targetRecords: targetRecords);
  }

  static _WalletMention _resolveMention({
    required List<String> mentionedPhoneNumbers,
    required String normalizedTargetPhoneNumber,
    required Set<String> normalizedProviderPhoneNumbers,
  }) {
    final mentionedWalletPhoneNumbers = mentionedPhoneNumbers
        .where(normalizedProviderPhoneNumbers.contains)
        .toSet();

    if (mentionedWalletPhoneNumbers.isEmpty) {
      return _WalletMention.ambiguous;
    }

    if (mentionedWalletPhoneNumbers.length == 1 &&
        mentionedWalletPhoneNumbers.first == normalizedTargetPhoneNumber) {
      return _WalletMention.target;
    }

    return _WalletMention.other;
  }

  static bool _canAdoptIndex({
    required int candidateIndex,
    required int currentIndex,
    required List<_WalletMention> mentions,
    required List<ParsedInboxSmsRecord> records,
    required Set<int> targetIndexes,
  }) {
    if (candidateIndex < 0 || candidateIndex >= records.length) {
      return false;
    }
    if (targetIndexes.contains(candidateIndex) ||
        mentions[candidateIndex] != _WalletMention.ambiguous) {
      return false;
    }

    final olderIndex = candidateIndex < currentIndex
        ? candidateIndex
        : currentIndex;
    final newerIndex = candidateIndex < currentIndex
        ? currentIndex
        : candidateIndex;
    return _balancesChain(
      older: records[olderIndex].parseResult,
      newer: records[newerIndex].parseResult,
    );
  }

  static const double _historyBalanceToleranceEgp = 50.0;

  static bool _balancesChain({
    required SmsParseResult older,
    required SmsParseResult newer,
  }) {
    final olderBalance = older.balance;
    final newerBalance = newer.balance;
    if (olderBalance == null || newerBalance == null) {
      return false;
    }

    final expectedNewerBalance = newer.type == TransactionType.receive
        ? olderBalance + newer.amount
        : olderBalance - newer.amount;
    final difference = (newerBalance - expectedNewerBalance).abs();
    return difference <= _historyBalanceToleranceEgp;
  }
}

enum _WalletMention { target, other, ambiguous }

final class _HistoryResolution {
  const _HistoryResolution({required this.targetRecords});

  final List<ParsedInboxSmsRecord> targetRecords;
}
