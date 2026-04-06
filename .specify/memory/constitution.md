<!--
Sync Impact Report:
- Version change: 0.0.0 -> 1.0.0
- Added sections: I. Feature-First Clean Architecture & Code Quality, II. Zero-Warning Testing Standards, III. User Experience & UI Consistency, IV. Performance & Offline Reliability, V. Pluggable Extensibility
- Templates requiring updates:
  - .specify/templates/plan-template.md (⚠ pending - Constitution check gates)
  - .specify/templates/spec-template.md (⚠ pending - scope/requirements alignment)
  - .specify/templates/tasks-template.md (⚠ pending - task categorization)
- Follow-up TODOs: RATIFICATION_DATE set to today since first adoption.
-->
# Raseed (Wallet Tracker) Constitution

## Core Principles

### I. Feature-First Clean Architecture & Code Quality
Strict adherence to Feature-First Clean Architecture and SOLID principles. Dependencies MUST always point inwards to a pure Dart Domain layer. All functions MUST be kept under 20 lines, variables declared `final` by default, and silent failures or magic numbers are strictly forbidden. Use `dart:developer` for logging.

### II. Zero-Warning Testing Standards
Code MUST NOT be presented or merged unless `flutter analyze` returns zero issues. The test structure MUST mirror the `lib/` directory exactly. Developers MUST prioritize testing Notifiers and UseCases using Arrange-Act-Assert, and prefer handwritten fakes over mocks for repository interfaces.

### III. User Experience & UI Consistency
The UI MUST ensure a consistent experience by strictly avoiding hardcoded strings, colors, or sizes; always use `AppLocalizations`, `AppTheme`, and `AppSpacing`. Applications MUST use built-in Flutter tools (`LayoutBuilder`, `Flexible`) for responsive sizing rather than third-party packages. WCAG 2.1 contrast compliance and semantic labeling for accessibility are NON-NEGOTIABLE.

### IV. Performance & Offline Reliability
The application MUST handle offline scenarios gracefully, leveraging built-in persistence (e.g., Firestore offline cache). Rendering MUST be optimized by keeping `build()` methods pure, using `ListView.builder` for dynamic content, avoiding `UniqueKey` inside builds, and offloading heavy computations to `compute()`.

### V. Pluggable Extensibility
Core business logic handling varied inputs (like SMS parsing formats) MUST use a pluggable registry pattern. Adding new formats or providers MUST require only adding a new class and registering it, strictly adhering to the Open-Closed Principle (OCP).

## Technical Constraints & Compliance

The application MUST support RTL-first (Arabic) and English localizations. It MUST compile and run on both Android and iOS, with Android-specific telephony logic strictly guarded behind `Platform.isAndroid` checks to ensure zero telephony references on iOS. Firebase MUST be used for Authentication and Firestore for real-time synchronization and offline persistence. New dependencies MUST be justified by long-term maintainability and cannot replace simple manual implementation (under 50 lines).

## Delivery & Review Process

Development MUST follow the defined phase-based delivery plan (Phase 0 to Phase 7). No phase is considered complete until its explicitly defined exit criteria are satisfied. All PRs MUST pass `flutter analyze` with zero issues and the full test suite before merging. Phase progression is strictly sequential unless explicitly noted.

## Governance

This Constitution supersedes all other practices. All architectural decisions MUST align with the `.claude/rules/` directory. Amendments to this constitution require documentation, approval, and a corresponding version bump using semantic versioning. The Minimalist Dependency Rule must be enforced during code reviews.

**Version**: 1.0.0 | **Ratified**: 2026-04-06 | **Last Amended**: 2026-04-06
