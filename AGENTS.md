# OpenCode Agent Instructions

This project (`wallet_tracker` / Mahafez) is a shared e-wallet transaction tracker using Flutter, Riverpod, and Firebase.

## Core Directives & Architecture (from `.claude/rules/`)
- **Strict Clean Architecture:** Layers are separated. Firebase types (`Timestamp`, `DocumentReference`, etc.) **never** cross into the domain or presentation layers.
- **State Management:** Use manual `Provider`, `NotifierProvider`, `AsyncNotifierProvider`, `StreamProvider` via `flutter_riverpod`. 
  - **DO NOT USE:** `riverpod_generator`, `@riverpod` annotations, `StateNotifierProvider`, `get_it`, `injectable`, or `GetX`.
- **Error Handling:** No raw exceptions in domain/presentation. Catch all errors in the data layer, map to `Failure` subtypes, and return as `Result<T>` via the `multiple_result` or similar pattern. No empty catch blocks.
- **Data Layer:** Use `json_serializable` for DTOs.
- **UI & Theming:** RTL-first (Arabic). No hardcoded strings, colors, spacing, or font sizes. Always use localization and theme extensions. No `freezed` or `auto_route`. Use `go_router`.
- **Logs & Nulls:** Use `dart:developer`'s `log()`, not `print()`. Never use the `!` bang operator unless structurally guaranteed. `final` by default.

## Developer Commands & Toolchain
- **Codegen (JSON Serializable & Localization):**
  ```bash
  dart run build_runner build -d
  ```
  *(Note: Localization generates automatically with `intl_utils` or `build_runner` based on `intl_*.arb` updates)*
- **Testing & Verification:**
  ```bash
  flutter analyze
  flutter test
  ```

## Localization (RTL First)
- Primary UI is Arabic (RTL), English (LTR) is secondary.
- String keys must be added to **both** `lib/l10n/intl_en.arb` and `lib/l10n/intl_ar.arb`.
- Use `S.of(context).<key>`. Never hardcode user-facing text.
- After updating `.arb` files, run the build runner to regenerate `lib/generated/`.

## Key Documentation Files
- `.claude/rules/`: Complete technical reference for architecture, state, UI, etc. *Read these rules for deep dives on specific layers.*
- `WALLET_TRACKER_PLAN.md` & `TECHNICAL_EXECUTION_PLAN.md`: App specs, Firestore schema, SMS parsing logic, and phase-by-phase implementation plan.
- `STITCH_DESIGN_BRIEF.md` & `DESIGN_SUMMARY.md`: UI/UX design specifications.
