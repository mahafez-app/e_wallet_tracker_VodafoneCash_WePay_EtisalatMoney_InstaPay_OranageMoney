# 🔧 **Mahafez** — Technical Execution Plan
## AI-Guided Phase-by-Phase Implementation

---

## 📖 **How to Use This Plan**

This plan is designed to be used with AI agents (Copilot, Gemini, Claude, etc.).

**Workflow:**
1. Read the phase description
2. Copy the AI agent prompt for that phase
3. Paste into your AI tool
4. Follow the agent's implementation steps
5. Move to next phase when current phase completes

---

# **PHASE 0: DISCOVERY & DESIGN FOUNDATION**

## Phase 0 Objective
Create a complete, AI-approved design system and screen mockups that the dev team can implement pixel-perfectly.

## Phase 0 Success Criteria
- ✅ All 6 screens designed in Figma (or similar tool)
- ✅ Design system created (colors, typography, spacing, components)
- ✅ Design exported and accessible to dev team
- ✅ RTL/LTR layouts verified
- ✅ Dev team has interactive Figma prototype to reference

---

## **Phase 0 AI Agent Prompt**

Copy and paste this into Google Stitch, Galileo, Claude, or your AI design tool:

```
You are a UI/UX design specialist creating a production-ready mobile app design.

PROJECT: Mahafez (محافظ) — Business E-Wallet Transaction Tracker

REFERENCE DOCUMENT:
[PASTE ENTIRE CONTENTS OF STITCH_DESIGN_BRIEF.md HERE]

TASK: Generate complete, pixel-perfect UI designs for all 6 screens.

REQUIREMENTS:
1. RTL-first design (Arabic default, English mirrored)
2. Material Design 3 components
3. Light and dark theme variants
4. All interactive states (hover, pressed, disabled)
5. Real sample data (Egyptian names, amounts in EGP, Arabic dates)
6. Accessibility-compliant (WCAG AA contrast, 44px touch targets)

SCREENS TO DESIGN:
1. Login Screen (Google + Email/Password)
2. Name Confirmation Screen
3. Received Transactions Tab (date-grouped list)
4. Sent Transactions Tab (read-only)
5. Wallets Tab (wallet summary cards)
6. Transaction Detail Bottom Sheet (all 6 sections)
7. Settings Screen
8. Wallet Transaction Explorer (modal)

OUTPUT:
- Export all screens as high-resolution PNG/SVG
- Create Figma file with interactive prototype
- Generate design tokens (JSON or CSS)
- Create component library
- Document all spacing, colors, and typography decisions

VALIDATION:
- All text meets WCAG AA contrast (7:1 for body, 4.5:1 for secondary)
- All interactive elements are ≥ 44x44px
- RTL text alignment correct
- Color-blind friendly (icons + text, not color alone)
```

---

## Phase 0 Deliverables
- Figma file with all screens + components + design system
- Exported assets (PNG/SVG, 1x/2x/3x)
- Design tokens (colors, typography, spacing)
- Interactive prototype (showing navigation flows)
- Design-to-code mapping guide

---

---

# **PHASE 1: FOUNDATION & AUTHENTICATION**

## Phase 1 Objective
Set up Flutter project with clean architecture, Firebase auth, and basic UI scaffolding.

## Phase 1 Success Criteria
- ✅ Flutter project created with clean architecture folders
- ✅ Firebase (Auth + Firestore) configured and tested
- ✅ Google Sign-In implemented and tested on Android/iOS
- ✅ Email/Password auth implemented
- ✅ Name confirmation flow working
- ✅ Localization (Arabic/English) setup
- ✅ Theme system (light/dark/system) working
- ✅ Login & Settings screens built
- ✅ `flutter analyze` passes (zero warnings)
- ✅ Manual testing on real devices completed

---

## **Phase 1 AI Agent Prompt**

Copy and paste this into Claude, Copilot, Gemini, etc.:

```
You are a senior Flutter architect. I'm building a financial app (Mahafez) that needs robust foundation and auth.

PROJECT: Mahafez (محافظ)

PHASE 1 TASKS:

1. PROJECT STRUCTURE & SETUP
   - Create clean architecture folder structure:
     lib/
     ├── presentation/        (UI widgets, screens)
     ├── domain/             (models, use cases, repository interfaces)
     ├── data/               (Firestore, local storage, repository implementations)
     ├── core/               (constants, utilities, theme, localization)
     ├── providers/          (Riverpod state management)
     └── main.dart
   
   - Add dependencies to pubspec.yaml:
     * riverpod, hooks_riverpod
     * firebase_core, firebase_auth, cloud_firestore
     * google_sign_in
     * go_router (navigation)
     * shared_preferences
     * intl (localization)
     * flutter_localizations

   - Set up analysis_options.yaml with linter rules

2. FIREBASE SETUP
   - Initialize Firebase in main.dart
   - Configure Firestore offline persistence (unlimited cache)
   - Create Firestore security rules:
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /transactions/{txId} {
           allow read: if request.auth != null;
           allow create: if request.auth != null;
           allow update: if request.auth != null && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['createdAt', 'smsId', 'source', 'direction', 'amount', 'operationDate', 'operationId', 'walletNumber', 'receivedByUid', 'receivedByName']);
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

3. AUTHENTICATION LAYER
   - Create domain/models/user.dart:
     class User {
       final String uid;
       final String displayName;
       final String? walletNumber;
       final bool isAndroid;
       final bool nameConfirmed;
       final String preferredLocale;
       final String preferredTheme;
       final DateTime createdAt;
     }

   - Create domain/repositories/auth_repository.dart (interface):
     abstract class AuthRepository {
       Stream<FirebaseUser?> authStateChanges();
       Future<void> signInWithGoogle();
       Future<void> signInWithEmail(String email, String password);
       Future<void> signUpWithEmail(String email, String password);
       Future<void> signOut();
       Future<void> updateDisplayName(String name);
     }

   - Implement data/repositories/auth_repository_impl.dart

   - Create domain/use_cases/:
     * GoogleSignInUseCase
     * EmailSignInUseCase
     * EmailSignUpUseCase
     * UpdateDisplayNameUseCase

   - Create providers/auth_provider.dart (Riverpod):
     final authStateProvider = StreamProvider<FirebaseUser?>(...)
     final userProvider = StreamProvider<User?>(...)

4. FIRESTORE USER DOCUMENT
   - On first sign-in: create users/{uid} with:
     {
       "displayName": "Ahmed",
       "walletNumber": null,
       "isAndroid": true,
       "nameConfirmed": false,
       "preferredLocale": "system",
       "preferredTheme": "system",
       "createdAt": serverTimestamp()
     }

5. LOCALIZATION (ARB FILES)
   - Create lib/l10n/intl_en.arb:
     {
       "appName": "Mahafez",
       "tabReceived": "Received",
       "tabSent": "Sent",
       "tabWallets": "Wallets",
       "buttonSignIn": "Sign In",
       "buttonSignUp": "Sign Up",
       "buttonConfirm": "Confirm",
       "buttonCancel": "Cancel",
       "labelEmail": "Email",
       "labelPassword": "Password",
       "labelName": "Your Name",
       "labelContinueWithGoogle": "Continue with Google",
       "hintEmail": "your@email.com",
       "hintPassword": "••••••••",
       "hintName": "Ahmed Mahmoud",
       "errorInvalidEmail": "Invalid email address",
       "errorWeakPassword": "Password must be 8+ characters with uppercase and number",
       "errorUserNotFound": "User not found",
       "errorWrongPassword": "Wrong password",
       "errorEmailInUse": "Email already in use",
       "errorNetworkError": "Network error",
       "statusPaid": "Paid",
       "statusUnpaid": "Unpaid",
       "messageCopied": "Copied to clipboard",
       "labelWalletNumber": "Wallet Number",
       "labelLanguage": "Language",
       "labelTheme": "Theme",
       "labelVersion": "Version",
       "buttonSignOut": "Sign Out"
     }

   - Create lib/l10n/intl_ar.arb (Arabic translations, mirror everything)

   - Generate: flutter pub get, then localization auto-generates

6. THEME SYSTEM
   - Create core/theme/app_colors.dart:
     class AppColors {
       // Semantic colors
       static const primaryBlue = Color(0xFF3B82F6);
       static const successGreen = Color(0xFF10B981);
       static const errorRed = Color(0xFFEF4444);
       static const warningAmber = Color(0xFFF59E0B);
       static const lightGrey = Color(0xFFF3F4F6);
       
       // Amount tiers
       static const tierLowGrey = Color(0xFF9CA3AF);
       static const tierMediumBlue = Color(0xFF3B82F6);
       static const tierHighOrange = Color(0xFFFB923C);
       static const tierVeryHighRed = Color(0xFFB91C1C);
     }

   - Create core/theme/app_typography.dart (TextStyle definitions)
   - Create core/theme/app_spacing.dart (spacing constants)
   - Create core/theme/theme_data.dart (light + dark MaterialApp themes)

   - Create providers/theme_provider.dart:
     final themeModeProvider = StateProvider<ThemeMode>(...)
     final localeProvider = StateProvider<Locale?>(...)

7. NAVIGATION
   - Create core/routing/router.dart using GoRouter:
     final router = GoRouter(
       initialLocation: '/',
       redirect: (context, state) {
         // Redirect unauthenticated to /login
         // Redirect !nameConfirmed to /name-confirmation
       },
       routes: [
         GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
         GoRoute(path: '/name-confirmation', builder: (context, state) => NameConfirmationScreen()),
         GoRoute(path: '/', builder: (context, state) => HomeScreen()),
         GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
       ],
     );

8. LOGIN SCREEN UI
   - Create presentation/screens/login_screen.dart
   - Implement:
     * Logo + tagline (centered)
     * [Continue with Google] button (full width, 56px)
     * Divider (horizontal)
     * Email input field
     * Password input field (masked)
     * [Sign In] button (full width, 56px)
     * "Sign Up" link
   
   - Interactions:
     * Google button → GoogleSignInUseCase → navigate to /name-confirmation or /
     * Email fields validation (email format, password min 8)
     * [Sign In] → EmailSignInUseCase → navigate or show error
     * "Sign Up" → toggle to sign-up mode

9. NAME CONFIRMATION SCREEN UI
   - Create presentation/screens/name_confirmation_screen.dart
   - Implement:
     * Headline: "What's your name? / ما اسمك؟"
     * Text input field (pre-filled from Firebase Auth displayName)
     * [Confirm] button (full width, 56px)
   
   - Interactions:
     * [Confirm] → UpdateDisplayNameUseCase → set nameConfirmed=true → navigate to /

10. SETTINGS SCREEN UI
    - Create presentation/screens/settings_screen.dart
    - Implement:
      * Profile section: display name (editable)
      * Device info section: wallet number (Android only, display-only)
      * Preferences section: language picker, theme picker
      * App version (read-only)
      * [Sign Out] button (red, destructive)
    
    - Interactions:
      * Display name: tap → inline edit → save (update Firebase Auth + Firestore)
      * Language picker: select → update Riverpod provider + SharedPreferences + Firestore
      * Theme picker: select → update Riverpod provider + SharedPreferences + Firestore
      * [Sign Out] → AlertDialog confirmation → signOut() → navigate to /login

11. HOME SCREEN SCAFFOLD (STUB)
    - Create presentation/screens/home_screen.dart
    - Implement:
      * AppBar with Settings icon (tap → /settings)
      * BottomNavigationBar with 3 tabs (placeholder for now):
        Tab 0: 📥 Received (stub widget)
        Tab 1: 📤 Sent (stub widget)
        Tab 2: 👛 Wallets (stub widget)
      * Tab switching logic (no navigation, just tab state)

12. MAIN.dart WIRING
    - Initialize Firebase
    - Register Riverpod providers
    - Set up GoRouter with auth redirect logic
    - Configure MaterialApp:
      * theme: light theme
      * darkTheme: dark theme
      * themeMode: watch themeModeProvider
      * locale: watch localeProvider
      * localizationsDelegates: AppLocalizations.localizationsDelegates
      * supportedLocales: [Locale('ar'), Locale('en')]
      * router: GoRouter instance

13. MANUAL TESTING CHECKLIST
    - Test on Android device:
      [ ] App launches
      [ ] Navigate to /login
      [ ] Google Sign-In flow (works, creates user doc)
      [ ] Name confirmation shows (pre-filled if Google)
      [ ] After confirm, navigates to /
      [ ] Session persists after kill/relaunch
      [ ] Settings screen accessible
      [ ] Language switch works (Arabic ↔ English immediately)
      [ ] Theme switch works (light/dark immediately)
      [ ] Sign out works (redirects to login)
    
    - Test on iOS device (same flows above)
    
    - Test on emulator (same flows)

14. CODE QUALITY
    - Run: flutter analyze (zero warnings)
    - Run: flutter test (all tests pass)
    - Code review: no hardcoded strings, no hardcoded colors

OUTPUT: Working Flutter app with:
- Clean architecture folders set up
- Firebase Auth integrated (Google + Email/Password)
- Name confirmation flow
- Session persistence
- Localization working (Arabic/English real-time switch)
- Theme system working (light/dark/system)
- Settings screen functional
- Home screen scaffold with tabs
- Zero analyzer warnings
```

---

## Phase 1 Implementation Workflow

**Steps to execute Phase 1:**

1. **Initialize project:** Follow the "PROJECT STRUCTURE & SETUP" section
2. **Configure Firebase:** Follow the "FIREBASE SETUP" section
3. **Build auth layer:** Implement use cases + repositories (top-down approach)
4. **Add localization:** Create ARB files, generate
5. **Build theme system:** Create color/typography/spacing constants
6. **Implement screens:** Login → Name Confirmation → Settings → Home scaffold
7. **Wire everything:** Update main.dart with providers + routing
8. **Manual test:** Test all flows on real devices
9. **Code cleanup:** Run analyze, format, fix

---

---

# **PHASE 2: SMS PIPELINE & BACKEND INFRASTRUCTURE**

## Phase 2 Objective
Build SMS parser system and Firebase integration so Android devices can read SMS and sync transactions.

## Phase 2 Success Criteria
- ✅ SMS parser registry implemented (pluggable)
- ✅ All 5 SMS formats parsing correctly (tested with real SMS samples)
- ✅ Firestore transactions collection populated
- ✅ Android SMS listener running in background
- ✅ Deduplication working (no duplicate docs)
- ✅ Offline write + reconnect sync working
- ✅ iOS builds cleanly (no telephony code)
- ✅ All unit tests passing
- ✅ Real SMS successfully parsed and stored

---

## **Phase 2 AI Agent Prompt**

```
You are a backend/SMS specialist. I'm building an SMS transaction parser and Firestore integration.

PROJECT: Mahafez (محافظ)
PHASE: SMS Pipeline & Backend

CONTEXT:
This app reads SMS from Vodafone Cash and InstaPay (Egypt) on Android devices.
Each team member's phone automatically captures SMS and syncs to shared Firebase backend.
iPhone users see transactions in real-time (no SMS reading on iOS).

SMS SAMPLES (REAL):

Received (Arabic, Vodafone):
تم استلام مبلغ 500.00 جنيه من رقم 01102564881 المسجل بإسم Ezzeldin F Mohamed رصيدك الحالي 4277.33 تاريخ العملية 05-04-26 16:49 رقم العملية 018925943091

Sent (Arabic, Vodafone):
تم تحويل 500 جنيه لرقم 01034970670 مصاريف الخدمة 0 جنيه رصيد حسابك فى فودافون كاش الحالي 3777.33

Received (English, Vodafone):
Mar 22, 2026 11:37:20 AM: Received EGP150 from 00201140932674 to Mobile Account Number 2111. Ref: 018586711473 Available Balance: 1093.33

InstaPay (TBD):
You will provide real samples when available; parsers must be extensible to add new formats

TASK 1: SMS PARSER ARCHITECTURE

Create core/sms/sms_format.dart:
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

Create core/sms/sms_parser_registry.dart:
  class SmsParserRegistry {
    static final instance = SmsParserRegistry._();
    final List<SmsFormat> _formats = [];
    
    void registerAll(List<SmsFormat> formats) => _formats.addAll(formats);
    void register(SmsFormat format) => _formats.add(format);
    
    Transaction? parse({...}) {
      // Loop through _formats, try to match + parse
      // If no match, log to sms_unrecognized collection
    }
  }

TASK 2: SMS PARSERS (5 total)

Create core/sms/formats/vf_cash_arabic_received.dart:
  class VfCashArabicReceivedFormat implements SmsFormat {
    // Match: contains "تم استلام"
    // Regex: extract amount, phone, name, date, operation ID, balance
    // Return: Transaction(direction: received, source: vodafoneCash)
  }

Create core/sms/formats/vf_cash_arabic_sent.dart:
  class VfCashArabicSentFormat implements SmsFormat {
    // Match: contains "تم تحويل"
    // Regex: extract amount, phone, fee, balance
    // Return: Transaction(direction: sent, source: vodafoneCash)
  }

Create core/sms/formats/vf_cash_english.dart:
  class VfCashEnglishFormat implements SmsFormat {
    // Match: contains "EGP" and ("Received" or "Sent")
    // Regex: parse datetime, direction, amount, phone, ref, balance
    // Return: Transaction(direction: based on "Received"/"Sent")
  }

Create core/sms/formats/instapay_arabic_received.dart & instapay_arabic_sent.dart:
  // Similar structure, different regex patterns

CRITICAL: Each parser must extract operationDate from SMS content (not system time).

TASK 3: ARABIC NUMERAL NORMALIZER

Create core/utils/arabic_numeral_normalizer.dart:
  class ArabicNumeralNormalizer {
    static String normalize(String input) {
      // Convert ٠١٢٣٤٥٦٧٨٩ to 0123456789
      // Called before all parsers
    }
  }

TASK 4: TRANSACTION DOMAIN MODEL

Create domain/models/transaction.dart:
  class Transaction {
    final String id;
    final int? smsId;
    final String source;           // 'vodafone_cash' | 'instapay'
    final String direction;        // 'received' | 'sent'
    final double amount;
    final double serviceFee;
    final double balanceAfter;
    final String? counterpartyName;
    final String? counterpartyPhone;
    final String walletNumber;
    final String receivedByName;
    final String receivedByUid;
    final String? operationId;
    final DateTime operationDate;  // FROM SMS, not server time
    final DateTime createdAt;      // server timestamp
    final String? status;          // 'unpaid' | 'paid' | null
    final String? markedByName;
    final String? markedByUid;
    final DateTime? markedAt;
    final List<TransactionNote> notes;
    final List<StatusHistoryEntry> statusHistory;
    
    // toMap() / fromMap() for Firestore serialization
  }

TASK 5: FIRESTORE SCHEMA & INDEXES

Create Firestore composite indexes:
  - transactions: walletNumber ASC, operationDate DESC
  - transactions: source ASC, operationDate DESC
  - transactions: walletNumber ASC, source ASC, operationDate DESC

Firestore document structure (transactions/{id}):
  {
    "id": "018925943091",
    "smsId": 12345,
    "source": "vodafone_cash",
    "direction": "received",
    "amount": 500.00,
    "serviceFee": 0.0,
    "balanceAfter": 4277.33,
    "counterpartyName": "Ezzeldin F Mohamed",
    "counterpartyPhone": "01102564881",
    "walletNumber": "01098765432",
    "receivedByName": "أحمد راضى",
    "receivedByUid": "user_uid_123",
    "operationId": "018925943091",
    "operationDate": Timestamp(2026-04-05 16:49:00),
    "createdAt": Timestamp(server_time),
    "status": "unpaid",
    "markedByName": null,
    "markedByUid": null,
    "markedAt": null,
    "notes": [],
    "statusHistory": []
  }

TASK 6: SMS LISTENER (ANDROID ONLY)

Add to pubspec.yaml:
  - another_telephony (NOT telephony, which is deprecated)

Add to AndroidManifest.xml:
  <uses-permission android:name="android.permission.READ_SMS" />
  <uses-permission android:name="android.permission.RECEIVE_SMS" />

Create data/services/sms_listener.dart:
  @pragma('vm:entry-point')
  Future<void> backgroundSmsHandler(SmsMessage message) async {
    // Initialize Firebase
    // Get wallet info from SharedPreferences
    // Parse SMS using SmsParserRegistry
    // Write to Firestore (offline persistence queues if no internet)
  }

In main.dart:
  if (Platform.isAndroid) {
    AnotherTelephony.instance.listenIncomingSms(
      onNewMessage: (msg) => backgroundSmsHandler(msg),
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
  }

TASK 7: iOS PLATFORM GUARD

Ensure all telephony code is:
  if (Platform.isAndroid) { ... }

iOS build must compile cleanly with ZERO telephony references.

TASK 8: OFFLINE PERSISTENCE & SYNC

Configure Firestore in main.dart:
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

Test scenario:
  1. Turn off internet on Android
  2. Receive SMS
  3. Check SharedPreferences (SMS queued locally)
  4. Turn on internet
  5. Verify Firestore write completes
  6. Verify operationDate is from SMS (not sync time)

TASK 9: DEDUPLICATION LOGIC

Strategy:
  - VF Received: doc ID = operationId (from SMS)
  - VF Sent Arabic: doc ID = vf_sent_{walletNumber}_{smsId}
  - VF English: doc ID = Ref number
  - InstaPay: doc ID = operationId or fallback

Implementation:
  FirebaseFirestore.instance.collection('transactions').doc(id).set(
    transactionMap,
    SetOptions(merge: false),  // Prevents duplicates (ignores if doc exists)
  );

Test:
  1. Send same SMS twice
  2. Verify only ONE Firestore doc created
  3. Verify doc ID is stable (same ID on retry)

TASK 10: UNRECOGNIZED SMS LOGGING

If no format matches, log to sms_unrecognized collection:
  FirebaseFirestore.instance.collection('sms_unrecognized').add({
    'sender': message.address,
    'body': message.body,
    'at': FieldValue.serverTimestamp(),
  });

This helps debug when new SMS formats arrive.

TASK 11: UNIT TESTS

Write tests for each parser:
  test('VfCashArabicReceivedFormat parses valid SMS', () {
    final parser = VfCashArabicReceivedFormat();
    final sms = 'تم استلام مبلغ 500.00 جنيه من رقم 01102564881 المسجل بإسم Ezzeldin F Mohamed رصيدك الحالي 4277.33 تاريخ العملية 05-04-26 16:49 رقم العملية 018925943091';
    
    final result = parser.parse(
      sender: 'VF-Cash',
      body: sms,
      smsId: 1,
      walletNumber: '01098765432',
      receivedByName: 'أحمد راضى',
      receivedByUid: 'uid',
    );
    
    expect(result, isNotNull);
    expect(result!.amount, 500.0);
    expect(result.counterpartyPhone, '01102564881');
    expect(result.counterpartyName, 'Ezzeldin F Mohamed');
    expect(result.balanceAfter, 4277.33);
    expect(result.operationId, '018925943091');
    expect(result.operationDate, DateTime(2026, 4, 5, 16, 49));
  });

Test all 5 parsers with real SMS samples.
Test ArabicNumeralNormalizer.
Test SmsParserRegistry (all formats, unknown format).
Test deduplication (same SMS twice → one doc).

TASK 12: MANUAL TESTING

On Android device:
  1. Install app
  2. Request SMS permission
  3. Send test SMS to device from another phone
  4. Verify SMS appears in Firestore < 2 seconds
  5. Verify all fields parsed correctly
  6. Send duplicate SMS
  7. Verify only one doc in Firestore
  8. Turn off internet
  9. Send another SMS
  10. Turn on internet
  11. Verify write syncs
  12. Check Firestore: operationDate matches SMS (not sync time)

On iOS:
  1. Verify build compiles (zero telephony errors)
  2. Verify app launches
  3. Verify Firestore read works (can see transactions from Android)

OUTPUT:
- All 5 SMS parsers working
- Real SMS successfully parsed + stored in Firestore
- Deduplication tested + working
- Offline write → sync tested + working
- All unit tests passing
- iOS builds cleanly
- Firestore rules secure
- sms_unrecognized logging ready for new formats
```

---

## Phase 2 Implementation Workflow

1. **Set up parser architecture:** SmsFormat interface + SmsParserRegistry
2. **Implement all 5 parsers:** One by one, test each with real SMS
3. **Create Transaction model:** Domain model + Firestore serialization
4. **Configure Firestore:** Set up indexes + security rules
5. **Implement SMS listener:** Android background handler + Firebase write
6. **Add iOS guard:** Platform checks, zero telephony on iOS
7. **Test offline scenario:** Turn off internet, reconnect, verify sync
8. **Test deduplication:** Send same SMS twice, verify one doc
9. **Unit test parsers:** All 5 formats, edge cases
10. **Manual test on devices:** Android SMS reading, iOS verification

---

---

# **PHASE 3: CORE TRANSACTION FEATURES**

## Phase 3 Objective
Implement all transaction UI (Received/Sent/Wallets tabs), detail sheet with all 6 sections, and real-time sync.

## Phase 3 Success Criteria
- ✅ Received tab displays real-time transactions (date-grouped)
- ✅ Sent tab displays transactions (read-only)
- ✅ Swipe right → mark paid (green), swipe left → mark unpaid (orange/red)
- ✅ Detail sheet shows all 6 sections (header, parties, status, history, notes, SMS link)
- ✅ Notes add/edit/delete working
- ✅ Wallets tab shows all registered wallets with balance
- ✅ Wallet explorer filters transactions
- ✅ Real-time sync visible (transactions appear instantly)
- ✅ Offline caching works
- ✅ All localization strings in ARB
- ✅ All tests passing

---

## **Phase 3 AI Agent Prompt**

```
You are a senior Flutter UI/UX developer. I'm building transaction-focused screens for a fintech app.

PROJECT: Mahafez (محافظ)
PHASE: Core Transaction Features

DESIGN REFERENCE:
[PASTE RELEVANT SECTIONS FROM STITCH_DESIGN_BRIEF.md FOR PHASE 3]

CONTEXT:
- Real-time Firestore streams (transactions appear instantly)
- Offline-first (cached data shown, refreshes when online)
- RTL-first (Arabic primary, English secondary)
- Amount tier badges (grey < 1K, blue 1-5K, orange 5-10K, red > 10K)
- Swipe interactions (right = mark paid, left = mark unpaid)
- Status history & notes on every transaction

TASK 1: TRANSACTION REPOSITORY & USE CASES

Create domain/repositories/transaction_repository.dart (interface):
  abstract class TransactionRepository {
    Stream<List<Transaction>> getReceivedTransactions();
    Stream<List<Transaction>> getSentTransactions();
    Stream<List<Transaction>> getTransactionsByWallet(String walletNumber);
    Future<void> updateTransactionStatus(String txId, String status);
    Future<void> addNoteToTransaction(String txId, TransactionNote note);
    Future<void> updateNoteInTransaction(String txId, String noteId, String newText);
    Future<void> deleteNoteFromTransaction(String txId, String noteId);
    Stream<List<WalletSummary>> getWalletSummaries();
  }

Implement data/repositories/transaction_repository_impl.dart

Create use cases:
  - GetReceivedTransactionsUseCase
  - GetSentTransactionsUseCase
  - GetTransactionsByWalletUseCase
  - UpdateTransactionStatusUseCase
  - AddNoteToTransactionUseCase
  - UpdateNoteInTransactionUseCase
  - DeleteNoteFromTransactionUseCase
  - GetWalletSummariesUseCase

TASK 2: RIVERPOD PROVIDERS

Create providers/transaction_provider.dart:
  final receivedTransactionsProvider = StreamProvider<List<Transaction>>(...);
  final sentTransactionsProvider = StreamProvider<List<Transaction>>(...);
  final transactionsByWalletProvider = StreamProvider<List<Transaction>>(...);
  final walletSummariesProvider = StreamProvider<List<WalletSummary>>(...);

TASK 3: TRANSACTION GROUPING UTILITY

Create domain/models/grouped_transactions.dart:
  class GroupedTransactions {
    final String dateLabel;  // "Today", "Yesterday", "DD/MM/YYYY"
    final List<Transaction> transactions;
  }

Create core/utils/transaction_grouper.dart:
  List<GroupedTransactions> groupTransactionsByDate(List<Transaction> transactions) {
    // Group by operationDate
    // Format labels: "Today" if today, "Yesterday" if yesterday, else "DD/MM/YYYY"
    // Return newest group first
  }

TASK 4: RECEIVED TAB SCREEN

Create presentation/screens/tabs/received_tab.dart:
  - Watch receivedTransactionsProvider (StreamProvider)
  - Show loading spinner while fetching
  - Show error snackbar if error
  - Group transactions by date (using groupTransactionsByDate)
  - Render date-grouped list with sticky headers
  - Empty state if no transactions

UI Layout:
  AppBar: "المستلم / Received"
  List:
    - "اليوم / Today" (sticky header)
      - TransactionCard 1
      - TransactionCard 2
    - "أمس / Yesterday"
      - TransactionCard 3
    - "الجمعة، 5 أبريل / Friday, Apr 5"
      - TransactionCard N
  
  Empty state:
    Icon + "لا توجد عمليات مستلمة / No received transactions"

TASK 5: SENT TAB SCREEN

Create presentation/screens/tabs/sent_tab.dart:
  - Identical to Received tab, but:
    * Watch sentTransactionsProvider
    * No swipe actions (read-only styling)
    * No status chip (transactions are inherently "paid" if sent)

TASK 6: TRANSACTION CARD COMPONENT

Create presentation/widgets/transaction_card.dart:
  - Reusable for both Received and Sent
  
  Layout:
    ┌─ Row 1: Amount + AmountTier Badge + SourceBadge
    │  └─ "500 جنيه" [bold, primary color]
    │     + [Amount tier badge: grey/blue/orange/red]
    │     + ["فودافون كاش" or "InstaPay" badge]
    │
    ├─ Row 2: Counterparty
    │  └─ "محمد على" [bold]
    │     + "01012345678" [grey]
    │
    ├─ Row 3: Metadata
    │  └─ "أحمد راضى" [grey]
    │     + "اليوم 2:30م" [grey]
    │
    └─ Row 4: Status (if Received)
       └─ "✅ مدفوع" [green] OR "🔴 غير مدفوع" [red]
          + (if paid) "بواسطة راضى • منذ ساعة" [small grey]

  Interactive states:
    - Default: standard shadow
    - Hover: darker shade
    - Tap: navigate to detail sheet
    - Swipe (Received only): see Section 7

TASK 7: SWIPE INTERACTIONS (RECEIVED ONLY)

Wrap TransactionCard in Dismissible widget:

  Swipe right > 30% width:
    - Background color: green (#10B981)
    - Icon: checkmark
    - On dismiss: call UpdateTransactionStatusUseCase(status: 'paid')
    - Show snackbar: "تم تحديد كمدفوع" [Undo button, 3 sec]
    - Undo: revert status to 'unpaid'
    - Update statusHistory array with new entry

  Swipe left > 30% width:
    - Background color: orange/red (#F59E0B or #EF4444)
    - Icon: X
    - On dismiss: call UpdateTransactionStatusUseCase(status: 'unpaid')
    - Show snackbar: "تم تحديد كغير مدفوع" [Undo button, 3 sec]
    - Undo: revert status to 'paid'
    - Update statusHistory array

  Sent cards: no swipe (disabled)

TASK 8: TRANSACTION DETAIL BOTTOM SHEET (ALL 6 SECTIONS)

Create presentation/screens/transaction_detail_sheet.dart:
  - DraggableScrollableSheet (draggable handle at top)
  - Close button (X, dismisses)

SECTION 1: HEADER
  - Amount (large, 32sp, bold, primary color)
  - Source badge ("فودافون كاش" or "InstaPay")
  - Direction label ("مستلم" or "مرسل")
  - Operation date formatted (e.g., "الأحد، 5 أبريل 2026 • 4:30م")
  - Visual divider

SECTION 2: PARTIES
  - Counterparty name (label + value)
  - Counterparty phone (label + value, tappable)
    * Tap: copy to clipboard → toast "تم النسخ"
    * Optional: tap to call/WhatsApp
  - Wallet number (label + value)
  - Received by name (label + value)
  - Visual divider

SECTION 3: STATUS (RECEIVED ONLY; SENT shows static label)
  - Current status chip (green "مدفوع" or red "غير مدفوع")
  - [تغيير / Change] button
    * Tap: toggle status
    * Firestore update: status + markedByName + markedAt
    * Animate chip color change (200ms fade)
    * Add entry to statusHistory
  - Marked by info (if status != null):
    "تم التحديث بواسطة [name] في [datetime]"
  - Visual divider

SECTION 4: STATUS HISTORY (RECEIVED ONLY)
  - Header: "سجل التغييرات / Status History"
  - Timeline (vertical list, newest at top):
    * Timeline dot (green if → paid, red if → unpaid)
    * Text: "[Name] غيّر من [from] إلى [to]"
    * Timestamp: "الأحد، 5 أبريل • 4:30م"
  - Empty state: "لم يتم تغيير الحالة بعد"
  - Visual divider

SECTION 5: NOTES
  - Header: "ملاحظات / Notes"
  - Note cards (each):
    * Author initials avatar (colored background)
    * Author name + "منذ X" timestamp
    * Note text (editable on tap)
    * Edit icon (✏️) + Delete icon (🗑️)
  
  - Edit note (inline):
    * Tap edit → text field replaces note text
    * User edits + confirms (✓) or cancels (✕)
    * Firestore: update notes array (find by note.id, update text + updatedAt)
  
  - Delete note:
    * Tap delete → AlertDialog confirmation
    * Confirm: remove note from array
    * Firestore: update notes array (filter out deleted note)
  
  - Add note button (full width):
    "[+ إضافة ملاحظة / Add Note]" (dashed border, grey)
    * Tap: inline text field appears
    * User types + confirms (✓ button)
    * New note: id (UUID), text, authorName (from current user), authorUid, createdAt, updatedAt
    * Firestore: append to notes array
  
  - Empty state: "لا توجد ملاحظات"
  - Visual divider

SECTION 6: OPEN SMS (ANDROID ONLY)
  - [Open SMS] button (only if):
    * Platform.isAndroid == true
    * smsId > 0
    * tx.walletNumber == currentDeviceWalletNumber
  
  - Tap: AndroidIntent to open SMS app
    AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'content://sms/{smsId}',
    ).launch();
  
  - Handle failure gracefully (error snackbar)

TASK 9: WALLETS TAB SCREEN

Create presentation/screens/tabs/wallets_tab.dart:
  - Watch walletSummariesProvider
  - Render wallet summary cards:
    * Wallet number (e.g., "01102564881")
    * Provider label ("فودافون كاش" / "InstaPay" / "مختلط")
    * Latest known balance (large, prominent)
      - If available from SMS balanceAfter: show amount
      - If not available: show "غير متاح"
    * Last operation date
    * Total transactions count
  
  - Tap wallet card: navigate to WalletExplorerScreen (with wallet number param)
  - Empty state: "لا توجد محافظ / No wallets"

TASK 10: WALLET TRANSACTION EXPLORER

Create presentation/screens/wallet_explorer_screen.dart:
  - Route parameter: walletNumber (String)
  - Watch transactionsByWalletProvider(walletNumber)
  
  Layout:
    - Header: wallet number + provider label
    - Filter chips (horizontal scroll):
      * [All]
      * [فودافون كاش / Vodafone]
      * [InstaPay]
      * [مستلم / Received]
      * [مرسل / Sent]
    - Active chip: primary color
    - Transaction list (same card styling as tabs)
    - Tap transaction → detail sheet
    - Empty state: "لا توجد عمليات مطابقة / No matching transactions"
  
  Filtering logic:
    - By provider (source): vodafone_cash, instapay
    - By direction: received, sent
    - Composable (e.g., "Vodafone + Received")

TASK 11: NAVIGATION & ROUTING

Update GoRouter in core/routing/router.dart:
  - ReceivedTab → tap transaction card → show detail sheet (modal)
  - SentTab → tap transaction card → show detail sheet (modal)
  - WalletsTab → tap wallet card → navigate to WalletExplorerScreen
  - WalletExplorerScreen → tap transaction card → show detail sheet (modal)

Detail sheet is showModalBottomSheet (not full navigation).

TASK 12: REAL-TIME SYNC ANIMATIONS

Implement entrance animation for new transactions:
  - Fade in + slide up (100ms)
  - Staggered if multiple transactions

Implement status change animation:
  - Swipe right: card animates to green (300ms)
  - Swipe left: card animates to orange (300ms)
  - After 3s: returns to normal

Implement "loading more" spinner:
  - Show at bottom of list when fetching older transactions

TASK 13: ERROR HANDLING

Handle edge cases:
  - Missing counterparty name: show phone only
  - Missing balance: show "غير متاح"
  - Firestore query error: show error snackbar + retry button
  - SMS deep link failure: show error snackbar
  - Offline: show cached data + "Offline" badge
  - Network reconnection: auto-refresh data

TASK 14: LOCALIZATION

Add all strings to intl_en.arb + intl_ar.arb:
  - Tab labels
  - Status labels
  - Chip labels
  - Button labels
  - Placeholder texts
  - Error messages
  - Empty state messages
  - Status history template
  - Note timestamp template
  - Section headers

Test language switching (Arabic ↔ English immediately updates UI).

TASK 15: TESTING

Unit tests:
  - transaction_grouper utility
  - AmountTier calculation
  - Date formatting per locale

Manual tests:
  - ReceivedTab displays all transactions
  - SentTab displays transactions (read-only, no swipe)
  - Swipe right → mark paid → snackbar → undo works
  - Swipe left → mark unpaid → snackbar → undo works
  - Detail sheet: all 6 sections display
  - Status toggle in detail sheet works
  - Notes: add/edit/delete works
  - Status history populated correctly
  - Wallets tab shows all wallets
  - Wallet explorer filters by provider/direction
  - Real-time updates (add transaction on another device, see in app)
  - Offline → online (cached data shown, refresh syncs)
  - SMS deep link (Android only)
  - Language switch (Arabic ↔ English, immediate)
  - Theme switch (light ↔ dark, immediate)

OUTPUT:
- All transaction screens fully functional
- Real-time streams working
- Swipe interactions smooth
- Detail sheet complete with all 6 sections
- Wallets tab populated
- Notes & status history working
- All tests passing
```

---

## Phase 3 Implementation Workflow

1. **Build transaction layer:** Repository, use cases, providers
2. **Implement tab screens:** Received, Sent (list UI)
3. **Build transaction card:** Reusable component with styling
4. **Add swipe interactions:** Right/left, snackbar, undo
5. **Build detail sheet:** All 6 sections (header, parties, status, history, notes, SMS)
6. **Implement Wallets tab:** Wallet summary cards + explorer
7. **Add localization:** All strings to ARB
8. **Test real-time sync:** Add transaction on another device
9. **Test offline:** Turn off internet, verify cached data
10. **Manual testing:** All flows on real devices

---

---

# **PHASE 4: POLISH, HARDENING & RELEASE**

## Phase 4 Objective
Finalize app for production: security, performance, comprehensive testing, and store submission.

## Phase 4 Success Criteria
- ✅ Zero analyzer warnings
- ✅ All tests passing (unit, integration, manual)
- ✅ Security review completed
- ✅ Accessibility audit passed (WCAG AA)
- ✅ Cross-platform testing (iOS/Android) passed
- ✅ App signed with release certificates
- ✅ Google Play app live
- ✅ App Store app live
- ✅ Post-release monitoring in place
- ✅ Documentation complete

---

## **Phase 4 AI Agent Prompt**

```
You are a release manager and QA specialist. I'm preparing a Flutter fintech app for production.

PROJECT: Mahafez (محافظ)
PHASE: Polish, Hardening & Release

CURRENT STATE:
- All features implemented (auth, SMS, transactions, wallets)
- Locally tested on devices
- Ready for hardening and release

TASK 1: CODE QUALITY & ANALYSIS

Run:
  flutter analyze
  → Fix all warnings (zero tolerance)

Run:
  dart format .
  → Auto-format all code

Run:
  dart fix --apply
  → Apply all fixes

Code review (manual):
  - No hardcoded strings (all in ARB)
  - No hardcoded colors (all in AppColors)
  - No magic numbers (all in AppSizes)
  - Proper error handling (try/catch, error snackbars)
  - No unnecessary state rebuilds (Riverpod correct usage)
  - No console logs (remove debug prints)

TASK 2: PERFORMANCE OPTIMIZATION

Profile:
  - Startup time (target: app launches in < 3 seconds)
  - Firestore query efficiency (check indexes)
  - Memory usage (check for leaks)
  - Battery drain (SMS listener efficiency)

Optimize:
  - Use const constructors throughout
  - Lazy load detail sheet content
  - Implement pagination for older transactions (if list > 1000)
  - Image optimization (if any images used)

TASK 3: SECURITY HARDENING

Review:
  - Firestore security rules (ensure restrictive, not permissive)
  - Auth flow (no credentials in logs or shared preferences)
  - SMS parsing (no injection vulnerabilities)
  - Offline cache (no sensitive data unencrypted)
  - Permissions (SMS read, calendar, contacts — request correctly)
  - Data leakage (no credentials in logs)
  - Deep links (SMS link validation)

Firestore rules should look like:
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /transactions/{txId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update: if request.auth != null && !request.resource.data.diff(resource.data).affectedKeys().hasAny([
          'createdAt', 'smsId', 'source', 'direction', 'amount', 'operationDate', 'operationId',
          'walletNumber', 'receivedByUid', 'receivedByName'
        ]);
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

TASK 4: LOCALIZATION COMPLETENESS

Audit all user-facing strings:
  - No hardcoded English mixed with Arabic
  - All strings in ARB files
  - No placeholder text left behind

Test full workflows:
  - Arabic: login → home → send transaction → detail sheet → settings
  - English: same workflows

Test RTL integrity:
  - Icons position correct (close ✕ on correct side)
  - Text aligns correct (right for Arabic, left for English)
  - Buttons placement correct
  - Swipe direction correct

Test date/number formatting per locale:
  - Arabic: dates formatted per Islamic calendar (if preferred) or Gregorian
  - English: dates formatted standard

Test language switching:
  - System setting → app respects
  - App override → works

Get RTL design review from Arabic speaker (if available).

TASK 5: ACCESSIBILITY TESTING

Screen reader testing:
  - iOS VoiceOver: all buttons/links announced correctly
  - Android TalkBack: all buttons/links announced correctly
  - Form fields labeled semantically

Color contrast (WCAG AA):
  - Use contrast checker tool (e.g., WebAIM, Contrast Ratio)
  - Test in light + dark themes
  - Minimum: 7:1 for body text, 4.5:1 for secondary

Keyboard navigation:
  - All interactions reachable via keyboard (no tap-only)
  - Tab order logical

System settings:
  - High contrast mode: test
  - Reduced motion: test (respect prefers-reduced-motion)

Accessibility tools:
  - Accessibility Inspector (iOS)
  - Accessibility Scanner (Android)

TASK 6: CROSS-PLATFORM TESTING

Test on multiple Android versions:
  - Android 8 (API 26), 9, 10, 11, 12, 13, 14

Test on multiple iOS versions:
  - iOS 14, 15, 16, 17

Test on various screen sizes:
  - Android: 360px (small), 390px (medium), 428px (large)
  - iOS: iPhone 11/12/13/14 sizes
  - Tablet: iPad (if in scope)

Test orientations:
  - Portrait + Landscape (if landscape supported)

Test on real devices (not just emulator):
  - Samsung, Pixel, OnePlus (Android)
  - iPhone X, 12, 13, 14 (iOS)

TASK 7: COMPREHENSIVE FEATURE TESTING

Auth flow:
  [ ] Google Sign-In → name confirmation → home
  [ ] Email sign-up → name confirmation → home
  [ ] Email sign-in → home directly (if already confirmed)
  [ ] Session persists after kill/relaunch
  [ ] Sign out works

SMS reading (Android):
  [ ] Receive SMS → appears in app < 2 seconds
  [ ] Multiple SMS → all parsed correctly
  [ ] Offline SMS → queued, synced on reconnect
  [ ] Duplicate SMS → only one doc created
  [ ] Invalid SMS → logged to sms_unrecognized

Transaction display:
  [ ] Received tab shows all received transactions
  [ ] Sent tab shows all sent transactions
  [ ] Grouping by date correct
  [ ] Sorting by operationDate DESC correct

Status marking (Received):
  [ ] Swipe right → green indicator + snackbar
  [ ] Swipe left → orange indicator + snackbar
  [ ] Undo works
  [ ] Status persists after app restart
  [ ] Status history populated
  [ ] markedByName + markedAt filled

Notes:
  [ ] Add note → appears immediately
  [ ] Edit note → updates immediately
  [ ] Delete note → removes after confirmation
  [ ] Multiple notes → all display in order
  [ ] Notes persist after app restart

Wallets:
  [ ] All registered wallets appear
  [ ] Balance shown (if available)
  [ ] Last activity date correct
  [ ] Transaction count correct
  [ ] Tap wallet → navigates to explorer

Wallet explorer:
  [ ] All transactions for wallet displayed
  [ ] Filter by provider works
  [ ] Filter by direction works
  [ ] Combined filters work
  [ ] Tap transaction → detail sheet

Detail sheet:
  [ ] All 6 sections displayed
  [ ] Amount formatted correctly
  [ ] Dates formatted per locale
  [ ] Copy phone works
  [ ] Status toggle works (if received)
  [ ] Notes functional
  [ ] SMS deep link works (Android only)

Settings:
  [ ] Edit display name → saves + syncs
  [ ] Language picker → switches immediately
  [ ] Theme picker → switches immediately
  [ ] Preferences persist after restart
  [ ] Sign out → redirects to login

Offline & Sync:
  [ ] Turn off internet → app still responsive (cached)
  [ ] Modify status offline → queued
  [ ] Turn on internet → changes sync
  [ ] New transactions appear after reconnect
  [ ] Timestamps consistent (operationDate not affected by sync)

Error scenarios:
  [ ] Firestore permission denied → error shown
  [ ] Network timeout → graceful handling
  [ ] SMS permission denied → no crashes
  [ ] Invalid data in Firestore → handled gracefully

Edge cases:
  [ ] No transactions (empty state)
  [ ] 1000+ transactions (performance, pagination)
  [ ] Very long counterparty names (text overflow)
  [ ] Very long notes (text wrapping)
  [ ] Missing counterparty name (show phone only)
  [ ] Missing balance (show "Not available")
  [ ] Rapid swipes (debounce/throttle)
  [ ] Rapid note additions (no race conditions)
  [ ] Rapid status toggles (final state persists)
  [ ] App backgrounded during operation (graceful)
  [ ] Language switching mid-use (UI updates)
  [ ] Theme switching mid-use (UI updates)

TASK 8: APP SIGNING & BUILD CONFIGURATION

ANDROID:
  1. Create release keystore:
     keytool -genkey -v -keystore mahafez-release-key.jks \
       -keyalg RSA -keysize 2048 -validity 10000
     → Save password securely
  
  2. Configure build.gradle:
     signingConfigs {
       release {
         keyStore = file('path/to/mahafez-release-key.jks')
         keyStorePassword = 'password'
         keyAlias = 'mahafez'
         keyPassword = 'password'
       }
     }
     
     buildTypes {
       release {
         signingConfig signingConfigs.release
         minifyEnabled true
         proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
       }
     }
  
  3. Build release APK:
     flutter build apk --release
     → Verify size (target: < 50MB)
  
  4. Build AAB (preferred for Play Store):
     flutter build appbundle --release
     → Verify size (target: < 100MB)
  
  5. Test signed APK on device:
     adb install build/app/outputs/apk/release/app-release.apk

iOS:
  1. Create distribution certificate:
     - Keychain Access → Certificate Assistant → Request from Certificate Authority
     - Save CSR file
     - Go to Apple Developer → Certificates → Create new Distribution certificate
     - Upload CSR
     - Download certificate (.cer)
     - Import to Keychain

  2. Create provisioning profile:
     - Apple Developer → Provisioning Profiles → Distribution
     - Select bundle ID (com.yourcompany.mahafez)
     - Select certificate
     - Download (.mobileprovision)
     - Add to Xcode (Organizer)

  3. Configure Xcode:
     - Set bundle ID (must match certificate)
     - Set team ID
     - Set version (1.0.0) + build number (1)
     - Set minimum iOS version (14.0)
     - Enable App Sandbox permissions (privacy)

  4. Build IPA:
     flutter build ios --release
     → Verify size (< 100MB)

  5. Archive in Xcode:
     - Product → Archive
     - Verify archive completes

TASK 9: GOOGLE PLAY SUBMISSION

1. Create Google Play Console account (if needed)
2. Create app entry:
   - App name: محافظ / Mahafez
   - Category: Finance
   - Content rating: Complete questionnaire
3. Prepare store listing:
  - Short description (80 chars): "إدارة محافظك الخاصة بالأعمال بسهولة / Manage your business wallets easily"
   - Full description (max 4000 chars): Features, benefits, use cases
   - Screenshots (2-8, landscape preferred):
     * Show Received tab with transactions
     * Show transaction detail sheet
     * Show Wallets tab
     * Show Settings screen
     * Both Arabic and English versions
   - Feature graphic (1024x500px)
   - App icon (512x512px, no transparency)
   - Privacy policy URL (required)
4. Set pricing: Free
5. Upload AAB (release build)
6. Add release notes: "Initial release"
7. Submit for review
   - Review typically takes 2-4 hours
   - May request clarifications

TASK 10: APP STORE SUBMISSION

1. Create App Store Connect account (if needed)
2. Create app entry:
   - App name: محافظ / Mahafez
   - Privacy policy URL (required)
3. Create app version (1.0.0):
   - Description: Features, benefits
   - Keywords: wallet, fintech, payments
   - Support email
   - Marketing URL (optional)
4. Add pricing: Free
5. Upload IPA via Xcode archive:
   - Validate build
   - Submit to App Store
6. Add screenshots (5-8 per device type):
   - iPhone 6.7", 5.5" (required)
   - iPad (optional)
   - All with Arabic + English variants
7. Add promotional artwork (1024x1024px)
8. Submit for review
   - Review typically takes 24-48 hours
   - Common rejections: privacy issues, login bugs, crashes

TASK 11: RELEASE MANAGEMENT

1. Create GitHub release tag:
   - Tag: v1.0.0
   - Release notes (user-facing)
   - Attach APK + IPA (optional)

2. Update pubspec.yaml:
   - version: 1.0.0+1

3. Create CHANGELOG entry

4. Communicate release:
   - Notify stakeholders
   - Post on social (if applicable)

TASK 12: POST-RELEASE MONITORING

1. Monitor crash reports (Firebase Crashlytics if enabled)
2. Monitor user feedback (app store reviews)
3. Monitor error logs (Firestore logs)
4. Track key metrics:
   - Daily active users (DAU)
   - Session length
   - Feature usage (which tabs)
   - Error rates
5. Plan hotfix if critical bugs appear:
   - Critical: app crashes on launch, auth broken, data loss
   - Non-critical: UI glitch, minor feature issue
   - Timeline: hotfix < 1 hour, submit < 2 hours

TASK 13: DOCUMENTATION

1. User guide (in-app or external):
   - Getting started
   - Setting up wallet number (Android)
   - Adding notes
   - Marking payments
   - Understanding balance
   - FAQ

2. Admin/support guide:
   - Known issues
   - Troubleshooting
   - Feature list
   - System requirements

3. Developer documentation:
   - Architecture overview
   - Firebase setup
   - SMS parser extension guide
   - Release process

4. Update README.md:
   - Project overview
   - Features
   - Screenshots
   - Build instructions
   - Contributing guidelines

OUTPUT:
- Production-ready app
- Google Play live
- App Store live
- All tests passing
- Zero warnings
- Documentation complete
- Monitoring in place
```

---

## Phase 4 Implementation Workflow

1. **Code quality:** Run analyze, format, fix
2. **Performance:** Profile startup, queries, memory
3. **Security:** Review rules, auth, permissions
4. **Localization:** Audit strings, test RTL
5. **Accessibility:** Screen reader, contrast, keyboard
6. **Cross-platform:** Test iOS/Android versions
7. **Feature testing:** Go through comprehensive checklist
8. **App signing:** Create keystores, certificates
9. **Google Play:** Submit, monitor approval
10. **App Store:** Submit, monitor approval
11. **Release:** Tag version, communicate
12. **Monitoring:** Set up crash/error tracking
13. **Documentation:** Write guides for users/developers

---

---

# 📋 **How to Execute Each Phase**

## **Quick Reference**

| Phase | Focus | AI Tool | Output |
|-------|-------|---------|--------|
| **0** | Design | Google Stitch, Galileo | Figma file, design system |
| **1** | Auth Foundation | Claude, Copilot, Gemini | Working app with auth |
| **2** | SMS & Backend | Claude, Copilot | SMS parser, Firestore sync |
| **3** | Transaction UI | Claude, Copilot | All tabs, detail sheet, wallets |
| **4** | Polish & Release | Claude, Copilot | Production app, live stores |

---

## **Execution Pattern**

For each phase:

1. **Read the phase description** (what you're building)
2. **Review the success criteria** (how to know it's done)
3. **Copy the AI prompt** for that phase
4. **Paste into your AI tool** (Copilot, Claude, Gemini)
5. **Implement step-by-step** following agent guidance
6. **Test manually** (on real devices)
7. **Verify exit criteria** (all checked? Move to next phase)

---

## **Starting Phase 1**

Ready to start? Here's what to do:

1. Open Claude / Copilot / Gemini
2. Copy the "Phase 1 AI Agent Prompt" above
3. Paste into chat
4. Follow the agent's step-by-step implementation
5. Test locally on Android + iOS
6. Verify all Phase 1 exit criteria met
7. **Move to Phase 2**

---

## **No Time Estimates**

This plan doesn't estimate time because:
- Estimates are inaccurate (always overrun or underrun)
- Team velocity varies (junior vs senior devs)
- Blockers unpredictable (Firebase issues, OS updates, bugs)
- Scope can change (features added/removed)

Instead: **Focus on completing each phase's exit criteria, not hitting arbitrary deadlines.**

---

## **Checkpoints Between Phases**

Before moving to next phase, verify:

**Phase 0 → 1:**
- ✅ All screens designed in Figma
- ✅ Dev team has prototype to reference
- ✅ No ambiguities remain

**Phase 1 → 2:**
- ✅ App boots, login works
- ✅ Session persists
- ✅ Zero analyzer warnings

**Phase 2 → 3:**
- ✅ SMS listener working (Android)
- ✅ Firestore syncing transactions
- ✅ Deduplication tested

**Phase 3 → 4:**
- ✅ All tabs functional
- ✅ Detail sheet complete
- ✅ Real-time sync working

**Phase 4 → Release:**
- ✅ Google Play approved
- ✅ App Store approved
- ✅ Monitoring in place

---

## **If You Get Stuck**

1. **Blocked on a task?** → Copy that specific task to AI agent, ask for detailed help
2. **Bug you can't fix?** → Paste error message to AI agent, ask for debugging
3. **Design unclear?** → Reference STITCH_DESIGN_BRIEF.md for detailed specs
4. **Architecture decision?** → Reference WALLET_TRACKER_PLAN.md for technical choices

---

## **Project Structure Reference**

Use this folder structure for all phases:

```
wallet_tracker/
├── lib/
│   ├── presentation/       (UI screens, widgets)
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   ├── tabs/
│   │   │   └── ...
│   │   └── widgets/
│   │       ├── transaction_card.dart
│   │       ├── detail_sheet.dart
│   │       └── ...
│   ├── domain/             (Models, use cases, repo interfaces)
│   │   ├── models/
│   │   ├── repositories/
│   │   └── use_cases/
│   ├── data/               (Firestore, local storage, repo implementations)
│   │   ├── repositories/
│   │   ├── services/
│   │   └── datasources/
│   ├── core/               (Utilities, theme, localization, constants)
│   │   ├── theme/
│   │   ├── routing/
│   │   ├── utils/
│   │   ├── sms/
│   │   └── l10n/
│   ├── providers/          (Riverpod state management)
│   └── main.dart
├── android/
├── ios/
├── assets/
├── test/
├── pubspec.yaml
└── README.md
```

---

## **Final Checklist Before You Start**

- [ ] Read APP_DEFINITION.md (understand what you're building)
- [ ] Review STITCH_DESIGN_BRIEF.md (understand UI requirements)
- [ ] Read this file (understand execution flow)
- [ ] Have AI tool ready (Copilot, Claude, Gemini)
- [ ] Have code editor ready (VS Code, Android Studio, Xcode)
- [ ] Have test devices (Android + iOS)
- [ ] Have GitHub repo set up (version control)
- [ ] Have Firebase project created (or ready to create)

---

## 🚀 **Ready to Start Phase 1?**

Copy the **Phase 1 AI Agent Prompt** and paste into your AI tool. Let the agent guide you!
