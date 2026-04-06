---
name: review-and-fix
description: Audit and immediately fix all violations in the target code by checking it against every rules file in .claude/rules/. Covers architecture, state management, error handling, routing, code quality, widget architecture, Dart best practices, data serialization, theming, UI, responsive sizing, and accessibility. Works on a file, folder, or the full project: `review`, `review lib/features/auth`, `review project`.
---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

Read every file in `.claude/rules/` and apply every rule to the target code.
Find every violation. Fix it immediately. No confirmation. No skipping.

## Step 1 — Determine scope

- File provided → review that file.
- Folder provided → review all `.dart` files recursively.
- No target → review all files modified in the current session.
- `review project` → review the entire `lib/` directory.

## Step 2 — Static analysis

Run `flutter analyze` on the target. Fix all reported issues before
proceeding to the manual audit.

## Step 3 — Apply every rule from `.claude/rules/`

Read and enforce each file in order. After finishing each one, print a
single status line before moving to the next:

```
✓  architecture.md       — 2 violations found
✓  error-handling.md     — clean
...
```

1. `architecture.md` — layer boundaries, domain purity, repository pattern,
   use case strictness, provider wiring structure, feature isolation,
   **core widget usage,
   feature widget file placement and subfolder grouping**.
2. `error-handling.md` — Result type, Failure hierarchy, FailureMapper,
   repository handler usage.
3. `error-handling-flow.md` — use case pass-through, provider `AsyncValue`
   handling pattern, failure message resolution, UI error display.
4. `state-management.md` — AsyncValue-first provider design, single logic
   file structure, Notifier/AsyncNotifier structure, Consumer patterns,
   provider wiring, and documented exception criteria for any `*_state.dart`
   extraction. Verify UI integration uses `ref.watch` for rendering,
   `ref.read(provider.notifier)` for actions, and `ref.listen` for side
   effects.
5. `routing.md` — go_router usage, route constants, auth guards, provider
   access in router.
6. `dependencies.md` — forbidden packages, approved packages, 50-line gate.
7. `code-quality.md` — SOLID, naming, final by default, **check `core/widgets/`
   before building any UI component**, widget decomposition, private vs
   separate file threshold, subfolder grouping, no helper methods, build()
   purity, **screen/body split — Screen contains only Scaffold/AppBar/SafeArea,
   all Riverpod state wiring and state logic in `_ScreenNameBody`**, const,
   SizedBox vs
   Container, keys in lists.

   **Explicit scan required — remove every `ValueKey`, `ObjectKey`, or
   `UniqueKey` passed at a call site unless the widget is a direct child of
   `ListView.builder`, `SliverList`, or another indexed builder. This
   includes every switch arm in `Consumer`/`ref.watch`-driven builders —
   remove all keys there unconditionally.**

8. `dart-best-practices.md` — null safety, no dynamic, no late misuse,
   async/await, exhaustive switch, pattern matching.
9. `data-serialization.md` — DTOs vs entities, json_serializable, toEntity(),
   no manual fromJson/toJson, nested models.
10. `linting-testing.md` — analysis_options compliance, zero warnings, test
    file structure, Notifier test coverage (success + failure paths).
11. `theming.md` — Material 3, AppTheme, no hardcoded colors or text styles,
    ThemeExtension tokens, theme notifier for `ThemeMode`.
12. `ui.md` — SafeArea, LayoutBuilder, no hardcoded spacing or dimensions,
    responsive sizing, assets via AppAssets, AppLocalizations for all
    user-facing strings, accessibility semantics.

For every violation found: fix it directly without asking.

If a violation cannot be fixed without domain knowledge the AI does not have
(e.g. a missing use case that needs business logic defined by the user),
flag it and skip it — do not block on it.

## Step 4 — Verify

- Run `flutter analyze` — must return zero issues.
- Run `flutter test` for any test files covering the target. If tests fail
  due to structural changes, update the tests. Never revert the fix.

## Step 5 — Report

```
Fixed:
- [file:line] rule violated → fix applied

Skipped (requires user input):
- [file] reason

flutter analyze: zero issues ✓
flutter test: N passed ✓
```
