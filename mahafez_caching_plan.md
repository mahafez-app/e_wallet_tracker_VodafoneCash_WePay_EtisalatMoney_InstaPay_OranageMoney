# Mahafez — Caching Architecture Plan

## Context

Full codebase read. Key findings that drive every decision below:

1. **`walletMeta()` is a hot-path Firestore read** called on every transaction fetch — once per wallet in workspace context, meaning a workspace with 3 wallets fires 3 extra document reads per page load.
2. **`transactionsControllerProvider` is `autoDispose`** — every back-navigation destroys accumulated pages and re-fetches from scratch. This is the primary UX pain point.
3. **Home dashboard uses `.snapshots()`** — already benefits from Firestore's built-in disk cache. No changes needed there.
4. **No local persistence exists** — all reads are network-first with no fallback.
5. **Workspace pagination is a custom merge-sort** (`_WorkspaceWalletTransactionState`) — any caching solution must be compatible with this; it rules out naive approaches.

---

## Architecture Overview

```
Presentation (TransactionsController)
    │
    ├── Phase 3: ref.keepAlive() — survives back-navigation
    │
Domain (TransactionRepository interface)
    │  unchanged
    │
Data (TransactionRepositoryImpl)
    │
    ├── Phase 4: TransactionCacheLocalDataSource (Hive)
    │     └── stale-while-revalidate for first page, wallet context only
    │
    ├── RemoteDataSources (existing)
    │
    └── TransactionFirestoreSupport
          └── Phase 2: WalletMetaCache (in-memory, TTL)
```

---

## Phase 1 — Firestore Persistence Configuration
**Effort:** 30 min | **Risk:** Zero | **Impact:** Streams get instant cache emit for free

Configure unlimited disk cache before any Firestore access. Currently `initializeApp()` initialises Firebase but never touches Firestore settings.

### `lib/core/di/app_initializer.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/result.dart';
import '../utils/execute_and_handle_errors.dart';
import '../../firebase_options.dart';

Future<Result<AppBootstrapDependencies>> initializeApp() {
  return executeAndHandleErrors(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Configure Firestore disk cache before any read/write.
      // This is a no-op if persistence was already enabled from a previous run.
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      return AppBootstrapDependencies(sharedPreferences: sharedPreferences);
    },
    tag: 'initializeApp',
    logName: 'Bootstrap',
  );
}
```

**What this buys you:** All `.snapshots()` calls (`watchUserWallets`, `watchUserWorkspaces`, `watchWorkspace`, `watchTransaction`, `getNotes`, `getTransactionHistory`) now emit a cached document instantly before the server response arrives. The home screen loads without any visible flash. Zero code changes elsewhere.

---

## Phase 2 — WalletMeta In-Memory Cache
**Effort:** 2–3 hours | **Risk:** Low | **Impact:** Eliminates N redundant Firestore reads per transaction page load

Every call to `walletMeta(walletId)` is a Firestore document read. For a workspace with 3 wallets, loading one page fires 3 wallet reads before the transaction query even starts. This happens on every filter change, every pagination, every detail screen open.

### New file: `lib/core/cache/wallet_meta_cache.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/enums/wallet_provider.dart';

final class WalletMeta {
  const WalletMeta({
    required this.provider,
    required this.phoneNumber,
    required this.ownerUid,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final String ownerUid;
}

final class _WalletMetaEntry {
  _WalletMetaEntry({required this.meta, required this.expiresAt});

  final WalletMeta meta;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// In-memory, TTL-based cache for wallet provider/phone/ownerUid.
/// Lives at the data layer — never crosses into domain.
/// 
/// Injected into [TransactionFirestoreSupport] to eliminate repeated
/// Firestore reads for data that almost never changes.
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

  /// Call after wallet delete or wallet update to force a fresh fetch.
  void invalidate(String walletId) => _store.remove(walletId);

  void clear() => _store.clear();
}
```

### Update `lib/features/transactions/data/datasources/transaction_firestore_support.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/cache/wallet_meta_cache.dart';           // new
import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../mappers/transaction_search_terms.dart';

class TransactionFirestoreSupport {
  const TransactionFirestoreSupport({
    required FirebaseFirestore firestore,
    required WalletMetaCache metaCache,                           // new
  })  : _firestore = firestore,
        _metaCache = metaCache;                                   // new

  final FirebaseFirestore _firestore;
  final WalletMetaCache _metaCache;                               // new

  // ... (existing helpers unchanged) ...

  Future<({WalletProvider provider, String phoneNumber, String ownerUid})>
  walletMeta(String walletId) async {
    // 1. Return from cache if still fresh
    final cached = _metaCache.get(walletId);
    if (cached != null) {
      return (
        provider: cached.provider,
        phoneNumber: cached.phoneNumber,
        ownerUid: cached.ownerUid,
      );
    }

    // 2. Fetch from Firestore, then populate cache
    final doc = await walletDocument(walletId).get();
    final wallet = WalletDto.fromFirestore(doc);
    _metaCache.put(
      walletId,
      WalletMeta(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        ownerUid: wallet.ownerUid,
      ),
    );

    return (
      provider: wallet.provider,
      phoneNumber: wallet.phoneNumber,
      ownerUid: wallet.ownerUid,
    );
  }
}
```

### Update `lib/features/transactions/providers/transactions_providers.dart`

```dart
import '../../../core/cache/wallet_meta_cache.dart';             // new

// ── Infrastructure ───────────────────────────────────────────────────────────

// Single shared cache instance — not autoDispose so it survives screen pops.
final walletMetaCacheProvider = Provider<WalletMetaCache>(
  (_) => WalletMetaCache(),
);

final transactionFirestoreSupportProvider =
    Provider<TransactionFirestoreSupport>(
      (ref) => TransactionFirestoreSupport(
        firestore: ref.watch(firestoreProvider),
        metaCache: ref.watch(walletMetaCacheProvider),           // new
      ),
    );

// ... rest unchanged ...
```

### Invalidate on wallet delete

In `WalletRepositoryImpl.deleteWallet`, after the remote delete completes, invalidate the cache entry:

```dart
@override
Future<Result<void>> deleteWallet(String walletId) {
  return executeAndHandleErrors(() async {
    await _remoteDataSource.deleteWallet(walletId);
    _metaCache.invalidate(walletId);                             // new
  }, tag: 'WalletRepositoryImpl.deleteWallet');
}
```

Wire `WalletMetaCache` into `WalletRepositoryImpl` via its provider in `wallets_providers.dart` — same pattern as existing dependencies.

---

## Phase 3 — TransactionsController Keep-Alive
**Effort:** 1–2 hours | **Risk:** Low | **Impact:** Eliminates re-fetch on every back-navigation

Currently `transactionsControllerProvider` is `autoDispose`. When the user opens transaction details and presses back, the controller is destroyed and the full page list is re-fetched. With keep-alive, the in-memory page list survives for the session.

### `lib/features/transactions/presentation/providers/transactions_controller.dart`

```dart
// Add to TransactionsController.build():

@override
TransactionsState build() {
  // Keep this controller alive for 5 minutes after the last listener drops.
  // Prevents re-fetch on back-navigation and filter changes that navigate away.
  final link = ref.keepAlive();
  Timer? disposeTimer;

  ref.onCancel(() {
    disposeTimer = Timer(const Duration(minutes: 5), () => link.close());
  });
  ref.onResume(() {
    disposeTimer?.cancel();
    disposeTimer = null;
  });
  ref.onDispose(() => disposeTimer?.cancel());

  bindTransactionUpdates();
  _scheduleInitialLoad();
  return const TransactionsState();
}
```

Add `import 'dart:async';` — already present in the file.

**Scope:** Apply the same pattern to `workspaceDetailsController` and `walletDetailsController`. The home dashboard uses `StreamProvider` with `.snapshots()` — Phase 1 already handles that via Firestore's cache.

---

## Phase 4 — Hive First-Page Cache (Stale-While-Revalidate)
**Effort:** 5–7 hours | **Risk:** Medium | **Impact:** Zero loading state on cold open

This eliminates the `isLoadingInitial = true` flash for the most common screen entry: wallet transactions with no filters. The user sees real data instantly while a background refresh happens silently.

Only implemented for **wallet context, no active filters** — the workspace merge-sort and filtered queries are too dynamic to cache reliably.

### New dependency in `pubspec.yaml`

```yaml
hive_flutter: ^1.1.0
```

No code generation needed — we store raw JSON strings.

### New file: `lib/features/transactions/data/datasources/transaction_cache_local_data_source.dart`

```dart
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/data/models/transaction_dto.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../models/transaction_page_dto.dart';

abstract interface class TransactionCacheLocalDataSource {
  Future<TransactionPageDto?> getFirstPage(String walletId);
  Future<void> saveFirstPage(String walletId, TransactionPageDto page);
  Future<void> clear(String walletId);
}

final class TransactionCacheLocalDataSourceImpl
    implements TransactionCacheLocalDataSource {
  static const String _boxName = 'tx_first_page_cache';
  static const String _metaKeySuffix = '__meta';
  // Cache entries older than this are ignored and overwritten.
  static const Duration _maxAge = Duration(hours: 24);

  late final Box<String> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<TransactionPageDto?> getFirstPage(String walletId) async {
    final metaRaw = _box.get(_metaKey(walletId));
    if (metaRaw == null) return null;

    final meta = jsonDecode(metaRaw) as Map<String, dynamic>;
    final cachedAt = DateTime.tryParse(meta['cachedAt'] as String? ?? '');
    if (cachedAt == null || DateTime.now().difference(cachedAt) > _maxAge) {
      await clear(walletId);
      return null;
    }

    final pageRaw = _box.get(walletId);
    if (pageRaw == null) return null;

    try {
      final json = jsonDecode(pageRaw) as Map<String, dynamic>;
      return _pageFromJson(json);
    } catch (_) {
      await clear(walletId);
      return null;
    }
  }

  @override
  Future<void> saveFirstPage(String walletId, TransactionPageDto page) async {
    // Never cache paginated pages or pages with cursors (those are filtered results).
    // Only cache the first page: totalCount + up to [limit] transactions.
    final json = jsonEncode(_pageToJson(page));
    final meta = jsonEncode({'cachedAt': DateTime.now().toIso8601String()});
    await _box.put(walletId, json);
    await _box.put(_metaKey(walletId), meta);
  }

  @override
  Future<void> clear(String walletId) async {
    await _box.delete(walletId);
    await _box.delete(_metaKey(walletId));
  }

  String _metaKey(String walletId) => '$walletId$_metaKeySuffix';

  // ── Serialization ──────────────────────────────────────────────────────────
  // We do NOT reuse TransactionDto.toFirestore() here — that writes Timestamps.
  // We serialize to plain JSON so Hive can store it as a String.

  Map<String, dynamic> _pageToJson(TransactionPageDto page) {
    return {
      'totalCount': page.totalCount,
      'transactions': page.transactions.map(_txToJson).toList(),
      // nextCursor is intentionally dropped — cached page is always treated
      // as page 1 and the controller will re-fetch page 2 from Firestore.
    };
  }

  Map<String, dynamic> _txToJson(TransactionDto tx) => {
    'id': tx.id,
    'walletId': tx.walletId,
    'amount': tx.amount,
    'type': tx.type.name,
    'counterpartyNumber': tx.counterpartyNumber,
    'isPaid': tx.isPaid,
    'createdAt': tx.createdAt.toIso8601String(),
    'provider': tx.provider.toValue,
    'phoneNumber': tx.phoneNumber,
    'ownerUid': tx.ownerUid,
    'rawSms': tx.rawSms,
  };

  TransactionPageDto _pageFromJson(Map<String, dynamic> json) {
    final txList = (json['transactions'] as List)
        .cast<Map<String, dynamic>>()
        .map(_txFromJson)
        .toList();
    return TransactionPageDto(
      transactions: txList,
      totalCount: json['totalCount'] as int,
      nextCursor: null, // always null from cache — see note above
    );
  }

  TransactionDto _txFromJson(Map<String, dynamic> json) => TransactionDto(
    id: json['id'] as String,
    walletId: json['walletId'] as String,
    amount: (json['amount'] as num).toDouble(),
    type: TransactionType.values.byName(json['type'] as String),
    counterpartyNumber: json['counterpartyNumber'] as String?,
    isPaid: json['isPaid'] as bool?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    provider: WalletProvider.fromString(json['provider'] as String),
    phoneNumber: json['phoneNumber'] as String,
    ownerUid: json['ownerUid'] as String,
    rawSms: json['rawSms'] as String?,
  );
}
```

### Update `lib/core/di/app_initializer.dart` — init Hive

```dart
// Inside the executeAndHandleErrors callback, after Firebase.initializeApp:
await TransactionCacheLocalDataSourceImpl().init();
// Or open the box here and pass it down via AppBootstrapDependencies.
// Prefer the latter so the box is testable.
```

### Update `TransactionRepositoryImpl` — stale-while-revalidate

Add `TransactionCacheLocalDataSource` as a constructor dependency (same pattern as existing data sources):

```dart
final class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required TransactionWatchRemoteDataSource transactionWatchRemoteDataSource,
    required WalletTransactionRemoteDataSource walletRemoteDataSource,
    required WorkspaceTransactionRemoteDataSource workspaceRemoteDataSource,
    required WorkspaceTransactionsOverviewRemoteDataSource workspaceOverviewRemoteDataSource,
    required TransactionCacheLocalDataSource cacheDataSource,    // new
  })  : _transactionWatchRemoteDataSource = transactionWatchRemoteDataSource,
        _walletRemoteDataSource = walletRemoteDataSource,
        _workspaceRemoteDataSource = workspaceRemoteDataSource,
        _workspaceOverviewRemoteDataSource = workspaceOverviewRemoteDataSource,
        _cacheDataSource = cacheDataSource;                      // new

  final TransactionCacheLocalDataSource _cacheDataSource;

  @override
  Future<Result<TransactionPage>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter = TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  }) => executeAndHandleErrors(() async {
    final result = await _walletRemoteDataSource.getWalletTransactions(
      walletId: walletId,
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
      limit: limit,
      cursor: cursor,
    );

    // Persist first page only when: no filters, no cursor (= first page).
    final isFirstPage = cursor == null;
    final hasNoFilters = type == null &&
        paidStatusFilter == TransactionPaidStatusFilter.all &&
        counterpartySuffixQuery == null &&
        dateRange == null;

    if (isFirstPage && hasNoFilters) {
      // Fire-and-forget — never block the return on a cache write.
      unawaited(_cacheDataSource.saveFirstPage(walletId, result));
    }

    return TransactionPage(
      transactions: result.transactions.map((e) => e.toEntity()).toList(),
      totalCount: result.totalCount,
      nextCursor: result.nextCursor,
    );
  }, tag: 'TransactionRepository.getWalletTransactions');
```

Add `import 'dart:async' show unawaited;` at the top.

### Invalidate on mutations

`saveTransaction` and `deleteTransaction` both mutate the transaction list. After each succeeds, invalidate the cache for that wallet:

```dart
@override
Future<Result<void>> saveTransaction(TransactionEntity transaction) =>
    executeAndHandleErrors(() async {
      await _walletRemoteDataSource.saveTransaction(transaction);
      unawaited(_cacheDataSource.clear(transaction.walletId)); // new
    }, tag: 'TransactionRepository.saveTransaction');

@override
Future<Result<void>> deleteTransaction({...}) =>
    executeAndHandleErrors(() async {
      await _walletRemoteDataSource.deleteTransaction(...);
      unawaited(_cacheDataSource.clear(walletId));             // new
    }, tag: 'TransactionRepository.deleteTransaction');
```

### Update the controller to show cached data before fetching

Add `isRefreshing` to `TransactionsState`:

```dart
final class TransactionsState extends Equatable {
  const TransactionsState({
    // ... existing fields ...
    this.isRefreshing = false,  // new: background refresh after cache hit
  });

  final bool isRefreshing;

  // Update copyWith and props accordingly.
}
```

In `_TransactionsControllerPagination.loadInitial`, inject the cache provider and perform a two-step load:

```dart
Future<void> loadInitial({required int requestId}) async {
  // Step 1: Try to show cached data immediately (no loading spinner).
  final shouldTryCache = arg is WalletTransactionsRouteData &&
      !state.hasActiveFilter &&
      state.nextCursor == null;

  if (shouldTryCache) {
    final cached = await ref.read(
      transactionFirstPageCacheProvider(
        (arg as WalletTransactionsRouteData).walletId,
      ),
    );
    if (cached != null && !isStaleRequest(requestId)) {
      state = state.copyWith(
        isLoadingInitial: false,
        isRefreshing: true,
        transactions: cached.transactions,
        totalCount: cached.totalCount,
        nextCursor: null,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoadingInitial: true,
        isLoadingMore: false,
        error: null,
        transactions: const [],
        totalCount: 0,
        nextCursor: null,
      );
    }
  } else {
    state = state.copyWith(
      isLoadingInitial: true,
      isLoadingMore: false,
      error: null,
      transactions: const [],
      totalCount: 0,
      nextCursor: null,
    );
  }

  // Step 2: Fetch from Firestore (always).
  switch (arg) {
    case WalletTransactionsRouteData():
      await loadWalletPage(arg as WalletTransactionsRouteData, isFirstPage: true, requestId: requestId);
    case WorkspaceTransactionsRouteData():
      await loadWorkspacePage(arg as WorkspaceTransactionsRouteData, isFirstPage: true, requestId: requestId);
  }
}
```

Add to `transactions_providers.dart`:

```dart
/// Reads the cached first page for a wallet without triggering a fetch.
/// Used by the controller to pre-populate the screen on cold open.
final transactionFirstPageCacheProvider =
    FutureProvider.autoDispose.family<TransactionPage?, String>(
  (ref, walletId) async {
    final cached = await ref
        .read(transactionCacheLocalDataSourceProvider)
        .getFirstPage(walletId);
    if (cached == null) return null;
    return TransactionPage(
      transactions: cached.transactions.map((e) => e.toEntity()).toList(),
      totalCount: cached.totalCount,
      nextCursor: null,
    );
  },
);
```

Wire `transactionCacheLocalDataSourceProvider` into `transactions_providers.dart` same as other data source providers.

---

## What Stays the Same

| Concern | Decision |
|---|---|
| `TransactionRepository` interface | Unchanged — no leaks into domain |
| Workspace merge-sort pagination | Unchanged — too dynamic to cache at phase 4 |
| `StreamProvider` home/workspace streams | Unchanged — Phase 1 handles these via Firestore persistence |
| `transactionUpdatesProvider` live sync | Unchanged — still handles in-list mutation updates |
| No `FetchStrategy` in domain | Correct — all caching decisions live in data layer |
| `executeAndHandleErrors` wrapper | Unchanged |

---

## Phased Checklist

```
Phase 1 — Firestore Persistence (30 min)
  [x] Configure Settings in app_initializer.dart

Phase 2 — WalletMeta Cache (2–3 hours)
  [ ] lib/core/cache/wallet_meta_cache.dart
  [ ] Update TransactionFirestoreSupport constructor + walletMeta()
  [ ] Add walletMetaCacheProvider to transactions_providers.dart
  [ ] Wire WalletMetaCache into WalletRepositoryImpl + invalidate on delete

Phase 3 — Controller Keep-Alive (1–2 hours)
  [ ] Add ref.keepAlive() + Timer to TransactionsController.build()
  [ ] Apply same pattern to WorkspaceDetailsController
  [ ] Apply same pattern to WalletDetailsController

Phase 4 — Hive First-Page Cache (5–7 hours)
  [ ] Add hive_flutter to pubspec.yaml
  [ ] lib/features/transactions/data/datasources/transaction_cache_local_data_source.dart
  [ ] Init Hive box in app_initializer.dart
  [ ] Update TransactionRepositoryImpl to write + invalidate cache
  [ ] Add isRefreshing to TransactionsState
  [ ] Update loadInitial() to two-step (cache-first, then remote)
  [ ] Add transactionFirstPageCacheProvider to transactions_providers.dart
  [ ] Add transactionCacheLocalDataSourceProvider to transactions_providers.dart
```

---

## Why Not Drift

The workspace merge-sort (`_WorkspaceWalletTransactionState`) crosses multiple Firestore collections that are owned by different wallets. Replicating this in SQLite requires a unified schema, delta-sync tracking per wallet, and a background sync daemon. That is 2–3 weeks of work and introduces schema migrations, foreign keys, and an entirely parallel data layer for what is a small-business tool with modest data volumes.

The four phases above deliver the same perceived performance (instant first paint, no re-fetch on back-navigation) with a fraction of the complexity, and they do not require touching the repository interface or the domain layer at all.

Drift is the right call if Mahafez grows to require full offline write support with conflict resolution. At that point, Phase 4's `TransactionCacheLocalDataSource` interface is already the right seam to swap Hive for Drift — the repository and above see no difference.
