# 📱 App Specification — E-Wallet Sync Tracker
> Agent prompt for Flutter app generation (Copilot / Gemini / Speckit)
> RTL-first (Arabic), English switchable, Clean Architecture, Riverpod, Firebase

---

## 🏷️ App Name Candidates
Choose one before generation starts — hardcode nothing until decided:

| Name | Arabic | Meaning |
|------|--------|---------|
| **Raseed** | رصيد | Balance — direct, everyone knows this word |
| **Hawel** | حوّل | Transfer — action-based |
| **Masraf** | مصرف | Wallet/bank — familiar |
| **Fulus** | فلوس | Money — casual, friendly |
| **Tahweel** | تحويل | Transfer — formal |

> Recommendation: **Raseed (رصيد)** — universally understood, short, works in both Arabic and English contexts.

The app name, package ID, and all branding strings must reference the chosen name. Zero hardcoded fallbacks to "family" or "wallet tracker".

---

## 🧭 Overview

A shared e-wallet transaction tracker. Multiple Android devices each listen to incoming SMS from Vodafone Cash and InstaPay, parse transactions automatically, and sync them in real-time to a shared Firebase backend. All family members — including iOS users — see all transactions, can mark received ones as paid/unpaid, add notes, and review full status history.

New required view: users can see all registered wallets (phone numbers/providers) with each wallet's latest known balance, and drill into all transactions linked to that wallet/provider/number.

---

## 🧩 SpecKit Development Phases

This plan is phase-based only (no time estimates). Each phase should be
implemented, reviewed, and accepted before moving to the next.

### Phase 0 — Foundation & Project Bootstrap
Goal: prepare stable architecture and tooling baseline before feature work.

Scope:
- Create clean architecture folders and core modules
- Configure localization (`ar`, `en`) and RTL/LTR support
- Configure theme system (system/light/dark)
- Configure Firebase project integration in app
- Configure static analysis, formatting, test scaffolding

Exit criteria:
- App boots on Android and iOS
- `flutter analyze` passes with zero issues
- Base router, theme, localization, and provider wiring are working

### Phase 1 — Authentication & User Profile Seed
Goal: enable secure sign-in and complete user profile identity fields.

Scope:
- Google Sign-In
- Email/Password Sign-In + Sign-Up
- Name confirmation step (`nameConfirmed` flow)
- Persist user profile in `users/{uid}`

Exit criteria:
- Auth session persists across app restarts
- First login always completes name confirmation
- `users/{uid}` doc is created/updated correctly

### Phase 2 — SMS Ingestion Pipeline (Android)
Goal: capture incoming SMS transactions and push normalized records.

Scope:
- SMS listener using `another_telephony` (Android only)
- Parser registry + pluggable format handlers
- Arabic numeral normalization
- Deduplication strategy via transaction document IDs
- Unrecognized SMS logging to `sms_unrecognized`

Exit criteria:
- Supported SMS samples produce valid transactions
- Duplicate SMS does not create duplicate transaction docs
- iOS builds compile with no telephony references

### Phase 3 — Transaction Storage, Sync, and Query Readiness
Goal: ensure Firestore model supports real-time views and scaling.

Scope:
- Finalize `transactions/{id}` shape
- Configure offline persistence behavior and validation
- Add required Firestore indexes for wallet/provider/date filters
- Validate security rules for read/create/update restrictions

Exit criteria:
- Offline write then reconnect sync works correctly
- Transaction queries used by UI are indexed and stable
- Rules allow intended operations and block forbidden ones

### Phase 4 — Core Transactions Experience
Goal: deliver Received/Sent tabs with operational workflows.

Scope:
- Received tab real-time stream + date grouping
- Sent tab real-time stream + read-only behavior
- Transaction cards (amount tier, source badge, wallet metadata)
- Status change interactions (paid/unpaid + undo)
- Detail bottom sheet sections (header, parties, status, history, notes, SMS deep link)

Exit criteria:
- Received/Sent flows are fully usable end-to-end
- Status history and notes are persisted correctly
- UI renders localized strings and proper RTL/LTR behavior

### Phase 5 — Wallets Feature (New)
Goal: provide wallet-level monitoring and wallet-scoped transaction exploration.

Scope:
- Wallets tab in bottom navigation
- Wallet summary cards: wallet number, provider, latest known balance,
  last operation date, transaction count
- Wallet Transaction Explorer screen
- Filtering by provider and direction inside wallet explorer

Exit criteria:
- All registered wallets appear from transaction-derived grouping
- Each wallet displays latest known balance from latest balance-bearing SMS
- Tapping wallet opens full wallet-linked transaction list

### Phase 6 — Settings, Preferences, and Cross-Device Consistency
Goal: finish user controls and persistence behavior.

Scope:
- Edit display name
- Edit wallet number (Android) / iOS info state
- Language and theme pickers
- Preference persistence in local storage and Firestore
- Sign-out flow

Exit criteria:
- Preference changes apply immediately and survive restart/reinstall
- Profile updates reflect in both Firebase Auth and Firestore

### Phase 7 — Quality Hardening & Release Readiness
Goal: ship confidence with tests, performance checks, and regression safety.

Scope:
- Unit tests for use cases and repositories
- Provider tests for success/failure paths
- Parser fixture tests for all supported SMS formats
- Manual verification matrix (Android SMS paths + iOS read-only paths)

Exit criteria:
- `flutter analyze` zero issues
- Test suite passes
- Security rules and key user journeys verified end-to-end

### Phase Dependency Order
1. Phase 0 -> Phase 1 -> Phase 2 -> Phase 3 -> Phase 4 -> Phase 5 ->
   Phase 6 -> Phase 7
2. Phase 5 depends on Phase 3 and Phase 4 data/query outputs.
3. No phase is marked done unless its exit criteria are satisfied.

---

## 🏗️ Technical Governance Source

Architecture, layering, state management, routing, theming, UI, serialization,
error handling, dependency policy, and testing standards are governed by the
`.claude/rules/` files and related skills in `.claude/skills/`.

This plan focuses on product scope, behavior, data contracts, and delivery
phases only.

---

## 🔐 Authentication

### Strategy
Two sign-in options on the login screen:
1. **Continue with Google** (primary, preferred — one tap, no typing)
2. **Email & Password** (secondary — for users without Google account)

Both use Firebase Auth. Both go through the same post-auth name-confirmation step.

### Sign-in Flow
```
App Launch
  └── Firebase Auth currentUser != null?
        ├── YES → go to Home (session persists indefinitely)
        └── NO  → Login Screen
                  ├── [Continue with Google] button
                  └── [Email / Password] fields + Sign In / Sign Up buttons

After any successful sign-in or sign-up:
  └── Name Confirmation Step (shown once — controlled by nameConfirmed flag)
        ├── Pre-filled with Google displayName (if Google auth)
        ├── Empty field (if email auth)
        └── User edits name → confirms
              └── Update Firebase Auth displayName + Firestore users doc
              └── Set nameConfirmed = true
              └── Navigate to Home
```

### Name Confirmation Screen
- Single text field: `اسمك / Your Name`
- Pre-filled from `FirebaseAuth.instance.currentUser?.displayName`
- User can edit freely
- `تأكيد / Confirm` button → updates name in Firebase Auth profile + Firestore
- Shown **once** — skipped if `users/{uid}.nameConfirmed == true`

### Session Persistence
- Firebase Auth default persistence (`LOCAL`) — session survives app restarts indefinitely
- No manual credential storage needed
- Sign-out only on explicit user action in Settings

### Firestore `users/{uid}`
```
displayName     : String
walletNumber    : String?   — Android only, null on iOS
isAndroid       : bool
nameConfirmed   : bool      — skip name screen after first time
preferredLocale : String    — 'system' | 'ar' | 'en'
preferredTheme  : String    — 'system' | 'light' | 'dark'
createdAt       : Timestamp
```

---

## 📩 SMS Parsing Architecture

### Core Principle: Pluggable Format Registry
Adding a new SMS format = create one file + register it. Nothing else changes.

```dart
// core/sms/sms_format.dart
abstract class SmsFormat {
  bool matches(String sender, String body);

  Transaction? parse({
    required String sender,
    required String body,
    required int smsId,
    required String walletNumber,
    required String receivedByName,
    required String receivedByUid,
  });
}
```

```dart
// core/sms/sms_parser_registry.dart
class SmsParserRegistry {
  SmsParserRegistry._();
  static final instance = SmsParserRegistry._();

  final List<SmsFormat> _formats = [];

  void registerAll(List<SmsFormat> formats) => _formats.addAll(formats);
  void register(SmsFormat format) => _formats.add(format);

  Transaction? parse({
    required String sender,
    required String body,
    required int smsId,
    required String walletNumber,
    required String receivedByName,
    required String receivedByUid,
  }) {
    final normalizedBody = ArabicNumeralNormalizer.normalize(body);
    for (final format in _formats) {
      if (format.matches(sender, normalizedBody)) {
        final result = format.parse(
          sender: sender,
          body: normalizedBody,
          smsId: smsId,
          walletNumber: walletNumber,
          receivedByName: receivedByName,
          receivedByUid: receivedByUid,
        );
        if (result != null) return result;
      }
    }
    _logUnrecognized(sender, body);
    return null;
  }

  void _logUnrecognized(String sender, String body) {
    FirebaseFirestore.instance.collection('sms_unrecognized').add({
      'sender': sender,
      'body': body,
      'at': FieldValue.serverTimestamp(),
    });
  }
}
```

```dart
// main.dart — register all formats once at startup
SmsParserRegistry.instance.registerAll([
  VfCashArabicReceivedFormat(),
  VfCashArabicSentFormat(),
  VfCashEnglishFormat(),
  InstaPayArabicReceivedFormat(),
  InstaPayArabicSentFormat(),
]);
```

---

### Format 1 — VF Cash Arabic Received
**Sender IDs:** `VF-Cash`, `Vodafone`, `1510`

**Real production SMS:**
```
تم استلام مبلغ 500.00 جنيه من رقم 01102564881 المسجل بإسم Ezzeldin F Mohamed رصيدك الحالي 4277.33 تاريخ العملية 05-04-26 16:49 رقم العملية 018925943091.
```

```dart
class VfCashArabicReceivedFormat implements SmsFormat {
  static final _regex = RegExp(
    r'تم استلام مبلغ\s+([\d.]+)\s+جنيه\s+من رقم\s+(\d+)\s+المسجل بإسم\s+(.+?)\s+رصيدك الحالي\s+([\d.]+)\s+تاريخ العملية\s+(\d{2}-\d{2}-\d{2}\s+\d{2}:\d{2})\s+رقم العملية\s+(\d+)',
  );

  @override
  bool matches(String sender, String body) =>
      ['VF-Cash', 'Vodafone', '1510'].any(sender.contains) &&
      body.contains('تم استلام');

  @override
  Transaction? parse({required String sender, required String body,
      required int smsId, required String walletNumber,
      required String receivedByName, required String receivedByUid}) {
    final m = _regex.firstMatch(body);
    if (m == null) return null;
    return Transaction(
      id: m.group(6)!,
      smsId: smsId,
      source: TransactionSource.vodafoneCash,
      direction: TransactionDirection.received,
      amount: double.parse(m.group(1)!),
      counterpartyPhone: m.group(2)!,
      counterpartyName: m.group(3)!.trim(),
      balanceAfter: double.parse(m.group(4)!),
      operationDate: _parseDate(m.group(5)!),
      operationId: m.group(6)!,
      walletNumber: walletNumber,
      receivedByName: receivedByName,
      receivedByUid: receivedByUid,
    );
  }

  // Date format in SMS: "05-04-26 16:49" = DD-MM-YY HH:mm
  DateTime _parseDate(String raw) {
    final parts = raw.trim().split(RegExp(r'[\s\-:]'));
    return DateTime(
      2000 + int.parse(parts[2]),  // YY → YYYY
      int.parse(parts[1]),          // MM
      int.parse(parts[0]),          // DD
      int.parse(parts[3]),          // HH
      int.parse(parts[4]),          // mm
    );
  }
}
```

---

### Format 2 — VF Cash Arabic Sent
**Real production SMS:**
```
تم تحويل 500 جنيه لرقم 01034970670 مصاريف الخدمة 0 جنيه رصيد حسابك فى فودافون كاش الحالي 3777.33.
```

```dart
class VfCashArabicSentFormat implements SmsFormat {
  static final _regex = RegExp(
    r'تم تحويل\s+([\d.]+)\s+جنيه\s+لرقم\s+(\d+)\s+مصاريف الخدمة\s+([\d.]+)\s+جنيه\s+رصيد حسابك فى فودافون كاش الحالي\s+([\d.]+)',
  );

  @override
  bool matches(String sender, String body) =>
      ['VF-Cash', 'Vodafone', '1510'].any(sender.contains) &&
      body.contains('تم تحويل');

  @override
  Transaction? parse({required String sender, required String body,
      required int smsId, required String walletNumber,
      required String receivedByName, required String receivedByUid}) {
    final m = _regex.firstMatch(body);
    if (m == null) return null;
    return Transaction(
      id: 'vf_sent_${walletNumber}_$smsId',
      smsId: smsId,
      source: TransactionSource.vodafoneCash,
      direction: TransactionDirection.sent,
      amount: double.parse(m.group(1)!),
      counterpartyPhone: m.group(2)!,
      serviceFee: double.parse(m.group(3)!),
      balanceAfter: double.parse(m.group(4)!),
      // No date in this SMS format — use SMS delivery time
      operationDate: DateTime.now(),
      walletNumber: walletNumber,
      receivedByName: receivedByName,
      receivedByUid: receivedByUid,
    );
  }
}
```

---

### Format 3 — VF Cash English (Received + Sent)
**Real production SMS:**
```
Mar 22, 2026 11:37:20 AM: Received EGP150 from 00201140932674 to Mobile Account Number 2111. Ref: 018586711473 Available Balance: 1093.33
```

```dart
class VfCashEnglishFormat implements SmsFormat {
  static final _regex = RegExp(
    r'(\w+ \d+, \d{4} \d+:\d+:\d+ [AP]M):\s*(Received|Sent)\s+EGP([\d.]+)\s+(?:from|to)\s+([\d+]+).*?Ref:\s+(\d+)\s+Available Balance:\s+([\d.]+)',
    caseSensitive: false,
  );

  @override
  bool matches(String sender, String body) =>
      ['VF-Cash', 'Vodafone', '1510'].any(sender.contains) &&
      body.contains('EGP') &&
      (body.contains('Received') || body.contains('Sent'));

  @override
  Transaction? parse({required String sender, required String body,
      required int smsId, required String walletNumber,
      required String receivedByName, required String receivedByUid}) {
    final m = _regex.firstMatch(body);
    if (m == null) return null;
    final isReceived = m.group(2)!.toLowerCase() == 'received';
    return Transaction(
      id: m.group(5)!,
      smsId: smsId,
      source: TransactionSource.vodafoneCash,
      direction: isReceived ? TransactionDirection.received : TransactionDirection.sent,
      amount: double.parse(m.group(3)!),
      counterpartyPhone: m.group(4)!,
      balanceAfter: double.parse(m.group(6)!),
      operationDate: DateFormat('MMM dd, yyyy hh:mm:ss a').parse(m.group(1)!.trim()),
      operationId: m.group(5)!,
      walletNumber: walletNumber,
      receivedByName: receivedByName,
      receivedByUid: receivedByUid,
    );
  }
}
```

---

### Format 4 — InstaPay Arabic Received
**Expected format:**
```
تم استلام مبلغ 200.00 جنيه من حساب InstaPay الخاص بـ سارة محمد
رقم العملية: 123456789
```

```dart
class InstaPayArabicReceivedFormat implements SmsFormat {
  static final _bodyRegex = RegExp(
    r'تم استلام مبلغ\s+([\d.]+)\s+جنيه\s+من حساب InstaPay الخاص بـ\s+(.+?)(?:\n|رقم العملية|$)',
    caseSensitive: false,
  );
  static final _refRegex = RegExp(r'رقم العملية[:\s]+(\d+)');

  @override
  bool matches(String sender, String body) =>
      ['InstaPay', 'INSTAPAY'].any(
          (s) => sender.toLowerCase().contains(s.toLowerCase())) &&
      body.contains('تم استلام');

  @override
  Transaction? parse({required String sender, required String body,
      required int smsId, required String walletNumber,
      required String receivedByName, required String receivedByUid}) {
    final m = _bodyRegex.firstMatch(body);
    if (m == null) return null;
    final ref = _refRegex.firstMatch(body)?.group(1) ?? 'ip_recv_${walletNumber}_$smsId';
    return Transaction(
      id: ref,
      smsId: smsId,
      source: TransactionSource.instaPay,
      direction: TransactionDirection.received,
      amount: double.parse(m.group(1)!),
      counterpartyName: m.group(2)!.trim(),
      operationId: ref,
      operationDate: DateTime.now(),
      walletNumber: walletNumber,
      receivedByName: receivedByName,
      receivedByUid: receivedByUid,
    );
  }
}
```

---

### Format 5 — InstaPay Arabic Sent
**Expected format:**
```
تم إرسال مبلغ 300.00 جنيه إلى سارة محمد عبر InstaPay
رقم العملية: 987654321
```

```dart
class InstaPayArabicSentFormat implements SmsFormat {
  static final _bodyRegex = RegExp(
    r'تم إرسال مبلغ\s+([\d.]+)\s+جنيه\s+إلى\s+(.+?)\s+عبر InstaPay',
    caseSensitive: false,
  );
  static final _refRegex = RegExp(r'رقم العملية[:\s]+(\d+)');

  @override
  bool matches(String sender, String body) =>
      ['InstaPay', 'INSTAPAY'].any(
          (s) => sender.toLowerCase().contains(s.toLowerCase())) &&
      body.contains('تم إرسال');

  @override
  Transaction? parse({required String sender, required String body,
      required int smsId, required String walletNumber,
      required String receivedByName, required String receivedByUid}) {
    final m = _bodyRegex.firstMatch(body);
    if (m == null) return null;
    final ref = _refRegex.firstMatch(body)?.group(1) ?? 'ip_sent_${walletNumber}_$smsId';
    return Transaction(
      id: ref,
      smsId: smsId,
      source: TransactionSource.instaPay,
      direction: TransactionDirection.sent,
      amount: double.parse(m.group(1)!),
      counterpartyName: m.group(2)!.trim(),
      operationId: ref,
      operationDate: DateTime.now(),
      walletNumber: walletNumber,
      receivedByName: receivedByName,
      receivedByUid: receivedByUid,
    );
  }
}
```

> **To add a new format later:** create a file in `core/sms/formats/`, implement `SmsFormat`, register it in `main.dart`. Nothing else changes.

---

### Arabic Numeral Normalizer
```dart
// core/utils/arabic_numeral_normalizer.dart
class ArabicNumeralNormalizer {
  static const _arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

  static String normalize(String input) {
    var result = input;
    for (int i = 0; i < _arabicDigits.length; i++) {
      result = result.replaceAll(_arabicDigits[i], '$i');
    }
    return result;
  }
}
```

---

## 📲 SMS Listener (Android Only)

### Package
Use `another_telephony` — NOT `telephony` (deprecated and broken).

### Background Handler
```dart
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();

  final transaction = SmsParserRegistry.instance.parse(
    sender: message.address ?? '',
    body: message.body ?? '',
    smsId: message.id ?? 0,
    walletNumber: prefs.getString('wallet_number') ?? '',
    receivedByName: prefs.getString('owner_name') ?? '',
    receivedByUid: prefs.getString('owner_uid') ?? '',
  );

  if (transaction == null) return;

  // Firestore offline persistence queues this if no internet.
  // Syncs automatically when reconnected.
  // operationDate is parsed from SMS body — not affected by sync delay.
  await FirebaseFirestore.instance
      .collection('transactions')
      .doc(transaction.id)
      .set(transaction.toMap(), SetOptions(merge: false));
}
```

### Registration in main()
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  SmsParserRegistry.instance.registerAll([
    VfCashArabicReceivedFormat(),
    VfCashArabicSentFormat(),
    VfCashEnglishFormat(),
    InstaPayArabicReceivedFormat(),
    InstaPayArabicSentFormat(),
  ]);

  if (Platform.isAndroid) {
    AnotherTelephony.instance.listenIncomingSms(
      onNewMessage: (msg) => backgroundSmsHandler(msg),
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
  }

  runApp(const ProviderScope(child: App()));
}
```

### iOS Guard
All telephony code must be inside `Platform.isAndroid` checks or conditional imports. iOS build must compile cleanly with zero telephony references.

---

## 🔄 Offline & Reconnection

Firestore offline persistence handles this automatically:
- SMS arrives, no internet → handler writes to Firestore → queued in local cache
- Internet restored → Firestore syncs the queued write to server automatically
- `operationDate` is parsed from SMS content at parse time — it is never affected by when the sync happens
- No custom queue, no retry logic needed

---

## 🗄️ Firestore Schema

### `transactions/{id}`
```
id                : String    — operationId from SMS, or smsId-based fallback
smsId             : int?      — Android SMS _id (dedup + deep link)
source            : String    — 'vodafone_cash' | 'instapay'
direction         : String    — 'received' | 'sent'
amount            : double
serviceFee        : double    — default 0.0
balanceAfter      : double
counterpartyName  : String?
counterpartyPhone : String?
walletNumber      : String    — which device/SIM captured this
receivedByName    : String    — display name of device owner
receivedByUid     : String    — Firebase Auth UID of device owner
operationId       : String?
operationDate     : Timestamp — parsed from SMS body — SHOWN IN UI
createdAt         : Timestamp — serverTimestamp — NOT shown in UI
status            : String?   — 'unpaid' | 'paid' — null for sent
markedByName      : String?
markedByUid       : String?
markedAt          : Timestamp?
notes             : Array<NoteObject>
statusHistory     : Array<StatusHistoryEntry>
```

### Wallet Summary Source Of Truth
- No separate `wallets` collection is required initially.
- Wallet list is derived from distinct `walletNumber` values in `transactions`.
- Wallet total/balance is derived from the latest transaction that has `balanceAfter` for that wallet.
- For providers that do not include balance in SMS, show `غير متاح / Not available` until a balance-bearing SMS exists.
- Store and query provider per transaction (already in `source`) so wallet summary and filters can include provider context.

### Wallet Summary Query Strategy
1. Fetch transactions ordered by `operationDate desc` (paged).
2. Group in-memory by `walletNumber` (and optionally `source` for provider split view).
3. First row per group becomes `latestTransaction`.
4. Wallet card fields:
  - walletNumber
  - provider/source (Vodafone Cash / InstaPay / mixed)
  - latestKnownBalance = latest transaction `balanceAfter` if present
  - lastOperationDate
  - transactionCount
5. Tapping wallet card opens filtered transactions list for that wallet.

### Recommended Composite Indexes
- `transactions`: `walletNumber ASC, operationDate DESC`
- `transactions`: `source ASC, operationDate DESC`
- `transactions`: `walletNumber ASC, source ASC, operationDate DESC`

### NoteObject (inline array)
```
id         : String   — UUID v4
text       : String
authorName : String
authorUid  : String
createdAt  : Timestamp
updatedAt  : Timestamp
```

### StatusHistoryEntry (inline array, append-only)
```
from   : String    — 'unpaid' | 'paid'
to     : String
byName : String
byUid  : String
at     : Timestamp
```

### Deduplication Logic
1. VF Cash received → doc ID = `operationId` (unique Ref number in SMS)
2. VF Cash sent Arabic → no operationId in SMS → doc ID = `vf_sent_{walletNumber}_{smsId}`
3. VF Cash English → doc ID = `Ref` number
4. InstaPay → doc ID = operationId if present, else `ip_{direction}_{walletNumber}_{smsId}`
5. `merge: false` on `set()` — if doc already exists, write is silently ignored

---

## 📲 SMS Deep Link

When a transaction was captured by this device's wallet number, show an "Open SMS" button in the detail sheet.

```dart
// core/utils/sms_deep_link.dart
class SmsDeepLink {
  static bool canOpen({
    required Transaction tx,
    required String? deviceWalletNumber,
  }) =>
      Platform.isAndroid &&
      deviceWalletNumber != null &&
      tx.walletNumber == deviceWalletNumber &&
      (tx.smsId ?? 0) > 0;

  static Future<void> openSms(int smsId) async {
    if (!Platform.isAndroid) return;
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'content://sms/$smsId',
    );
    await intent.launch();
  }
}
```

---

## 🎨 Theme & Locale

Both default to system setting. Both are user-overridable in Settings.

```dart
MaterialApp.router(
  themeMode: ref.watch(themeModeProvider),
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  locale: ref.watch(localeProvider),          // null = system
  supportedLocales: const [Locale('ar'), Locale('en')],
  localizationsDelegates: AppLocalizations.localizationsDelegates,
)
```

Preference persistence:
1. Riverpod provider → instant UI update
2. `SharedPreferences` → survives restart
3. Firestore `users/{uid}` → survives reinstall / new device login

---

## 📊 Domain Models

```dart
class Transaction extends Equatable {
  final String id;
  final int? smsId;
  final TransactionSource source;
  final TransactionDirection direction;
  final double amount;
  final double serviceFee;
  final double balanceAfter;
  final String? counterpartyName;
  final String? counterpartyPhone;
  final String walletNumber;
  final String receivedByName;
  final String receivedByUid;
  final String? operationId;
  final DateTime operationDate;       // from SMS — shown in UI
  final DateTime createdAt;           // server timestamp — NOT shown in UI
  final TransactionStatus? status;    // null for sent
  final String? markedByName;
  final String? markedByUid;
  final DateTime? markedAt;
  final List<TransactionNote> notes;
  final List<StatusHistoryEntry> statusHistory;

  AmountTier get amountTier => AmountTier.fromAmount(amount);
}

enum TransactionSource { vodafoneCash, instaPay }
enum TransactionDirection { received, sent }
enum TransactionStatus { unpaid, paid }

enum AmountTier {
  low,      // < 1,000 EGP
  medium,   // 1,000 – 4,999 EGP
  high,     // 5,000 – 9,999 EGP
  veryHigh; // >= 10,000 EGP

  static AmountTier fromAmount(double amount) {
    if (amount < 1000) return low;
    if (amount < 5000) return medium;
    if (amount < 10000) return high;
    return veryHigh;
  }
}

class TransactionNote extends Equatable {
  final String id;        // UUID v4
  final String text;
  final String authorName;
  final String authorUid;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class StatusHistoryEntry extends Equatable {
  final TransactionStatus from;
  final TransactionStatus to;
  final String byName;
  final String byUid;
  final DateTime at;
}
```

---

## 🖥️ UI Specification

### Navigation
```
Bottom Nav:
  Tab 0 (default): 📥 المستلم / Received
  Tab 1:           📤 المرسل / Sent
  Tab 2:           👛 المحافظ / Wallets
AppBar trailing:   Settings icon
```

### Wallets Tab (New)
- Real-time wallet summary list built from `transactions` stream/query
- Each wallet card displays:
  - Wallet number (phone number)
  - Provider label (Vodafone Cash / InstaPay / Mixed)
  - Latest known balance (`balanceAfter` from latest SMS transaction)
  - Last transaction date/time
  - Total transactions count for this wallet
- Search/filter controls:
  - By wallet number
  - By provider
- Sort options:
  - Last activity (default)
  - Highest balance
  - Most transactions
- Tap wallet card -> Wallet Transaction Explorer screen

### Wallet Transaction Explorer (New)
- Shows all transactions linked to selected wallet number
- Secondary chips/filters inside screen:
  - All
  - Vodafone Cash only
  - InstaPay only
  - Received only
  - Sent only
- Reuses existing transaction card and detail bottom sheet behavior
- Title example: `01102564881 · جميع العمليات`
- Empty state when no transactions match current filter

### Received Tab
- Real-time Firestore stream (Riverpod `StreamProvider`)
- Grouped by `operationDate`: Today / Yesterday / DD/MM/YYYY
- Each transaction card:
  - Counterparty name + phone
  - Amount + AmountTier colored chip
  - Source badge: `فودافون كاش` | `InstaPay`
  - Wallet number + received-by name
  - `operationDate` formatted per current locale
  - Status chip: `🔴 غير مدفوع` | `✅ مدفوع`
  - If paid: `بواسطة [name] · [relative time]`
  - Notes count badge if notes.length > 0
- Swipe right → Mark paid (green indicator)
- Swipe left → Mark unpaid (orange indicator)
- Both swipes: Snackbar with Undo (3 seconds)
- Tap → Transaction Detail Sheet

### Sent Tab
- Same layout and date grouping
- No status chip, no swipe actions — read-only
- Notes still available

### Transaction Detail Bottom Sheet

All 6 sections in order:

**1. Header**
Amount large, source badge, direction label, operationDate full format

**2. Parties**
Counterparty name, phone (tap to copy), wallet number, received-by name

**3. Status** (received only)
Current status chip, marked-by name, marked-at datetime

**4. Status History**
Chronological timeline of all paid↔unpaid toggles
Each row: `[name] غيّر من [from] إلى [to] · [datetime]`

**5. Notes**
Each note: author initials avatar + name + timestamp + edit icon + delete icon
Edit: inline text field replaces note text
Delete: AlertDialog confirmation
`+ إضافة ملاحظة` button at bottom
No limit on count

**6. Open SMS** (Android only, same-wallet device only)
Button visible only when `SmsDeepLink.canOpen()` returns true

---

### Amount Tier Badge Colors

Defined only in `AppColors`:
```
low      → muted grey-blue
medium   → blue
high     → orange
veryHigh → red
```

---

## ⚙️ Settings Screen

- Display name (editable, updates Firebase Auth + Firestore)
- Wallet number (Android only; informational text on iOS: "لا يلزم على iOS")
- Language selector: System / العربية / English
- Theme selector: System / فاتح / داكن
- Sign Out button
- App version (read-only)

---

## 🔒 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /transactions/{txId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      // Allow update only for mutable fields
      allow update: if request.auth != null
        && !request.resource.data.diff(resource.data).affectedKeys()
            .hasAny(['createdAt', 'smsId', 'source', 'direction', 'amount',
                     'operationDate', 'operationId', 'walletNumber',
                     'receivedByUid', 'receivedByName']);
      allow delete: if false;
    }

    match /users/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == uid;
    }

    match /sms_unrecognized/{id} {
      allow create: if request.auth != null;
      allow read, update, delete: if false;
    }
  }
}
```

---

## ✅ Feature Checklist

### Auth
- [ ] Google Sign-In button (primary)
- [ ] Email/Password Sign-In + Sign-Up (secondary)
- [ ] Name confirmation step after any first sign-in
- [ ] Pre-fill name from Google displayName
- [ ] `nameConfirmed` flag — skip screen on subsequent opens
- [ ] Session persists indefinitely (Firebase LOCAL persistence)
- [ ] Sign-out clears Riverpod state

### SMS
- [ ] `SmsFormat` abstract interface
- [ ] `SmsParserRegistry` with `registerAll` + `register` + unrecognized logging
- [ ] VF Cash Arabic Received — production regex + DD-MM-YY date parser
- [ ] VF Cash Arabic Sent — production regex
- [ ] VF Cash English — production regex, both directions, full datetime parser
- [ ] InstaPay Arabic Received
- [ ] InstaPay Arabic Sent
- [ ] Arabic numeral normalization applied before all parsers
- [ ] Background listener via `another_telephony`
- [ ] iOS Platform.isAndroid guard — zero telephony code on iOS
- [ ] `smsId` stored on every transaction
- [ ] Deduplication via Firestore doc ID (operationId or fallback)
- [ ] Offline write → auto-sync on reconnect (Firestore offline persistence)
- [ ] `operationDate` always from SMS content, never sync time

### Transactions
- [ ] `operationDate` shown in UI (not createdAt)
- [ ] Real-time stream: received tab
- [ ] Real-time stream: sent tab
- [ ] Date grouping by `operationDate`
- [ ] AmountTier badge (4 tiers, color-coded, defined in AppColors)
- [ ] Source badge (VF Cash / InstaPay)
- [ ] Swipe right → paid, swipe left → unpaid (received only) + Snackbar undo
- [ ] Sent tab read-only (no swipe, no status chip)
- [ ] Status toggle writes `markedByName`, `markedByUid`, `markedAt`
- [ ] `statusHistory` array appended on every status toggle
- [ ] Notes: add / edit / delete on any transaction (any direction)
- [ ] Transaction detail sheet with all 6 sections
- [ ] SMS deep link button (Android, same-wallet only)
- [ ] Empty state widget per tab
- [ ] Wallets tab lists all registered wallets/numbers
- [ ] Wallet card shows latest known balance from latest SMS transaction (`balanceAfter`)
- [ ] Wallet card shows transaction count and last operation date
- [ ] Wallet transaction explorer: list all transactions for selected wallet number
- [ ] Wallet explorer filters by provider (VF Cash / InstaPay)
- [ ] Wallet explorer filters by direction (received / sent)

### Theme & Locale
- [ ] Default: system theme and system locale
- [ ] User-overridable from Settings
- [ ] Persisted in SharedPreferences + Firestore
- [ ] RTL layout for Arabic, LTR for English
- [ ] Zero hardcoded strings — ARB files only
- [ ] Zero hardcoded colors — AppColors or Theme only
- [ ] Zero hardcoded sizes — AppSizes only

### Settings
- [ ] Editable display name (synced to Firebase Auth + Firestore)
- [ ] Editable wallet number (Android) / info message (iOS)
- [ ] Language picker
- [ ] Theme picker
- [ ] Sign out

---

## 🚀 Human Init Steps

1. Create Firebase project → enable **Firestore** + **Authentication**
2. In Auth: enable **Google** provider + **Email/Password** provider
3. Download `google-services.json` → `android/app/`
4. Download `GoogleService-Info.plist` → `ios/Runner/`
5. Enable Google Sign-In: add SHA-1 fingerprint to Firebase Android app
6. Paste security rules into Firestore Rules tab
7. Each Android device: install APK → sign in → confirm name → enter wallet number
8. iPhone: install → sign in → confirm name (no wallet field shown)
