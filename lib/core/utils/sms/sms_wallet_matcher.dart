import '../../domain/entities/wallet_entity.dart';

/// The result of attempting to match an SMS to a registered wallet.
class SmsWalletMatchResult {
  const SmsWalletMatchResult({
    required this.wallet,
    this.needsSubscriptionMapping = false,
  });

  /// The wallet that was matched for this SMS.
  final WalletEntity wallet;

  /// True if the system learned this was the correct wallet and the
  /// [wallet.id] needs to have [subscriptionId] updated in Firestore.
  final bool needsSubscriptionMapping;
}

/// Contains the shared logic for selecting the correct wallet from a list
/// of wallets for a specific provider, based on the SIM's subscription ID.
class SmsWalletMatcher {
  static SmsWalletMatchResult resolve({
    required List<WalletEntity> wallets,
    required int? subscriptionId,
  }) {
    if (wallets.isEmpty) {
      throw ArgumentError('wallets cannot be empty');
    }

    if (wallets.length == 1) {
      final wallet = wallets.first;
      final needsMapping =
          subscriptionId != null && wallet.subscriptionId != subscriptionId;
      return SmsWalletMatchResult(
        wallet: wallet,
        needsSubscriptionMapping: needsMapping,
      );
    }

    if (subscriptionId == null) {
      // Cannot map reliably without a subscription ID.
      return SmsWalletMatchResult(wallet: wallets.first);
    }

    final exactMatch = wallets
        .where((w) => w.subscriptionId == subscriptionId)
        .toList();
    if (exactMatch.isNotEmpty) {
      return SmsWalletMatchResult(wallet: exactMatch.first);
    }

    final unassigned = wallets.where((w) => w.subscriptionId == null).toList();
    if (unassigned.isNotEmpty) {
      return SmsWalletMatchResult(
        wallet: unassigned.first,
        needsSubscriptionMapping: true, // Needs update
      );
    }

    // Self-healing: if sizes didn't change but SIM cards did,
    // take the oldest used wallet.
    final sortedWallets = List<WalletEntity>.from(wallets)
      ..sort((a, b) => a.lastBalanceAt.compareTo(b.lastBalanceAt));

    return SmsWalletMatchResult(
      wallet: sortedWallets.first,
      needsSubscriptionMapping: true,
    );
  }
}
