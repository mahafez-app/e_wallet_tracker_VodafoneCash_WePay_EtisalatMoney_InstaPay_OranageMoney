import 'dart:developer';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/enums/transaction_type.dart';

/// Signals extracted from a parsed SMS, used as disambiguation inputs
/// when [subscriptionId] is null and multiple wallets share a provider.
class SmsWalletMatchInput {
  const SmsWalletMatchInput({
    required this.subscriptionId,
    this.amount,
    this.transactionType,
    this.parsedBalance,
  });

  final int? subscriptionId;

  /// Amount parsed from the SMS body (e.g. 500.0).
  final double? amount;

  /// Whether this was a receive or send transaction.
  final TransactionType? transactionType;

  /// Post-transaction balance reported in the SMS body.
  /// Present in most Egyptian provider messages.
  final double? parsedBalance;
}

/// Result of a wallet-resolution attempt.
class SmsWalletMatchResult {
  const SmsWalletMatchResult({
    required this.wallet,
    this.needsSubscriptionMapping = false,
  });

  /// The wallet that was matched for this SMS.
  final WalletEntity wallet;

  /// True when the system inferred the correct wallet and should persist
  /// the [SmsWalletMatchInput.subscriptionId] back to Firestore.
  final bool needsSubscriptionMapping;
}

/// Selects the correct wallet from a list of same-provider candidates.
///
/// Resolution priority:
///   1. `subscriptionId` exact match  — definitive when non-null.
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

  static SmsWalletMatchResult resolve({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    if (wallets.isEmpty) throw ArgumentError('wallets cannot be empty');

    // ── Signal 1: single wallet — trivial case ── //
    if (wallets.length == 1) {
      final wallet = wallets.first;
      final needsMapping = input.subscriptionId != null &&
          wallet.subscriptionId != input.subscriptionId;
      return SmsWalletMatchResult(
        wallet: wallet,
        needsSubscriptionMapping: needsMapping,
      );
    }

    // ── Signal 2: subscriptionId exact match ── //
    if (input.subscriptionId != null) {
      final exact = wallets
          .where((w) => w.subscriptionId == input.subscriptionId)
          .toList();
      if (exact.isNotEmpty) {
        return SmsWalletMatchResult(wallet: exact.first);
      }

      // No exact match: assign to an unassigned slot and learn.
      final unassigned =
          wallets.where((w) => w.subscriptionId == null).toList();
      if (unassigned.isNotEmpty) {
        return SmsWalletMatchResult(
          wallet: unassigned.first,
          needsSubscriptionMapping: true,
        );
      }
    }

    // ── Signal 3: balance-delta correlation ── //
    // subscriptionId is null (OEM bug) or all slots are claimed but no match.
    // Try to identify the wallet by checking whether the parsed post-transaction
    // balance is consistent with the stored running balance after applying the
    // transaction amount (± tax tolerance).
    final balanceMatch = _matchByBalanceDelta(
      wallets: wallets,
      input: input,
    );
    if (balanceMatch != null) {
      log(
        'Balance-delta identified wallet ${balanceMatch.id} '
        '(balance ${balanceMatch.currentBalance} → ${input.parsedBalance}).',
        name: _tag,
      );
      // If we also have a subscriptionId we can now learn the mapping.
      return SmsWalletMatchResult(
        wallet: balanceMatch,
        needsSubscriptionMapping: input.subscriptionId != null &&
            balanceMatch.subscriptionId != input.subscriptionId,
      );
    }

    // ── Signal 4: least-recently-used fallback ── //
    log(
      'No definitive signal found — falling back to LRU wallet.',
      name: _tag,
    );
    final sorted = List<WalletEntity>.from(wallets)
      ..sort((a, b) => a.lastBalanceAt.compareTo(b.lastBalanceAt));
    return SmsWalletMatchResult(
      wallet: sorted.first,
      needsSubscriptionMapping: input.subscriptionId != null &&
          sorted.first.subscriptionId != input.subscriptionId,
    );
  }

  // ── Balance-delta internal helper ──────────────────────────────────────────

  /// Returns the unique wallet whose `currentBalance` is consistent with
  /// the parsed SMS balance after applying the transaction amount and tax.
  ///
  /// Returns `null` if zero or multiple wallets match (ambiguous).
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

      // Expected balance after this transaction (ignoring tax).
      final expectedBase = type == TransactionType.receive
          ? cached + amount
          : cached - amount;

      // Tolerance window accounts for:
      //   receive: provider may deduct a service fee (unlikely but possible).
      //   send:    provider always deducts a transfer tax (≤ _maxTaxEgp).
      final lowerBound = type == TransactionType.receive
          ? expectedBase - _maxTaxEgp
          : expectedBase - _maxTaxEgp; // send tax already in amount subtraction
      final upperBound = expectedBase + _maxTaxEgp;

      if (parsedBalance >= lowerBound && parsedBalance <= upperBound) {
        matches.add(wallet);
      }
    }

    return matches.length == 1 ? matches.first : null;
  }
}
