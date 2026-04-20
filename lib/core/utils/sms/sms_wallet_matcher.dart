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

// ── Resolution result ─────────────────────────────────────────────────────────

/// Sealed result of wallet resolution.
///
/// Callers must handle all three variants:
/// - [SmsWalletMatchedResult]   — a wallet was confidently identified.
/// - [SmsWalletDefiniteMiss]    — the SMS structurally identifies a wallet
///   phone that does not match any known wallet; **discard silently**.
/// - [SmsWalletNoCandidate]     — resolution failed non-definitively;
///   the caller should enqueue for retry.
sealed class SmsWalletMatchResult {
  const SmsWalletMatchResult();
}

final class SmsWalletMatchedResult extends SmsWalletMatchResult {
  const SmsWalletMatchedResult(this.wallet);
  final WalletEntity wallet;
}

/// The SMS structurally implies a wallet phone number that does not exist
/// among the registered wallets. The transaction provably does not belong to
/// any known wallet — discard without retry.
final class SmsWalletDefiniteMiss extends SmsWalletMatchResult {
  const SmsWalletDefiniteMiss();
}

/// No confident match was found, but the miss is not definitive — could be a
/// transient state (wallets not yet loaded, balance stale, etc.).
/// Enqueue for retry.
final class SmsWalletNoCandidate extends SmsWalletMatchResult {
  const SmsWalletNoCandidate();
}

// ── Matcher ───────────────────────────────────────────────────────────────────

/// Selects the correct wallet from a list of same-provider candidates.
///
/// Resolution priority:
///   0. Derived wallet phone guard    — when the SMS mentions exactly 2 phone
///      numbers and one is the counterparty, the other is provably the wallet's
///      own number. If that number matches no candidate, returns
///      [SmsWalletDefiniteMiss]. If it matches one candidate exactly, returns
///      that wallet immediately.
///   1. Single wallet                 — trivial case.
///   2. Explicit wallet phone mention — matches the wallet number when the
///      provider includes it in the SMS body.
///   3. Balance-delta correlation     — uses parsed SMS balance to identify
///      which wallet's running total matches after the transaction.
///
/// Balance-delta tolerance is ±[_maxTaxEgp] EGP to absorb transfer taxes
/// (Egyptian providers charge up to 10 EGP per transaction).
class SmsWalletMatcher {
  SmsWalletMatcher._();

  static const _tag = 'SmsWalletMatcher';
  static const _maxBalanceDeltaToleranceEgp = 50.0;

  static SmsWalletMatchResult resolve({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    if (wallets.isEmpty) return const SmsWalletNoCandidate();

    // Step 0 — Derived wallet phone guard.
    //
    // When the SMS mentions phone numbers and we can unambiguously derive which
    // one is the wallet's own number (not the counterparty), apply a definite
    // miss / direct match before any further resolution.
    final guardResult = _applyDerivedWalletPhoneGuard(
      wallets: wallets,
      input: input,
    );
    if (guardResult != null) return guardResult;

    if (wallets.length == 1) {
      return SmsWalletMatchedResult(wallets.first);
    }

    final phoneMatch = _matchByMentionedWalletPhone(
      wallets: wallets,
      input: input,
    );
    if (phoneMatch != null) {
      log(
        'Explicit phone mention identified wallet ${phoneMatch.id}.',
        name: _tag,
      );
      return SmsWalletMatchedResult(phoneMatch);
    }

    final balanceMatch = _matchByBalanceDelta(wallets: wallets, input: input);
    if (balanceMatch != null) {
      log(
        'Balance-delta identified wallet ${balanceMatch.id} '
        '(balance ${balanceMatch.currentBalance} -> ${input.parsedBalance}).',
        name: _tag,
      );
      return SmsWalletMatchedResult(balanceMatch);
    }

    log('No definitive wallet signal found.', name: _tag);
    return const SmsWalletNoCandidate();
  }

  // ── Step 0 — Derived wallet phone guard ──────────────────────────────────

  /// Attempts to derive the wallet's own phone number from [mentionedPhoneNumbers]
  /// without any regex patterns:
  ///
  /// - **2 mentioned numbers, counterparty is one of them** → the other is
  ///   the wallet phone. Apply definite-miss or direct-match.
  /// - **1 mentioned number that is NOT the counterparty** → that number is
  ///   the wallet phone. Apply definite-miss or direct-match.
  /// - Any other combination → returns null (fall through to normal cascade).
  static SmsWalletMatchResult? _applyDerivedWalletPhoneGuard({
    required List<WalletEntity> wallets,
    required SmsWalletMatchInput input,
  }) {
    final derivedWalletPhone = _deriveWalletPhone(input);
    if (derivedWalletPhone == null) return null;

    final matching = wallets.where((w) {
      final normalized = EgyptianPhoneNumber.tryNormalizeMobile(w.phoneNumber);
      return normalized == derivedWalletPhone;
    }).toList();

    if (matching.isEmpty) {
      log(
        'Derived wallet phone $derivedWalletPhone matches no registered '
        'wallet — discarding SMS.',
        name: _tag,
      );
      return const SmsWalletDefiniteMiss();
    }

    if (matching.length == 1) {
      log(
        'Derived wallet phone $derivedWalletPhone uniquely matched wallet '
        '${matching.first.id}.',
        name: _tag,
      );
      return SmsWalletMatchedResult(matching.first);
    }

    // Multiple candidates share the same phone — unusual, fall through.
    log(
      'Derived wallet phone $derivedWalletPhone matched ${matching.length} '
      'wallets — continuing cascade.',
      name: _tag,
    );
    return null;
  }

  /// Derives the wallet's own phone number purely from the structure of
  /// [SmsWalletMatchInput.mentionedPhoneNumbers] and
  /// [SmsWalletMatchInput.counterpartyNumber].
  ///
  /// The only reliable derivation: when the SMS mentions exactly 2 phone
  /// numbers and the counterparty is unambiguously one of them, the other
  /// must be the wallet's own number.
  ///
  /// Returns null when the wallet phone cannot be unambiguously determined.
  static String? _deriveWalletPhone(SmsWalletMatchInput input) {
    final mentioned = input.mentionedPhoneNumbers;
    if (mentioned.length != 2) return null;

    final counterparty = EgyptianPhoneNumber.tryNormalizeMobile(
      input.counterpartyNumber,
    );
    if (counterparty == null) return null;

    final withoutCounterparty = mentioned
        .where((n) => n != counterparty)
        .toList();
    return withoutCounterparty.length == 1 ? withoutCounterparty.first : null;
  }

  // ── Step 2 — Explicit phone mention ─────────────────────────────────────────

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

  // ── Step 3 — Balance-delta ───────────────────────────────────────────────────

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

      // The expected local balance based purely on what the SMS reported
      final expectedCached = type == TransactionType.receive
          ? parsedBalance - amount
          : parsedBalance + amount;

      final difference = (cached - expectedCached).abs();
      matches.add((wallet: wallet, difference: difference));
    }

    if (matches.isEmpty) return null;

    // Sort by absolute nearest expected balance
    matches.sort((a, b) => a.difference.compareTo(b.difference));

    // If there is an exact tie in distance, we cannot safely decide via balance.
    if (matches.length > 1 && matches[0].difference == matches[1].difference) {
      return null;
    }

    if (matches.first.difference > _maxBalanceDeltaToleranceEgp) {
      return null;
    }

    return matches.first.wallet;
  }
}
