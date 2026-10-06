import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

/// Hive box for locally deleted transaction tombstones.
/// Injected via [ProviderScope.overrides] in [AppBootstrap].
final deletedTransactionTombstonesBoxProvider = Provider<Box<String>>((_) {
  throw StateError(
    'deletedTransactionTombstonesBoxProvider was not overridden. '
    'Ensure AppBootstrap passes the opened Hive box via ProviderScope.overrides.',
  );
});
