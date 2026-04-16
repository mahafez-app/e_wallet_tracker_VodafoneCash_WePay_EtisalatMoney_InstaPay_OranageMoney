# SMS Failed-Transaction Retry Plan

## Goal
Add a durable retry mechanism for SMS-derived transactions so that when an SMS is received but the transaction cannot be added due to no internet, transient backend failure, or app lifecycle interruption, the raw SMS is cached locally and retried later when:
1. the user opens the app
2. connectivity is restored

The implementation must avoid duplicate transactions and must not double-increment wallet balances.

---

## Core Problems Identified

1. Failed saves are only logged today, not persisted.
2. Wallet-resolution failures can drop an SMS permanently.
3. SMS parsing currently generates a random UUID, which makes retries create duplicate transaction documents.
4. Wallet balance updates are vulnerable to duplicate increments if the same transaction is saved more than once.
5. There is no persistent retry queue, no retry-on-app-open, and no retry-on-connectivity-restored flow.

---

## Required Outcome

Implement a persistent raw-SMS retry queue backed by Hive.

Retry flow should be:

raw SMS queued locally -> wallet/provider resolution -> parse transaction -> save transaction -> remove from queue on success

This queue must work for both:
- foreground SMS processing
- background SMS processing

---

## High-Level Architecture

### New Concept
Introduce a `PendingSmsRetryService` that stores failed SMS processing attempts in a Hive box and later retries them sequentially.

### Queue Item Should Store
Store the raw SMS and enough metadata to retry safely:
- queue item id
- sender
- body
- smsReceivedAt
- subscriptionId (if available)
- userUid
- walletId (optional if already known)
- providerName (optional if already known)
- retryCount
- lastError
- createdAt
- updatedAt

Important: do **not** store only a parsed transaction entity, because failures may happen before wallet resolution or parsing.

---

## Deterministic Transaction Identity

### Problem
The SMS parsing service currently generates a random UUID for each parsed transaction. This breaks retries because the same SMS gets a new transaction id every time.

### Required Change
Generate a deterministic transaction id from stable SMS inputs.

Use a stable fingerprint from fields such as:
- walletId
- normalized sender
- normalized body
- smsReceivedAt timestamp
- reference number if present

### Expected Result
The same SMS should always produce the same transaction id.

This makes transaction creation idempotent and prevents duplicates during retries.

---

## File-by-File Plan

### 1) Create a retry queue model
**New file**
- `lib/core/data/models/pending_sms_retry_item.dart`

### Responsibilities
- Define the model for queued failed SMS items
- Support serialization/deserialization for Hive storage
- Include fields required for retry processing

### Suggested fields
- `id`
- `sender`
- `body`
- `smsReceivedAt`
- `subscriptionId`
- `userUid`
- `walletId`
- `providerName`
- `retryCount`
- `lastError`
- `createdAt`
- `updatedAt`

### Notes
- Keep the model minimal and durable
- Prefer plain serializable values
- Add helper methods like `copyWith`

---

### 2) Create the retry service
**New file**
- `lib/core/services/pending_sms_retry_service.dart`

### Responsibilities
- Add failed SMS items to the queue
- Avoid duplicate queue entries for the same SMS
- Retry pending items sequentially
- Remove items on success
- Update retry count and last error on failure
- Guard against concurrent retry execution

### Required public methods
- `enqueue(...)`
- `retryPending()`
- `remove(...)`
- `markFailure(...)`
- optional: `generateQueueKey(...)`

### Behavior requirements
- Sequential retries only
- Use an internal `_isRetrying` flag
- Dedupe queue items using a deterministic queue key
- Retry should reconstruct the normal SMS processing path, not bypass business rules
- Keep failures persisted for later attempts

---

### 3) Register a Hive box for pending SMS retry items
**Update**
- `lib/core/di/app_initializer.dart`

### Required changes
- Open a new Hive box:
  - `pending_sms_retry_queue`
- Add this box to bootstrap dependencies

### Extend bootstrap dependency object
Add:
- `pendingSmsRetryBox`

---

### 4) Wire the retry box through bootstrap
**Update**
- `lib/app_bootstrap.dart`

### Required changes
- Pass the new `pendingSmsRetryBox` into dependency overrides/providers as needed

---

### 5) Expose the retry box/service through providers
**Update**
- `lib/core/providers/cache_providers.dart`

### Required changes
- Add a provider for the new Hive box:
  - `pendingSmsRetryBoxProvider`

**Update**
- `lib/core/providers/sms_providers.dart`

### Required changes
- Add a provider for `PendingSmsRetryService`
- Inject all dependencies it needs:
  - retry box
  - wallet lookup dependencies
  - parser
  - transaction save use case / repository
  - current user access if needed

---

### 6) Update foreground SMS flow to persist failures
**Update**
- `lib/core/services/sms_transaction_service.dart`

### Current issue
Foreground SMS flow only logs failure paths.

### Required changes
Inject:
- `PendingSmsRetryService pendingSmsRetryService`

### Change handling in SMS processing
When processing an SMS:
1. resolve wallet/provider
2. parse transaction
3. save transaction

If a recoverable failure happens at any step, enqueue the raw SMS.

### Must enqueue in these cases
- wallet/provider could not be resolved but may be resolvable later
- transaction save failed due to network/backend/transient issue

### Do not automatically enqueue unless intended
- parser returns null because SMS format is unsupported
- clearly invalid SMS unrelated to supported financial providers

### Save failure path
Any place that currently only logs something like "failed to save" should also enqueue the SMS.

---

### 7) Update background SMS flow to persist failures
**Update**
- `lib/core/services/background_sms_handler.dart`

### Current issue
Background handling also only logs failures and can lose SMS permanently.

### Required changes
On recoverable failures, enqueue the raw SMS locally.

### Must cover these cases
- user context exists but save fails
- wallet/provider resolution fails
- backend write throws
- temporary environment/network issue

### Important
If wallet cannot be resolved in background, do not drop the SMS. Queue it for retry.

---

### 8) Make SMS parsing generate deterministic transaction ids
**Update**
- `lib/core/utils/sms/sms_parsing_service.dart`

### Required changes
Replace random UUID creation with deterministic id generation.

### Implementation guidance
Create a helper such as:
- `String _generateDeterministicTransactionId(...)`

Use normalized values:
- trimmed/lowercased sender
- normalized body
- exact SMS timestamp
- walletId
- optional reference number

### Important
Keep normalization stable so the same SMS always produces the same id.

---

### 9) Make transaction saving idempotent
**Update**
- `lib/features/transactions/data/datasources/wallet_transaction_remote_data_source.dart`

### Current issue
Saving the same transaction again can increment wallet balances again.

### Required changes
Before applying balance increments:
1. check whether the transaction document already exists
2. if it exists, do not create it again and do not increment balances
3. if it does not exist, proceed with create + wallet updates

### Expected behavior
- same transaction id saved twice => no duplicate balance update
- retries remain safe

### Minimum safe approach
- read transaction doc by `transaction.id`
- short-circuit if already exists

---

### 10) Trigger retries when app opens
**Update**
- `lib/core/providers/sms_providers.dart`

### Required changes
After SMS system readiness is established and/or after listener startup, trigger:
- `pendingSmsRetryService.retryPending()`

### Goal
When the user opens the app, any previously failed SMS transactions should retry automatically.

---

### 11) Trigger retries when connectivity is restored
**New dependency**
- `connectivity_plus`

### Likely updates
- `pubspec.yaml`
- connectivity-related provider or service
- probably `lib/core/providers/sms_providers.dart` or a new connectivity provider/service

### Required behavior
Listen for connectivity restoration.
When internet becomes available:
- call `pendingSmsRetryService.retryPending()`

### Safeguards
- do not run multiple retries concurrently
- avoid retry storms
- only react on transition to connected state

---

## Recoverable vs Non-Recoverable Failures

### Recoverable: queue for retry
- no internet connection
- timeout
- Firebase unavailable
- temporary backend/network failure
- app interrupted before save completed
- wallet resolution failed due to timing/state sync issue

### Non-recoverable: log and skip
- unsupported SMS format
- clearly invalid message body
- permanently invalid wallet/provider mapping
- unrecoverable permission/configuration issue

If exact classification is hard initially, it is acceptable for version 1 to queue broadly except for clearly unsupported SMS.

---

## Retry Processing Rules

### The retry service should:
1. read pending items from Hive
2. process them one by one
3. reconstruct normal processing
4. remove item on success
5. increment retry count and store last error on failure
6. leave failed items in queue for future attempts

### Concurrency rules
- No parallel replay of queued items
- Use `_isRetrying` guard
- Avoid re-entrant calls from both app open and connectivity restore

### Dedupe rules
- One queue record per SMS fingerprint
- Re-enqueueing the same failed SMS should update the existing queue item instead of duplicating it

---

## Recommended Implementation Order

### Phase 1: Safety foundation
1. Create `PendingSmsRetryItem`
2. Create `PendingSmsRetryService`
3. Register Hive box and providers

### Phase 2: Idempotency
4. Make parsed transaction ids deterministic
5. Make remote transaction save idempotent

### Phase 3: Failure capture
6. Update foreground SMS flow to enqueue recoverable failures
7. Update background SMS flow to enqueue recoverable failures

### Phase 4: Retry triggers
8. Retry on app open
9. Retry on connectivity restored

### Phase 5: Hardening
10. Improve failure classification
11. Add retry backoff if needed
12. Add logs/telemetry for queue size and retry outcomes

---

## Acceptance Criteria

The implementation is correct only if all of the following are true:

1. If an SMS arrives while offline, it is stored locally and not lost.
2. When the user opens the app later with internet, the failed SMS is retried automatically.
3. When connectivity returns, queued SMS items retry automatically.
4. The same SMS does not create duplicate transactions.
5. The same SMS does not double-increment wallet balances.
6. Failures in both foreground and background paths are recoverable.
7. Unsupported SMS formats do not endlessly retry.
8. Queue items survive app restarts because storage is persistent.

---

## Suggested Test Scenarios

### Foreground tests
1. Receive valid SMS while online -> transaction saved immediately
2. Receive valid SMS while offline -> SMS queued
3. Open app online later -> queued SMS saved and removed
4. Same SMS retried twice -> only one transaction exists, wallet balance updated once

### Background tests
5. Background SMS received with temporary failure -> SMS queued
6. Open app later -> queued item processed successfully

### Idempotency tests
7. Same raw SMS parsed multiple times -> same transaction id
8. Remote save called twice with same transaction id -> wallet totals updated once only

### Edge cases
9. Unsupported SMS -> not queued indefinitely
10. Wallet missing temporarily -> queued and later retried
11. App restarted with pending queue -> queue still exists and processes later

---

## Implementation Notes for Gemini

- Keep changes minimal and localized.
- Reuse existing parsing and save flow instead of creating a second business path.
- Prefer deterministic ids and idempotent writes over ad-hoc duplicate checks.
- Use persistent storage for failed SMS queue; memory-only storage is not acceptable.
- Avoid changing unrelated transaction business logic.
- Preserve current behavior for successful SMS processing.
- Add logging around enqueue, retry success, retry failure, and queue removal.

---

## Final Summary

Implement a persistent failed-SMS retry queue using Hive, capture recoverable failures from both foreground and background SMS handlers, generate deterministic transaction ids from SMS content, protect transaction saving from duplicate balance increments, and trigger retries on app open and when connectivity is restored.
