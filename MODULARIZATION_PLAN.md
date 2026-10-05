# Mahafez Platform — 4-Layer Modularization Plan & Checklist

> **Ecosystem:** `mahafez-app` GitHub Organization  
> **Target Architecture:** Strict 4-Layer Modular Architecture (Core $\to$ Services $\to$ Product $\to$ Experience)  
> **Source Project:** `/Users/radyhaggag/Programming/Flutter/mahafez-app/wallet_tracker`

---

## 1. Architectural Rationale: Why Are We Doing This?

### 1.1 The Monolithic Problem
The current `wallet_tracker` application is structured as a feature-based monolith. While it utilizes Clean Architecture principles internally within features, it suffers from critical architectural decay common to growing mobile codebases:

1. **Circular & Inverted Dependencies:**
   - The native SMS service (`lib/core/services/sms_transaction_service.dart`) in the Core layer directly imports `SaveTransactionUseCase` from `features/transactions`. A lower-level infrastructure service depends directly on a higher-level product feature.
2. **Domain Impurity:**
   - The domain entity enum `WalletProvider` (`lib/core/domain/enums/wallet_provider.dart`) imports Flutter presentation elements (`BuildContext`, `AppColors`, icons). This prevents domain models from being reused in headless background workers or pure Dart tests.
3. **Core Layer Pollution:**
   - `lib/core/widgets/` contains domain-specific UI widgets such as `balance_card.dart`, `wallets/`, and `transactions/`. Core should only contain generic, reusable Design System primitives.
4. **Tight Cross-Feature Coupling:**
   - `home` directly imports `wallets` and `workspaces`.
   - `transactions` directly depends on wallet domain types.
   - Any modification in wallet handling risks breaking transaction rendering or SMS listening.

### 1.2 The 4-Layer Architecture Rules
To establish an enterprise-grade standard, the codebase is being decoupled into isolated packages following four non-negotiable rules:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   LAYER 4: EXPERIENCE / APP SHELL                      │
│   mahafez_mobile_app (Deployable Shell: main.dart, GoRouter, DI)       │
└──────────────────┬───────────────────────────────┬─────────────────────┘
                   │                               │
        ┌──────────▼──────────┐         ┌──────────▼──────────┐
        │  wallet_product     │ ◄─────► │ transaction_product │ (❌ ZERO Cross-Imports)
        │  (Layer 3: Domain)  │  NO     │ (Layer 3: Domain)   │
        └──────────┬──────────┘  PEER   └──────────┬──────────┘
                   │             DEPS              │
┌──────────────────▼───────────────────────────────▼─────────────────────┐
│                 LAYER 2: SERVICES / CAPABILITIES                       │
│   mahafez_sms_engine  │  mahafez_auth_service  │  mahafez_workspace    │
│   (Headless Logic, No UI, Reusable Business Capabilities)              │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
┌──────────────────────────────────▼─────────────────────────────────────┐
│                    LAYER 1: CORE / PLATFORM                            │
│   mahafez_core (Pure Dart)   │   mahafez_design_system (UI Primitives) │
│   mahafez_storage (Cache/DB) │   (Zero Business Logic, Fully Stable)   │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Strict Downward Dependencies ($L_4 \to L_3 \to L_2 \to L_1$):**
   - Higher layers can depend on lower layers.
   - Lower layers have **zero knowledge** of higher layers.
2. **Zero Peer Dependencies in Products ($L_3 \not\leftrightarrow L_3$):**
   - `wallet_product` and `transaction_product` must **never** import each other.
   - Cross-product communication is coordinated by the Layer 4 App Shell via routing contracts or domain event contracts.
3. **Purity of Core & Services ($L_1$ and $L_2$):**
   - **Layer 1 (Core)** contains no business logic.
   - **Layer 2 (Services)** contains headless business logic, but **zero UI widgets** and no knowledge of specific products.
4. **Shell as Pure Orchestrator ($L_4$):**
   - Contains no business logic or repository queries.
   - Owns `main.dart`, `GoRouter`, Riverpod `ProviderContainer` setup, permissions, and embeds product screens.

### 1.3 Why Git Packages & GitHub Organization?
Instead of a single local monorepo, each layer/module is extracted into an independent Git repository under the `mahafez-app` GitHub organization:
* **True Isolation:** Ensures boundaries cannot be accidentally bypassed by relative file imports (`../../`).
* **Semantic Versioning:** Consumers lock to Git tags (e.g., `ref: v1.0.0`), preventing unintended breaking changes.
* **Mirrors Enterprise DevOps:** Exactly mirrors private Git repositories / package feeds in Azure DevOps/TFS.
* **Developer Ergonomics:** Uses `dependency_overrides` with local file paths during rapid feature development, switching back to Git tags for releases.

---

## 2. Target Repositories Overview

| Repository | Layer | Type | Key Contents |
| :--- | :--- | :--- | :--- |
| **`mahafez_core`** | **Layer 1** | Pure Dart | `Failure`, `Result<T>`, `EgyptianPhoneNumber`, formatters, base validators, clean enums |
| **`mahafez_design_system`** | **Layer 1** | Flutter | Cairo fonts, `AppColors`, `AppSpacing`, `AppResponsive`, buttons, inputs, loaders, dialogs |
| **`mahafez_sms_engine`** | **Layer 2** | Flutter (Headless) | Android Telephony, 5 Egyptian wallet regex parsers, retry queue, background SMS stream |
| **`wallet_product`** | **Layer 3** | Flutter (Feature) | Wallet domain, DTOs, `WalletCard`, `AddWalletScreen`, `WalletDetailsScreen`, Riverpod controllers |
| **`transaction_product`** | **Layer 3** | Flutter (Feature) | Transaction domain, DTOs, `TransactionTile`, ledger screen, receipt sharing, filter chips |
| **`mahafez_mobile_app`** | **Layer 4** | Deployable App | `main.dart`, `GoRouter`, DI bootstrap, Firebase configuration, `HomeScreen` compositor |

---

## 3. Phased Implementation Plan & Checklist

### Phase 0: Organization & Foundation Setup
- [x] Create GitHub Organization: [`mahafez-app`](https://github.com/orgs/mahafez-app)
- [x] Transfer main repository: `mahafez-app/e_wallet_tracker_VodafoneCash_WePay_EtisalatMoney_InstaPay_OranageMoney`
- [x] Confirm local project path: `/Users/radyhaggag/Programming/Flutter/wallet_tracker`
- [x] Create Master Plan documentation: `MODULARIZATION_PLAN.md`

---

### Phase 1: Layer 1 — `mahafez_core` Extraction (Pure Dart)
*Goal: Standalone, pure Dart package with zero Flutter dependencies and zero business rules.*
- [x] Create repository: `https://github.com/mahafez-app/mahafez_core`
- [x] Initialize package structure:
  - [x] `lib/mahafez_core.dart` (Public barrel export file)
  - [x] `lib/src/error/failures.dart` (`Failure`, `ServerFailure`, `CacheFailure`, `ValidationFailure`)
  - [x] `lib/src/error/result.dart` (`Result<T>`)
  - [x] `lib/src/utils/egyptian_phone_number.dart`
  - [x] `lib/src/utils/text_validators.dart`
  - [x] `lib/src/enums/transaction_type.dart`
  - [x] `lib/src/enums/wallet_provider.dart` (Pure enum without UI/Flutter imports)
- [x] Add unit tests for `EgyptianPhoneNumber`, `Result<T>`, and `TextValidators`
- [x] Tag release `v1.0.0` and push to GitHub
- [x] Add `mahafez_core` as Git dependency in the main project
- [x] Clean redundant local implementations in `wallet_tracker` and replace with `mahafez_core` package
- [x] Verify `flutter analyze` and `flutter test` pass in the main project

---

### Phase 2: Layer 1 — `mahafez_design_system` Extraction (UI Primitives)
*Goal: Reusable UI component library and styling tokens with zero business logic.*
- [x] Create repository: `https://github.com/mahafez-app/mahafez_design_system`
- [x] Initialize package structure:
  - [x] Cairo font assets packaged in `lib/fonts/Cairo/*` per official Flutter package standards
  - [x] `lib/mahafez_design_system.dart` (Public barrel export file)
  - [x] `lib/src/tokens/mahafez_colors.dart` (`MahafezColors` with full palette & Egyptian wallet brand colors)
  - [x] `lib/src/tokens/mahafez_spacing.dart` (`MahafezSpacing`)
  - [x] `lib/src/tokens/mahafez_responsive.dart` (`MahafezResponsive` & extensions)
  - [x] `lib/src/tokens/mahafez_color_extension.dart` (`MahafezColorExtension` & `BuildContext.mahafezColors`)
  - [x] `lib/src/tokens/mahafez_theme.dart` (`MahafezTheme.light()`, `MahafezTheme.dark()` using Cairo)
  - [x] `lib/src/widgets/mahafez_button.dart` (`MahafezButton`, `MahafezButtonType`)
  - [x] `lib/src/widgets/mahafez_text_field.dart` (`MahafezTextField`)
  - [x] `lib/src/widgets/mahafez_dialog.dart` (`MahafezDialog`, `MahafezDialogType`)
  - [x] `lib/src/widgets/mahafez_loader.dart` (`MahafezLoader`)
  - [x] `lib/src/widgets/mahafez_snackbar.dart` (`MahafezSnackbar` with decoupled failure handler)
  - [x] `lib/src/widgets/mahafez_error_view.dart` (`MahafezErrorView` with decoupled error handler)
  - [x] `lib/src/widgets/mahafez_skeleton_box.dart` (`MahafezSkeletonBox`)
  - [x] `lib/src/widgets/mahafez_info_card.dart` (`MahafezInfoCard`)
- [x] Strict Architecture Standards Enforced:
  - [x] **Zero Typedefs:** Eliminated backward-compatibility typedef aliases; strictly migrated consumer sites to branded `Mahafez...` names
  - [x] **Dot Shorthand:** Used Dart 3 leading dot syntax (`.primary`, `.info`, `.error`, `.success`, etc.) for enums
  - [x] **Decoupled Localization:** Decoupled app-specific `context.l10n` using pluggable static handlers configured in `app_initializer.dart`
- [x] Created `example/` gallery app with automated tests
- [x] Published releases `v1.0.0`, `v1.0.1`, and `v1.0.2` to GitHub
- [x] Added `mahafez_design_system` as Git dependency in `wallet_tracker/pubspec.yaml`
- [x] Configured Cairo font mapping in shell `pubspec.yaml` referencing `packages/mahafez_design_system/fonts/Cairo/...`
- [x] Physically removed local Cairo fonts and all 13 extracted theme/widget files from `wallet_tracker`
- [x] Added host integration widget tests (`test/core/theme/design_system_integration_test.dart`)
- [x] Verified `flutter analyze` (**0 issues found**) and `flutter test` (**11/11 passed**) in `wallet_tracker`

---

### Phase 3: Layer 2 — `mahafez_sms_engine` Extraction (Capability Engine)
*Goal: Headless Egyptian wallet SMS scraping and parsing engine.*
- [x] Create repository: `https://github.com/mahafez-app/mahafez_sms_engine`
- [x] Implement Contract-First architecture:
  - [x] Define `SmsParseResult`, `ParsedInboxSmsRecord`, `SmsWalletCandidate`, and `SmsTransactionEvent` models
  - [x] Define `SmsEngineService` interface (`Stream<SmsTransactionEvent> get onTransactionDetected`) and `TelephonySmsEngineService`
- [x] Migrate telecom regex parsers:
  - [x] `VodafoneCashSmsParser`
  - [x] `InstaPaySmsParser`
  - [x] `OrangeMoneySmsParser`
  - [x] `EtisalatCashSmsParser`
  - [x] `WePaySmsParser`
- [x] Migrate pattern matching & disambiguation infrastructure:
  - [x] `SmsParserRegistry` & `SmsPatternMatcher`
  - [x] `SmsWalletMatcher<T extends SmsWalletCandidate>` (generic, decoupled from concrete domain entities)
  - [x] `SmsPhoneNumberExtractor`
  - [x] `InboxSmsHistoryMatcher`
  - [x] `InboxSmsService` / `InboxSmsServiceImpl`
  - [x] `PendingSmsRetryService` & `PendingSmsRetryItem`
- [x] **Decouple:** Completely removed direct dependency on `SaveTransactionUseCase`, `WalletEntity`, and Firebase Auth from the engine package
- [x] Add extensive unit and regression tests (19/19 passed in package):
  - [x] Regression testing against Vodafone Cash, InstaPay, Orange Money, Etisalat Cash, and WePay datasets
  - [x] Wallet balance delta matching and inbox history matching unit tests
- [x] Tag release `v1.0.0` and push to GitHub (`mahafez-app/mahafez_sms_engine`)
- [x] Add `mahafez_sms_engine` as Git dependency in `wallet_tracker/pubspec.yaml` (`ref: v1.0.0`)
- [x] Implement `SmsTransactionEntityBuilder` in `wallet_tracker` for product-level transaction entity hydration
- [x] Physically delete all 15 extracted SMS parser, registry, matcher, and retry service files from `wallet_tracker`
- [x] Update `WalletEntity` to implement `SmsWalletCandidate`
- [x] Verify `flutter analyze` passes (**0 issues found**) and `flutter test` passes (**11/11 passed**) in `wallet_tracker`

---

### Phase 4: Layer 3 — `wallet_product` Extraction (Business Vertical)
*Goal: Autonomous business domain for wallet management.*
- [ ] Create repository: `https://github.com/mahafez-app/wallet_product`
- [ ] Migrate Domain:
  - [ ] `WalletEntity`
  - [ ] `GetWalletsUseCase`, `AddWalletUseCase`, `UpdateWalletBalanceUseCase`
- [ ] Migrate Data:
  - [ ] `WalletDto`, `WalletRemoteDataSource`, `WalletRepositoryImpl`
- [ ] Migrate Presentation:
  - [ ] `WalletCard` (moved from core widgets)
  - [ ] `AddWalletScreen`, `WalletDetailsScreen`
  - [ ] Riverpod state notifiers & controllers
  - [ ] `WalletProductEntry` / route definitions
- [ ] Tag release `v1.0.0` and push to GitHub
- [ ] Add `wallet_product` as Git dependency in the main project
- [ ] Remove `lib/features/wallets` from the main project
- [ ] Verify `flutter analyze` passes

---

### Phase 5: Layer 3 — `transaction_product` Extraction (Business Vertical)
*Goal: Autonomous business domain for transactions with ZERO dependencies on `wallet_product`.*
- [ ] Create repository: `https://github.com/mahafez-app/transaction_product`
- [ ] Migrate Domain:
  - [ ] `TransactionEntity`
  - [ ] `GetTransactionsUseCase`, `SaveTransactionUseCase`, `MarkTransactionPaidUseCase`
- [ ] Migrate Data:
  - [ ] `TransactionDto`, `TransactionRemoteDataSource`, `TransactionRepositoryImpl`
- [ ] Migrate Presentation:
  - [ ] `TransactionTile`, `TransactionFilterChips`, `TransactionReceiptCard`
  - [ ] `TransactionsScreen`, `TransactionDetailScreen`
  - [ ] Riverpod state notifiers & controllers
- [ ] **Enforce Peer Isolation:** Replace `WalletEntity` filter references with `TransactionFilterTarget(id, name)`
- [ ] Tag release `v1.0.0` and push to GitHub
- [ ] Add `transaction_product` as Git dependency in the main project
- [ ] Remove `lib/features/transactions` from the main project
- [ ] Verify `flutter analyze` passes

---

### Phase 6: Layer 4 — App Shell Composition & Finalization
*Goal: Transform main repository into `mahafez_mobile_app` App Shell.*
- [ ] Configure `app_router.dart`:
  - [ ] Connect exported routes from `wallet_product` and `transaction_product`
  - [ ] Eliminate direct imports to internal feature screens
- [ ] Refactor `HomeScreen` into a pure Compositor:
  - [ ] Embed `WalletCarouselWidget` from `wallet_product`
  - [ ] Embed `RecentTransactionsListWidget` from `transaction_product`
- [ ] Refactor `app_bootstrap.dart`:
  - [ ] Wire `mahafez_sms_engine` stream events to `SaveTransactionUseCase` and `UpdateWalletBalanceUseCase`
- [ ] Audit remaining features (`auth`, `workspaces`, `settings`) for clean boundaries
- [ ] Verify end-to-end functionality:
  - [ ] App launches and splash screen transitions correctly
  - [ ] Wallets render and can be added
  - [ ] SMS parsing triggers balance updates and transaction creation
  - [ ] All tests pass
- [ ] Final architecture audit tag `v1.0.0`
