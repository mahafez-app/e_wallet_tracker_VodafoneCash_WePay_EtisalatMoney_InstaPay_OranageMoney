import 'dart:developer';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/enums/transaction_type.dart';
import '../egyptian_phone_number.dart';

/// Signals extracted from a parsed SMS, used to disambiguate between wallets
/// that share the same provider.
class SmsWalletMatchInput {
  const SmsWalletMatchInput({
    this.amount,
    this.transactionType,
    this.parsedBalance,
    this.counterpartyNumber,
    this.mentionedPhoneNumbers = const <String>[],
  });

  /// Amount parsed from the SMS body (e.g. 500.0).
  final double? amount;

  /// Whether this was a receive or send transaction.
  final TransactionType? transactionType;

  /// Post-transaction balance reported in the SMS body.
  /// Present in most Egyptian provider messages.
  final double? parsedBalance;

  /// Counterparty number parsed from the transaction body, if present.
  final String? counterpartyNumber;

  /// All normalized Egyptian mobile numbers mentioned anywhere in the SMS.
  final List<String> mentionedPhoneNumbers;
}

/// Selects the correct wallet from a list of same-provider candidates.
///
/// Resolution priority:
///   1. Single wallet                 — trivial case.
///   2. Explicit wallet phone mention — matches the wallet number when the
///      provider includes it in the SMS body.
///   3. Balance-delta correlation     — uses parsed SMS balance to identify
///      which wallet's running total matches after the transaction.
///   4. Least-recently-used fallback  — last resort, wrong only if both
///      wallets were used at exactly the same time.
///
/// Balance-delta tolerance is ±[_maxTaxEgp] EGP to absorb transfer taxes
/// (Egyptian providers charge up to 10 EGP per transaction).
class SmsWalletMatcher {
  SmsWalletMatcher._();

  static const _tag = 'SmsWalletMatcher';

  /// Maximum Egyptian provider transfer tax in EGP.
  static const double _maxTaxEgp = 50.0;
  static const double _balanceDecisionGapEgp = 5.0;
  static double get maxBalanceToleranceEgp => _maxTaxEgp;

  static WalletEntity resolve({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    if (wallets.isEmpty) throw ArgumentError('wallets cannot be empty');
    if (wallets.length == 1) return wallets.first;

    final phoneMatch = _matchByMentionedWalletPhone(
      wallets: wallets,
      input: input,
    );
    if (phoneMatch != null) {
      log(
        'Explicit phone mention identified wallet ${phoneMatch.id}.',
        name: _tag,
      );
      return phoneMatch;
    }

    final balanceMatch = _matchByBalanceDelta(wallets: wallets, input: input);
    if (balanceMatch != null) {
      log(
        'Balance-delta identified wallet ${balanceMatch.id} '
        '(balance ${balanceMatch.currentBalance} -> ${input.parsedBalance}).',
        name: _tag,
      );
      return balanceMatch;
    }

    log('No definitive signal found, falling back to LRU wallet.', name: _tag);
    final sorted = List<WalletEntity>.from(wallets)
      ..sort((a, b) => a.lastBalanceAt.compareTo(b.lastBalanceAt));
    return sorted.first;
  }

  static WalletEntity? _matchByMentionedWalletPhone({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    if (input.mentionedPhoneNumbers.isEmpty) return null;

    final mentionedNumbers = input.mentionedPhoneNumbers.toSet();
    final counterpartyNumber = EgyptianPhoneNumber.tryNormalizeMobile(
      input.counterpartyNumber,
    );

    final matchedWallets = wallets.where((wallet) {
      final normalizedWalletPhone = EgyptianPhoneNumber.tryNormalizeMobile(
        wallet.phoneNumber,
      );
      return normalizedWalletPhone != null &&
          mentionedNumbers.contains(normalizedWalletPhone);
    }).toList();

    if (matchedWallets.isEmpty) return null;
    if (matchedWallets.length == 1) {
      final matchedWallet = matchedWallets.first;
      final normalizedWalletPhone = EgyptianPhoneNumber.tryNormalizeMobile(
        matchedWallet.phoneNumber,
      );
      if (normalizedWalletPhone == null) return null;

      final onlyCounterpartyMentioned =
          counterpartyNumber != null &&
          input.mentionedPhoneNumbers.length == 1 &&
          normalizedWalletPhone == counterpartyNumber;
      return onlyCounterpartyMentioned ? null : matchedWallet;
    }

    if (counterpartyNumber == null) return null;

    final nonCounterpartyWallets = matchedWallets.where((wallet) {
      final normalizedWalletPhone = EgyptianPhoneNumber.tryNormalizeMobile(
        wallet.phoneNumber,
      );
      return normalizedWalletPhone != counterpartyNumber;
    }).toList();

    return nonCounterpartyWallets.length == 1
        ? nonCounterpartyWallets.first
        : null;
  }

  static WalletEntity? _matchByBalanceDelta({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    final parsedBalance = input.parsedBalance;
    final amount = input.amount;
    final type = input.transactionType;

    if (parsedBalance == null || amount == null || type == null) return null;

    final matches = <({WalletEntity wallet, double difference})>[];

    for (final wallet in wallets) {
      final cached = wallet.currentBalance;
      final expectedBase = type == TransactionType.receive
          ? cached + amount
          : cached - amount;
      final difference = (parsedBalance - expectedBase).abs();

      if (difference <= _maxTaxEgp) {
        matches.add((wallet: wallet, difference: difference));
      }
    }

    if (matches.isEmpty) return null;
    if (matches.length == 1) return matches.first.wallet;

    matches.sort((left, right) => left.difference.compareTo(right.difference));

    final bestMatch = matches.first;
    final nextBestMatch = matches[1];
    final isExactBestMatch =
        bestMatch.difference == 0 && nextBestMatch.difference > 0;
    final isClearlyBetter =
        nextBestMatch.difference - bestMatch.difference >=
        _balanceDecisionGapEgp;

    if (isExactBestMatch || isClearlyBetter) {
      return bestMatch.wallet;
    }

    return null;
  }
}
