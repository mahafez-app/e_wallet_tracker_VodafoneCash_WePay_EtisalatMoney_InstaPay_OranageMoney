# Firebase / Firestore Usage Report

Date: 2026-04-13
Project: `wallet_tracker`
Firestore location: `nam5`

## Official Spark plan limits checked

Source:
- https://firebase.google.com/pricing
- https://firebase.google.com/docs/firestore/pricing

Cloud Firestore free quota on Spark:
- 50,000 document reads / day
- 20,000 document writes / day
- 20,000 document deletes / day
- 1 GiB stored data
- 10 GiB outbound data transfer / month

Important billing rules used in this report:
- Quotas reset daily around midnight Pacific time.
- `set()` and `update()` each count as one write.
- `count()` has a minimum cost of one read.
- Query listeners charge a read when a document in the result set is added or updated.

## What the code is doing

### 1. A new transaction does not recompute wallet totals from history

Each saved transaction writes:
- 1 write to `wallets/{walletId}/transactions/{transactionId}`
- 1 write to `wallets/{walletId}`

The wallet document is updated with:
- `currentBalance`
- `totalReceived`
- `totalSent`
- `lastBalanceAt`

Reference:
- `lib/features/transactions/data/datasources/wallet_transaction_remote_data_source.dart`

This means wallet totals are pre-aggregated. That is good for cost.

### 2. Workspace totals are not recomputed from all transaction documents

Workspace totals shown in UI are derived from wallet documents, not from reading every transaction document.

Home dashboard:
- Watches user wallets
- Watches workspace membership
- Watches each workspace's linked wallets
- Sums `wallet.totalReceived`, `wallet.totalSent`, and `wallet.currentBalance`

References:
- `lib/features/home/data/datasources/home_remote_data_source.dart`
- `lib/features/home/data/repositories/home_repository_impl.dart`

Workspace details:
- Watches workspace
- Watches workspace members
- Watches linked wallets
- Computes `totalBalance`, `totalReceived`, and `totalSent` from wallet entities

References:
- `lib/features/workspaces/data/repositories/workspace_repository_impl.dart`
- `lib/features/workspaces/domain/entities/workspace_details_entity.dart`

Conclusion:
- Workspace totals do not read all historical transactions.
- Workspace totals depend on wallet document reads.

### 3. Recent workspace transactions preview is fan-out by wallet

Workspace recent transactions preview does this:
- for each linked wallet, query the latest `limit(5)` transactions
- merge all wallet results in memory
- sort them
- keep the final top 5

Reference:
- `lib/features/workspaces/data/datasources/workspace_transactions_preview_remote_service.dart`

If a workspace has 3 wallets:
- initial preview read can cost up to `3 * 5 = 15` transaction reads

If a workspace has 10 wallets:
- initial preview read can cost up to `10 * 5 = 50` transaction reads

This is the most expensive read pattern in the current design.

### 4. Workspace transaction list is paginated, but it still fans out by wallet

For workspace transactions page:
- it runs `count()` once per wallet
- it fetches wallet metadata once per wallet
- it fetches transaction batches per wallet
- it merges them client-side

Reference:
- `lib/features/transactions/data/datasources/workspace_transaction_remote_data_source.dart`

Approx first page read cost:
- `walletCount` reads for `count()`
- `walletCount` reads for wallet metadata
- `walletCount * 5` reads for first transaction batches when page size is 10
- `2 * pageSize` reads for per-item live watchers

Approx formula for first page:
- `7 * walletCount + 20`

For 3 wallets:
- about `41` reads for page 1

For 5 wallets:
- about `55` reads for page 1

### 5. Wallet transaction list is cheaper than workspace transaction list

For wallet transactions page:
- 1 read for wallet metadata
- 1 read minimum for `count()`
- `pageSize` reads for the page query
- `2 * pageSize` reads for per-item live watchers

Reference:
- `lib/features/transactions/data/datasources/wallet_transaction_remote_data_source.dart`
- `lib/features/transactions/data/datasources/transaction_watch_remote_data_source.dart`
- `lib/features/transactions/presentation/providers/transactions_controller_live_sync.dart`

Approx formula for first page:
- `2 + 3 * pageSize`

With page size 10:
- about `32` reads for page 1

### 6. Home screen uses several live listeners

Home screen activates a stream provider and keeps the SMS listener alive.

References:
- `lib/features/home/presentation/providers/home_dashboard_provider.dart`
- `lib/core/providers/sms_providers.dart`

Approx initial read cost when Home opens:
- 1 user profile doc
- `ownedWalletCount` wallet docs
- `workspaceCount` membership docs
- `workspaceCount` workspace docs
- `workspaceWalletLinksCount` workspace-wallet link docs
- `workspaceWalletLinksCount` wallet docs again through workspace listeners
- `pendingInviteCount` invite docs

Approx formula:
- `1 + ownedWalletCount + 2 * workspaceCount + 2 * workspaceWalletLinksCount + pendingInviteCount`

## 100 transactions/day scenario

Assumptions for the concrete example:
- 1 owner user
- 3 wallets
- 1 workspace
- workspace contains the same 3 wallets
- 2 workspace members
- 0 pending invites
- 100 incoming transactions per day
- 20 Home opens/day
- 10 Workspace Details opens/day
- 10 Wallet Details opens/day
- 10 Wallet Transactions page opens/day
- 10 Workspace Transactions page opens/day

### Writes per day

Incoming transactions:
- `100 transactions * 2 writes = 200 writes/day`

Spark write quota usage:
- `200 / 20,000 = 1%`

### Reads per day from browsing

Home opens:
- formula `1 + 3 + 2*1 + 2*3 + 0 = 12`
- `20 * 12 = 240 reads/day`

Workspace Details opens:
- formula `1 + 2*2 + 7*3 = 26`
- `10 * 26 = 260 reads/day`

Wallet Details opens:
- `1 wallet doc + 5 recent transactions = 6`
- `10 * 6 = 60 reads/day`

Wallet Transactions page opens:
- `10 * 32 = 320 reads/day`

Workspace Transactions page opens:
- `10 * 41 = 410 reads/day`

Subtotal browsing reads:
- `240 + 260 + 60 + 320 + 410 = 1,290 reads/day`

### Reads per day from transaction ingestion

Foreground SMS path:
- usually 0 Firestore reads per transaction for matching because wallets are already in memory

Background SMS path:
- about 1 wallet read per transaction if one wallet matches the provider query
- about `100 reads/day`

### Reads per day from live listeners while transactions arrive

If Home is open while transactions arrive:
- each transaction updates 1 wallet doc
- Home wallet listener sees that update
- workspace wallet listener also sees that update
- about `2 reads/transaction`

For 100 transactions while Home is active:
- about `200 extra reads/day`

### Estimated total daily usage in this scenario

Approx reads/day:
- `1,290 browsing`
- `100 background matching`
- `200 live updates`
- total about `1,590 reads/day`

Approx writes/day:
- `200 writes/day`

Spark quota usage:
- reads: `1,590 / 50,000 = 3.18%`
- writes: `200 / 20,000 = 1%`

Result:
- this scenario is comfortably inside the free Spark quota

## When would the free plan become a problem

### Writes

At 2 writes per transaction:
- write limit is reached around `10,000 transactions/day`

That is about 100x your 100-transactions/day scenario.

### Reads

Using the scenario above:
- `50,000 / 1,590 ≈ 31.4`

That means you have roughly 31x headroom on reads for that day shape.

Because Firestore free quota is daily, there is no "after N days the plan finishes" for reads/writes.
It resets every day.

## Storage outlook

Reads and writes will hit long before storage does.

At 100 transactions/day:
- `36,500 transactions/year`

If one transaction plus index overhead averages:
- 2 KB -> about 73 MB/year
- 4 KB -> about 146 MB/year

Very rough interpretation:
- 1 GiB free storage likely lasts several years even before counting that wallet/workspace docs are tiny compared with transactions

Notes:
- notes and history subcollections increase storage
- exact storage depends on document sizes and index overhead

## Important availability risk unrelated to Spark quota

Your current Firestore rules are still the temporary open rules:
- `allow read, write: if request.time < timestamp.date(2026, 5, 7);`

Reference:
- `firestore.rules`

As of 2026-04-13, that is 24 days away.

If you do not replace these rules before 2026-05-07:
- all client Firestore access will fail
- the app will become unavailable even if you are still far below Spark limits

This is the highest-risk availability issue in the project right now.

## Main conclusions

1. The project is not reading all transactions to compute wallet or workspace totals.
2. Wallet totals are efficiently pre-aggregated on the wallet document.
3. Workspace totals are derived from wallet documents, which is still acceptable for cost.
4. The biggest read cost comes from nested listeners and workspace transaction fan-out across wallets.
5. At 100 transactions/day, the current project should stay comfortably inside Spark free limits for normal single-user or small-team usage.
6. The app is more likely to break first because of the expiring Firestore rules than because of Spark quota exhaustion.

## Best next optimizations

1. Replace the temporary Firestore rules immediately.
2. Add stored workspace aggregates if you expect many wallets per workspace.
3. Replace workspace recent-transactions fan-out with a workspace-scoped transaction feed if workspaces get large.
4. Remove per-item transaction listeners on list screens if full live sync is not required.
5. Consider caching workspace member profile docs if the settings/details screens are opened frequently.
