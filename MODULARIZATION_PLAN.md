# Mahafez Platform — 4-Layer Modularization Plan & Checklist

> **Ecosystem:** `mahafez-app` GitHub Organization  
> **Target Architecture:** Strict 4-Layer Modular Architecture (Core $\to$ Services $\to$ Product $\to$ Experience)  
> **Source Project:** `/Users/radyhaggag/Programming/Flutter/mahafez-app/mahafez_app`

---

## 1. Architectural Rationale: Why Are We Doing This?

### 1.1 Current Audit Findings

The original `wallet_tracker` monolith has been split into Layer 1 packages, the Layer 2 SMS engine, and the Layer 3 wallet/transactions product. The remaining gaps are:

1. `mahafez_app` still contains home, auth, invitations, workspaces, settings, and reports implementations instead of acting only as the Layer 4 shell.
2. App-owned SMS orchestration still directly connects `sms_engine` to wallet use cases.
3. App features still read wallet Firestore documents and consume `WalletDto`, while `wallet_product.dart` exposes data-source and repository implementation types.
4. Wallet transaction reports are split: querying lives in `wallet_product`, while report use cases, state, and screens remain in the app.
5. App and wallet package Dart SDK constraints understate the minimum imposed by their current dependencies.

The former separate wallet/transaction product split is resolved: wallets and their ledger are one product.

### 1.2 The 4-Layer Architecture Rules
To establish an enterprise-grade standard, the codebase is being decoupled into isolated packages following four non-negotiable rules:

```text
Layer 4 — Experience
  mahafez_app
  ├── wallet_product
  ├── workspace_product
  └── identity_product

Layer 3 — Products (no peer-product dependencies)
  wallet_product       ──> sms_engine, mahafez_core, mahafez_design_system
  workspace_product    ──> identity_service, mahafez_core, mahafez_design_system
  identity_product     ──> identity_service, mahafez_core, mahafez_design_system

Layer 2 — Reusable, headless capabilities
  sms_engine           ──> mahafez_core
  identity_service    ──> mahafez_core

Layer 1 — Platform foundations
  mahafez_core | mahafez_design_system
```

Layer ownership notes:
- `wallet_product` owns wallet and transaction behavior, transaction reports, and SMS-to-wallet processing. Its product-specific Firestore data sources stay inside its Data layer.
- `workspace_product` owns workspaces, memberships, invitations, and workspace settings. It stores wallet IDs and never imports `wallet_product`; the app composes the two products using generic IDs and display metadata.
- `identity_service` owns headless authentication/profile capabilities. `identity_product` owns sign-in, sign-up, and account UI/flows. Other products use the service, never the identity product.
- `sms_engine` remains product-agnostic. The wallet product adapts its events to wallet/transaction use cases; the app may grant platform permissions and start/stop the wallet product's public integration API.
- Do not create a generic Firebase/Firestore service merely to relocate product-specific collections. Put shared identity capability in Layer 2 and product-owned persistence in the owning product's Data layer.
- Layer 4 depends on Layer 3 products and Layer 1 foundations. It must not directly orchestrate Layer 2 capabilities or own reusable business repositories/use cases.

1. **Strict Downward Dependencies ($L_4 \to L_3 \to L_2 \to L_1$):**
   - Higher layers can depend on lower layers.
   - Lower layers have **zero knowledge** of higher layers.
2. **Cohesive Product Boundaries:**
   - `wallet_product` owns wallets and their transactions, including transaction history, details, notes, paid status, receipts, and wallet-scoped or multi-wallet queries.
   - Do not create a peer `transaction_product`: transactions require wallet identity and lifecycle behavior, so splitting them would create circular product dependencies.
   - The Layer 4 app shell owns routing, workspace composition, and cross-feature orchestration. It passes generic wallet IDs and display/filter metadata into `wallet_product` and does not own transaction presentation or business logic.
3. **Purity of Core & Services ($L_1$ and $L_2$):**
   - **Layer 1 (Core)** contains no business logic.
   - **Layer 2 (Services)** contains headless business logic, but **zero UI widgets** and no knowledge of specific products.
4. **Shell as Pure Orchestrator ($L_4$):**
   - Contains no business logic or repository queries.
   - Owns `main.dart`, `GoRouter`, app bootstrap/configuration, platform permissions, lifecycle, and product composition.
   - Does not directly depend on or orchestrate Layer 2 service packages; a product-facing API owns capability-to-product coordination.

### 1.3 Why Git Packages & GitHub Organization?
Each layer/module is extracted into an independent Git repository under the `mahafez-app` GitHub organization to provide the organization and release workflow chosen for this project. This is a project preference, not a requirement to use Azure DevOps/TFS.
* **True Isolation:** Package boundaries reduce accidental relative imports across modules.
* **Semantic Versioning:** Consumers lock to Git tags (for example, `ref: v1.1.0`) to avoid unintended dependency drift.
* **Independent Ownership:** Repositories and releases make package ownership and change history explicit.
* **Developer Ergonomics:** Uses `dependency_overrides` with local file paths during rapid feature development, switching back to Git tags for releases.

---

## 2. Target Repositories Overview

| Repository | Layer | Type | Key Contents |
| :--- | :--- | :--- | :--- |
| **`mahafez_core`** | **Layer 1** | Pure Dart | Generic failures/results, phone value objects, formatters, reusable validators and enums |
| **`mahafez_design_system`** | **Layer 1** | Flutter | Typography, design tokens, and generic UI primitives |
| **`sms_engine`** | **Layer 2** | Flutter (Headless) | SMS parsing, matching, telephony and retry capabilities; no product knowledge |
| **`identity_service`** | **Layer 2** | Headless capability | Authentication and user-profile operations; no screens or routing |
| **`wallet_product`** | **Layer 3** | Flutter product | Wallets, transactions, reports, SMS integration, data and product UI |
| **`workspace_product`** | **Layer 3** | Flutter product (planned) | Workspaces, members, invitations, settings, data and product UI; stores wallet IDs only |
| **`identity_product`** | **Layer 3** | Flutter product | Authentication/account flows and UI, using `identity_service` |
| **`mahafez_app`** | **Layer 4** | Deployable shell | Bootstrap, routing, permissions/lifecycle, home composition, and product integration |

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
*Goal: Autonomous wallet product, including its transaction ledger and related workflows.*
- [x] Create Git package/repository: `wallet_product` (released as `v1.1.0`)
- [x] Migrate Domain:
  - [x] `WalletEntity`
  - [x] `GetWalletsUseCase`, `AddWalletUseCase`, `UpdateWalletBalanceUseCase`
- [x] Migrate Data:
  - [x] `WalletDto`, `WalletRemoteDataSource`, `WalletRepositoryImpl`
- [x] Migrate Presentation:
  - [x] `WalletCard` (moved from core widgets)
  - [x] `AddWalletScreen`, `WalletDetailsScreen`
  - [x] Riverpod state notifiers & controllers
  - [x] Public screen/configuration API consumed by the app router
  - [x] Transaction domain, DTOs, data sources, repositories, and use cases for wallet and multi-wallet queries
  - [x] Transaction history, detail, notes, receipt, filter, and list presentation/state
  - [x] Transaction overview capability exposed through generic wallet IDs for workspace composition
- [x] Integrate `wallet_product` locally during development; app now resolves the published `v1.1.0` Git tag
- [x] Remove `lib/features/wallets` from the main project
- [x] Verify app and product analysis/tests pass
- [x] Release `wallet_product` v1.1.0 to GitHub and pin the app to that tag

---

### Phase 5: Layer 3 — `wallet_product` Ledger Completion
*Goal: Finish extracting the cohesive wallet and transactions product; no separate transaction product is created.*
- [x] Move transaction history screen, route payload contract, filter UI/state, pagination, and live-update handling from the app into `wallet_product`
- [x] Keep workspace membership/loading/composition in the app; pass generic wallet IDs and display/filter metadata into the product
- [x] Move transaction report querying into `wallet_product` and expose a report use case to app report composition
- [x] Remove `lib/features/transactions` and transaction-specific providers/data access from the app
- [x] Ensure the app router opens the exported product screen using a public configuration contract
- [x] Verify no Firestore transaction collection queries remain in app features
- [x] Verify `flutter analyze` and `flutter test` pass in the app and product

---

### Architecture Remediation Roadmap

Complete these phases in order. Do not mark Layer 4 complete until every preceding product/capability boundary is closed and the dependency audit passes.

### Phase 0: Lock the Architecture Contract and Toolchain
*Goal: remove ambiguity before changing package contracts.*
- [x] Record the package graph and enforce the rule that products never depend on peer products
- [x] Confirm ownership: auth/profile capability in `identity_service`; auth UI in `identity_product`; workspaces/invitations in `workspace_product`; wallet reports and SMS processing in `wallet_product`
- [x] Align all local package `environment.sdk` constraints to the current stable toolchain used for this project (Flutter 3.47.4 / Dart 3.13.3); `flutter pub get` succeeds for the app and wallet product
- [x] No direct Layer 4 → Layer 2 exception is currently planned; platform permission/lifecycle calls into wallet-product public APIs

### Phase 1: Close the `wallet_product` Boundary
*Goal: make the wallet product independently consumable before extracting more app features.*
- [x] Define a supported public API for wallet queries by ID, report screens/configuration, background persistence, and a generic deletion hook
- [x] Stop exporting DTOs, Firestore data sources, repository implementations, and cache implementations from `wallet_product.dart`
- [x] Replace app imports/usages of `WalletDto` and `TransactionDto` with product domain/API contracts
- [x] Move report filter state and wallet/multi-wallet report UI into `wallet_product`; app supplies generic wallet IDs and display labels
- [x] Remove app-owned wallet document reads; app retains workspace-link reads until `workspace_product` owns them
- [x] Publish the breaking API cleanup as `wallet_product` v2.0.0 and pin the app lockfile to that tag

### Phase 2: Put SMS-to-Wallet Orchestration Behind the Product
*Goal: remove the app's direct Layer 2 dependency while preserving OS lifecycle and permissions.*
- [x] Move SMS-to-transaction processing, wallet-specific inbox reconciliation, wallet resolution, retry orchestration, and background processing into `wallet_product`
- [x] Keep `sms_engine` generic; the product adapts its parsers, matchers, and retry queue to wallet and transaction use cases
- [x] Limit the shell to SMS permission prompts, bootstrap of the retry/tombstone storage, app lifecycle/connectivity signals, and calls into the product integration API
- [x] Remove direct `sms_engine` and SMS transaction implementation dependencies from `mahafez_app`; `sms_engine` now arrives only through the wallet product dependency
- [x] Preserve foreground save/deduplication, background durable enqueue/save, retry, tombstone checks, inbox reconciliation, and wallet snapshot balance updates in the product integration

Phase 2 static analysis: no analyzer errors in the changed app or wallet integration. Runtime/device verification has not been run.

### Phase 3: Extract Identity Capability and Product
*Goal: separate reusable authentication from its user-facing flows.*
- [x] Create `identity_service` for headless authentication/profile operations, depending only on Layer 1
- [x] Create `identity_product` for sign-in, sign-up, profile completion, and account flows; depend on `identity_service`, not other products
- [x] Move app auth data sources/use cases into the appropriate package and route through exported product APIs
- [x] Remove direct Firebase Auth/profile business access from app features

Phase 3 static analysis: no Dart analyzer issues reported in the app, `identity_service`, or `identity_product`. The Dart CLI subsequently emitted an environment telemetry file permission error; runtime/device auth flows have not been run.

### Phase 4: Extract `workspace_product`
*Goal: move workspace and invitation business behavior into an independent product.*
- [ ] Move workspaces, memberships, invitations, workspace settings, repositories, use cases, and screens
- [ ] Keep wallet references as IDs and generic display/filter contracts; do not import `wallet_product`
- [ ] Move workspace-specific Firestore reads/writes out of the app
- [ ] Have the app compose workspace and wallet APIs by passing IDs and product-neutral metadata

### Phase 5: Complete the Layer 4 App Shell
*Goal: leave the app with experience composition and platform hosting only.*
- [ ] Replace home data/repository logic with composition of wallet, workspace, and identity product APIs
- [ ] Keep only app-level routing, startup/configuration, platform permissions/lifecycle, and shell-specific preferences
- [ ] Remove feature-owned repositories, DTOs, use cases, and direct Layer 2 dependencies from app modules
- [ ] Ensure routes target public product entry points rather than internal feature screens

### Phase 6: Architecture Gates and Release
*Goal: prove the final package graph and ship reproducible versions.*
- [ ] Add CI checks that reject Layer 2 → Layer 3, Layer 3 → peer Layer 3, and Layer 4 → Layer 2 imports/dependencies
- [ ] Run analysis and tests in every package; run supported platform builds and the end-to-end wallet/workspace/auth flows
- [ ] Review public barrels and confirm no app imports persistence DTOs or implementation classes
- [ ] Pin app dependencies to released Git tags, verify lockfile resolved refs, and tag the app release
- [ ] Update this plan with the audit result and any accepted exceptions
