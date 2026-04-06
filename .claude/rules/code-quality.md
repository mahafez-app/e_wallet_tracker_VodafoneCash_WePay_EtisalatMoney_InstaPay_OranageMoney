# Code Quality & Widget Architecture

## General Principles

- **SOLID:** Apply all five principles. Most violated in Flutter:
  - **SRP:** One widget, one responsibility. A screen that fetches, formats,
    and renders violates SRP. Split into provider/notifier (data), mapper
    (formatting),
    widget (rendering).
  - **OCP:** Extend through composition and parameters — never by modifying
    existing widgets directly.
- **KISS & DRY:** Extract shared logic only when it genuinely reduces
  duplication. Duplication is better than the wrong abstraction.
- **Naming:** No abbreviations. Use meaningful, consistent, descriptive names.
  - `PascalCase` for types and classes.
  - `camelCase` for variables, functions, and members.
  - `snake_case` for files and directories.
- **`final` by Default:** Declare every variable `final` unless reassignment
  is explicitly required. Mutability must be justified, not the default.
- **Function Length:** Keep all functions under 20 lines. One function = one
  responsibility.
- **Line Length:** 80 characters maximum.
- **No Silent Failures:** Every error must be handled explicitly. Empty
  `catch` blocks are forbidden.
- **No Trailing Comments:** Explanatory comments go on the line above.
- **No `print`:** Use `dart:developer`'s `log()` for all logging.
- **No Magic Numbers or Inline Styles:** Never hardcode spacing, font sizes,
  or colors directly in widget trees.

```dart
// Wrong
Padding(padding: EdgeInsets.all(16), child: ...)

// Correct
Padding(padding: EdgeInsets.all(AppSpacing.medium), child: ...)
Text('Hello', style: Theme.of(context).textTheme.titleLarge)
```

- **No hardcoded user-facing strings:** Every string visible to the user must
  come from `AppLocalizations`. Access via `AppLocalizations.of(context)!`
  — the `!` is correct and expected when localization delegates are
  configured in `main.dart`. Never guard with `if (l10n == null)` or return
  a fallback widget — if localization is missing the app is misconfigured
  and should fail loudly, not silently return `SizedBox.shrink()`.

```dart
// Wrong
Text('Continue')
Text('Social Media Downloader')
ElevatedButton(child: const Text('Get Started'), ...)

// Correct
Text(l10n.continueButton)
Text(l10n.appName)
ElevatedButton(child: Text(l10n.getStarted), ...)

// Access l10n in a widget:
final l10n = AppLocalizations.of(context)!;
```

---

## Widget Architecture

- **Check `core/widgets/` Before Building Any UI Component:** Before
  implementing any button, input field, loader, dialog, card, empty state,
  or error view — check `core/widgets/` first. If a suitable component
  exists, use it. If it needs a small customization that will not break
  existing usages, add an optional parameter to the core widget. If the
  customization is feature-specific, create a feature-level wrapper that
  uses the core widget internally. Never duplicate a core widget.
- **`StatelessWidget` by Default:** Only upgrade to `StatefulWidget` for local
  ephemeral state (animation controllers, focus nodes, `PageController`).
  Business or shared state belongs in Riverpod providers — never in `setState`.
- **Decompose by Responsibility, Not by Size:** Every distinct UI section is
  its own `StatelessWidget`. Do not wait for a widget to grow large before
  decomposing — decompose by intent from the start. A screen with a header,
  a form, and a button list has three responsibilities from line one.
- **Private widget vs separate file — the rule:**
  - Keep a widget private in the same file **only** when it is under ~30
    lines, used exactly once, and has no standalone meaning outside its
    parent.
  - Extract to a separate file in `widgets/` as soon as a widget exceeds
    ~30 lines, is used more than once, or represents a named UI concept.
  - Group related widget files in subfolders by concern:
    `widgets/history/`, `widgets/form/`, `widgets/download/`.
- **No Private Helper Methods Returning Widgets:** Never use `Widget _buildHeader()`.
  These bypass Flutter's element tree optimisation. Extract as `StatelessWidget`.

```dart
// Wrong — everything inline, no decomposition
Column(
  children: [
    Image.asset(AppAssets.logo),
    Text(l10n.appName, style: ...),
    Text(l10n.tagline, style: ...),
    ElevatedButton(onPressed: ..., child: Text(l10n.getStarted)),
  ],
)

// Correct — each section is a named, focused widget
Column(
  children: [
    const _AppLogo(),
    const _AppTagline(),
    const _GetStartedButton(),
  ],
)

class _AppLogo extends StatelessWidget {
  const _AppLogo({super.key});

  @override
  Widget build(BuildContext context) =>
      Image.asset(AppAssets.logo, width: 120);
}

class _AppTagline extends StatelessWidget {
  const _AppTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(l10n.appName, style: Theme.of(context).textTheme.titleLarge),
        Text(l10n.tagline, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
```

- **`super.key` on Every Constructor:** Every widget constructor must declare
  `{super.key}` — including private widgets. Constructor declaration only.

- **Never pass `Key`, `ValueKey`, `ObjectKey`, or `UniqueKey` at a call
  site** unless the widget is a direct child of `ListView.builder`,
  `SliverList`, or another indexed builder where Flutter cannot reconcile
  by position. In every other context — switch arms, `if`/`else` trees,
  `Consumer`/`ref.watch`-driven builders, fixed positions — passing a key
  is wrong and must be removed.
- **`build()` is Pure:** No calculations, transformations, or filtering inside
  `build()`. All derived data is computed before it is called.
- **Screen Structure — strict two-layer split:**
  A `Screen` widget contains only `Scaffold`, `AppBar`, `SafeArea`, and
  top-level navigation structure. Nothing else. `Consumer`, `ref.listen`,
  state-driven switch logic, and all UI rendering belong in
  a private `_ScreenNameBody` widget — never in the Screen itself. The body
  widget is always named `_[ScreenName]Body`. Never `View`, `Content`, or
  `Page`.

- **`const` Everywhere:** Use `const` on all widgets and values that do not
  depend on runtime data.
- **`SizedBox` vs `Container`:** `SizedBox` for sizing/spacing. `Container`
  only for decoration, clipping, or combined constraints.
- **`ListView.builder` for All Lists:** Never `ListView(children: [])` for
  dynamic content. Always use `ListView.builder` with explicit `itemCount`.
- **Keys in Lists:** Use `ValueKey` for unique id, `ObjectKey` for object
  identity in dynamic lists only. Never `UniqueKey` inside `build()`.
  Never pass keys to static widgets in fixed positions.
- **`compute()` for Heavy Work:** Offload large dataset processing, image
  manipulation, or crypto. Do not use for `json_serializable` parsing.

---

## UI Quality Standards

Generated UI must reflect production quality. The following are non-negotiable
regardless of feature complexity.

- **Use Material 3 components correctly:** Prefer `FilledButton` for primary
  actions, `OutlinedButton` for secondary, `TextButton` for tertiary. Never
  use raw `ElevatedButton` for primary CTAs in M3 apps.
- **Typography hierarchy:** Every screen must have a clear visual hierarchy
  using `displayLarge`/`titleLarge` for headings, `bodyLarge`/`bodyMedium`
  for content, `labelSmall` for supporting text. Never use the same style
  for all text.
- **Spacing is intentional:** Use `AppSpacing` constants only. The rhythm
  between elements must be consistent — section gaps use `AppSpacing.xl`,
  related elements use `AppSpacing.sm`, padding uses `AppSpacing.lg`.
- **No bare `Scaffold` bodies:** Every screen body must have meaningful
  padding, alignment, and structure. A centered `Column` with no padding
  is not acceptable.
- **Interactive elements have feedback:** Every tappable element must have
  visual feedback — use `InkWell`, `InkResponse`, or built-in Material
  button ripples. Never use `GestureDetector` for elements that should
  feel like buttons.
