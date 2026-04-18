import 'dart:developer';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/enums/transaction_type.dart';

/// Signals extracted from a parsed SMS, used to disambiguate between wallets
/// that share the same provider.
class SmsWalletMatchInput {
  const SmsWalletMatchInput({
    this.amount,
    this.transactionType,
    this.parsedBalance,
  });

  /// Amount parsed from the SMS body (e.g. 500.0).
  final double? amount;

  /// Whether this was a receive or send transaction.
  final TransactionType? transactionType;

  /// Post-transaction balance reported in the SMS body.
  /// Present in most Egyptian provider messages.
  final double? parsedBalance;
}

/// Selects the correct wallet from a list of same-provider candidates.
///
/// Resolution priority:
///   1. Single wallet                 — trivial case.
///   2. Balance-delta correlation     — uses parsed SMS balance to identify
///      which wallet's running total matches after the transaction.
///   3. Least-recently-used fallback  — last resort, wrong only if both
///      wallets were used at exactly the same time.
///
/// Balance-delta tolerance is ±[_maxTaxEgp] EGP to absorb transfer taxes
/// (Egyptian providers charge up to 10 EGP per transaction).
class SmsWalletMatcher {
  SmsWalletMatcher._();

  static const _tag = 'SmsWalletMatcher';

  /// Maximum Egyptian provider transfer tax in EGP.
  static const double _maxTaxEgp = 50.0;

  static WalletEntity resolve({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    if (wallets.isEmpty) throw ArgumentError('wallets cannot be empty');
    if (wallets.length == 1) return wallets.first;

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

  static WalletEntity? _matchByBalanceDelta({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    final parsedBalance = input.parsedBalance;
    final amount = input.amount;
    final type = input.transactionType;

    if (parsedBalance == null || amount == null || type == null) return null;

    final matches = <WalletEntity>[];

    for (final wallet in wallets) {
      final cached = wallet.currentBalance;
      final expectedBase = type == TransactionType.receive
          ? cached + amount
          : cached - amount;
      final lowerBound = expectedBase - _maxTaxEgp;
      final upperBound = expectedBase + _maxTaxEgp;

      if (parsedBalance >= lowerBound && parsedBalance <= upperBound) {
        matches.add(wallet);
      }
    }

    return matches.length == 1 ? matches.first : null;
  }
}
