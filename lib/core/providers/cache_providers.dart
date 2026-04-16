import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../cache/wallet_meta_cache.dart';

// ── Phase 2 — WalletMeta in-memory cache ─────────────────────────────────────

/// Single session-scoped [WalletMetaCache] instance.
///
/// Not autoDispose — must outlive individual screen navigations so the cache
/// survives back-presses and re-entries. Shared between
/// [TransactionFirestoreSupport] and [WalletRepositoryImpl] so that a wallet
/// delete in the wallets feature immediately invalidates entries used by the
/// transactions feature.
final walletMetaCacheProvider = Provider<WalletMetaCache>(
  (_) => WalletMetaCache(),
);

// ── Phase 4 — Hive box for tx first-page cache ────────────────────────────────

/// Hive box opened during app bootstrap and injected via
/// [ProviderScope.overrides] in [AppBootstrap].
///
/// Declared here as a throw-guard so any misconfiguration (forgetting the
/// override) surfaces immediately rather than silently using a null box.
final txFirstPageCacheBoxProvider = Provider<Box<String>>((_) {
  throw StateError(
    'txFirstPageCacheBoxProvider was not overridden. '
    'Ensure AppBootstrap passes the opened Hive box via ProviderScope.overrides.',
  );
});

/// Hive box for pending SMS retry items.
/// Injected via [ProviderScope.overrides] in [AppBootstrap].
final pendingSmsRetryBoxProvider = Provider<Box<String>>((_) {
  throw StateError(
    'pendingSmsRetryBoxProvider was not overridden. '
    'Ensure AppBootstrap passes the opened Hive box via ProviderScope.overrides.',
  );
});

