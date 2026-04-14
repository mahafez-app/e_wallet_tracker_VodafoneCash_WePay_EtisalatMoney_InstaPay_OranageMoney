/// In-memory, TTL-based cache for wallet provider / phone / ownerUid.
///
/// Lives entirely in the data layer — never crosses into domain.
/// Injected into [TransactionFirestoreSupport] to eliminate repeated
/// Firestore reads for data that almost never changes within a session.
final class WalletMetaCache {
  WalletMetaCache({Duration ttl = const Duration(minutes: 10)}) : _ttl = ttl;

  final Duration _ttl;
  final Map<String, _WalletMetaEntry> _store = {};

  WalletMeta? get(String walletId) {
    final entry = _store[walletId];
    if (entry == null || entry.isExpired) {
      _store.remove(walletId);
      return null;
    }
    return entry.meta;
  }

  void put(String walletId, WalletMeta meta) {
    _store[walletId] = _WalletMetaEntry(
      meta: meta,
      expiresAt: DateTime.now().add(_ttl),
    );
  }

  /// Invalidate after a wallet is deleted or updated to force a fresh fetch.
  void invalidate(String walletId) => _store.remove(walletId);

  void clear() => _store.clear();
}

// ── Value types ───────────────────────────────────────────────────────────────

/// Lightweight snapshot of wallet metadata needed for transaction hydration.
/// Kept deliberately minimal — only the fields queried in [TransactionDto].
final class WalletMeta {
  const WalletMeta({
    required this.provider,
    required this.phoneNumber,
    required this.ownerUid,
  });

  final String provider;
  final String phoneNumber;
  final String ownerUid;
}

// ── Private entry type ────────────────────────────────────────────────────────

final class _WalletMetaEntry {
  _WalletMetaEntry({required this.meta, required this.expiresAt});

  final WalletMeta meta;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
