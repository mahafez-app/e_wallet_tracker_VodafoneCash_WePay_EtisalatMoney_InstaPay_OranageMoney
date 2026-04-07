# UI — Layout, Responsive Design, Assets, Documentation, Accessibility

---

## Layout Fundamentals

- **`SafeArea` on all screens.** Wrap every screen's root content with
  `SafeArea` at the `Scaffold` body level. Never omit it for visual symmetry
  — notch, status bar, and home indicator intrusions are runtime bugs.

- **`LayoutBuilder` for constraint-based decisions.** Use when layout
  depends on available parent space (columns, breakpoints, card sizes).
  Never use `MediaQuery.of(context).size` for this.

- **`MediaQuery` for device-level data only.** Legal uses:
  - `MediaQuery.paddingOf(context)` — safe area insets
  - `MediaQuery.viewInsetsOf(context)` — keyboard height
  - `MediaQuery.textScalerOf(context)` — text scale factor
  - `MediaQuery.platformBrightnessOf(context)` — system brightness
  - `MediaQuery.sizeOf(context)` — raw screen size (rarely needed)

  Never `MediaQuery.of(context).size` — it rebuilds on any `MediaQueryData`
  change (keyboard appearance, brightness, etc.), not just size changes.

- **`Expanded` vs `Flexible`:**
  - `Expanded` fills all remaining space regardless of child preference.
  - `Flexible` lets the child take at most its allocated flex, but shrinks
    to intrinsic size if it fits.
  - They can coexist in the same `Row`/`Column`.

- **`Spacer` for flexible gaps.** Use in `Row`/`Column` when gap size should
  be proportional to available space. Use `SizedBox` for fixed-size gaps.

- **`Wrap` over `Row` for overflowing children.** When children may exceed
  the available width, `Wrap` with `spacing` and `runSpacing` is correct.
  `Row` with `Overflow` is wrong.

- **`SingleChildScrollView`** only for fixed-size content that may overflow
  on small screens. Never as a substitute for `ListView.builder`.

- **`Stack` / `Positioned` / `Align`:**
  - `Positioned` for edge-anchored placement.
  - `Align` for alignment-based placement inside a `Stack`.
  - `OverlayPortal` for UI that must render above the entire widget tree
    (custom dropdowns, tooltips, contextual menus).

---

## Responsive Breakpoints

Define as named constants. Never hardcode inline. Use `LayoutBuilder` to
select layout variants.

```dart
// core/theme/app_breakpoints.dart
abstract final class AppBreakpoints {
  static const double compact  = 600;   // phone portrait
  static const double medium   = 840;   // phone landscape / small tablet
  static const double expanded = 1200;  // tablet / desktop
}
```

```dart
LayoutBuilder(
  builder: (context, constraints) => switch (constraints.maxWidth) {
    >= AppBreakpoints.expanded => const _DesktopLayout(),
    >= AppBreakpoints.medium   => const _TabletLayout(),
    _                          => const _MobileLayout(),
  },
)
```

---

## No Fixed Pixel Dimensions on Adaptive Elements

- Buttons, cards, inputs, and containers must never have hardcoded `width`
  or `height`. Use `double.infinity`, `Flexible`, `Expanded`, or
  `FractionallySizedBox`.
- Always handle text overflow: every `Text` that could overflow must have
  `overflow: TextOverflow.ellipsis` (single line) or `maxLines` +
  `TextOverflow.ellipsis` (multiline).
- Images use `AspectRatio` + `BoxFit.cover`, or constrain via `Flexible` /
  `Expanded`. Never hardcode pixel dimensions for images.

```dart
// ❌ Hardcoded dimensions
SizedBox(width: 343, height: 52, child: FilledButton(...))

// ✅ Flexible full-width button
FilledButton(onPressed: ..., child: Text(l10n.continueButton))
// (button fills width via theme's minimumSize: Size(double.infinity, 52))
```

---

## Asset Constants (`core/utils/app_assets.dart`)

Never use raw path strings in widget trees.

```dart
abstract final class AppAssets {
  // Images
  static const String logo            = 'assets/images/logo.png';
  static const String onboardingHero  = 'assets/images/onboarding_hero.png';
  static const String emptyState      = 'assets/images/empty_state.png';

  // Icons (SVG)
  static const String iconSuccess     = 'assets/icons/success.svg';
  static const String iconWarning     = 'assets/icons/warning.svg';
  static const String iconEmpty       = 'assets/icons/empty.svg';
}
```

---

## Image Rendering

- **Local images:** `Image.asset(AppAssets.logo)`.
- **Network images:** Always `CachedNetworkImage`. Never `Image.network` for
  content that the user scrolls through. Always provide `placeholder` and
  `errorWidget`.

  ```dart
  CachedNetworkImage(
    imageUrl: post.imageUrl,
    fit: BoxFit.cover,
    placeholder: (_, __) => const AppLoader(),
    errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
  )
  ```

- **SVG assets:** Always `flutter_svg`. Never rasterize SVGs to PNGs for
  use in the app.

  ```dart
  SvgPicture.asset(
    AppAssets.iconSuccess,
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(
      Theme.of(context).colorScheme.primary,
      BlendMode.srcIn,
    ),
  )
  ```

---

## Material 3 Component Usage

| Action type | Component |
|-------------|-----------|
| Primary CTA | `FilledButton` |
| Secondary action | `OutlinedButton` |
| Tertiary / low emphasis | `TextButton` |
| Icon-only primary | `IconButton.filled` |
| Icon-only standard | `IconButton` |
| Floating action | `FloatingActionButton` |
| Persistent bottom nav | `NavigationBar` (M3) |
| Drawer nav | `NavigationDrawer` (M3) |
| Top nav tabs | `TabBar` with `TabBarView` |
| Alerts / feedback | `SnackBar` via `ScaffoldMessenger` |

Never use raw `ElevatedButton` for primary CTAs in M3 apps. Never use
`BottomNavigationBar` — use `NavigationBar`.

---

## Typography Hierarchy

Every screen must establish a clear visual hierarchy:

| Role | TextTheme token |
|------|----------------|
| Page title / hero | `displaySmall` or `headlineMedium` |
| Section heading | `headlineSmall` or `titleLarge` |
| Card title | `titleMedium` |
| Body content | `bodyLarge` |
| Secondary body | `bodyMedium` |
| Caption / metadata | `bodySmall` |
| Button label | `labelLarge` |
| Chip / tag | `labelMedium` |

Never use the same style for all text on a screen. Never use deprecated M2
style names (`headline1–6`, `bodyText1–2`, `subtitle1–2`).

---

## Spacing Rhythm

| Gap context | Constant |
|-------------|----------|
| Between major page sections | `AppSpacing.xl` (24) |
| Between grouped related items | `AppSpacing.md` (12) |
| Between tight related items | `AppSpacing.sm` (8) |
| Page horizontal / vertical padding | `AppSpacing.lg` (16) |
| Inside card / container | `AppSpacing.lg` (16) |
| Between icon and label | `AppSpacing.sm` (8) |

---

## Interactive Feedback

Every tappable element must provide visual feedback:
- Material buttons (all variants) have ripple by default.
- `InkWell` for custom tappable containers. Provide `borderRadius` matching
  the container shape.
- `InkResponse` for icon-area tap targets with custom splash radius.
- Never `GestureDetector` for elements that should feel like buttons — it
  has no ripple and no accessibility role.

```dart
// ✅ Custom tappable card
InkWell(
  onTap: onTap,
  borderRadius: const BorderRadius.all(Radius.circular(16)),
  child: Ink(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
    child: child,
  ),
)
```

---

## Accessibility (A11Y)

### Semantic Labels

Add `Semantics` with `label` on any interactive element lacking visible text:
icon-only buttons, image buttons, `InkWell` or `GestureDetector` without
a text child.

```dart
Semantics(
  label: l10n.semanticsCloseDialog,
  button: true,
  child: IconButton(
    icon: const Icon(Icons.close),
    onPressed: () => Navigator.of(context).pop(),
  ),
)
```

### Decorative Elements

Exclude purely decorative images from the accessibility tree so screen
readers do not announce meaningless content.

```dart
ExcludeSemantics(child: Image.asset(AppAssets.onboardingHero))
```

### Contrast Requirements (WCAG 2.1 AA)

| Text type | Minimum contrast ratio |
|-----------|----------------------|
| Normal text (< 18pt / 14pt bold) | 4.5:1 |
| Large text (≥ 18pt / ≥ 14pt bold) | 3:1 |
| Interactive component boundaries | 3:1 |
| Decorative elements | No requirement |

Verify **both** light and dark themes. `ColorScheme.fromSeed` with M3
typically meets AA by default — verify after any color customization.

### Dynamic Text Scaling

- Verify all screens at the system's largest font size setting.
- Use `TextScaler` for manual font size calculations. Never use the
  deprecated `textScaleFactor`.
- Every `Text` that could overflow at large scales must have `maxLines` and
  `overflow: TextOverflow.ellipsis`, or be wrapped in `Flexible`.
- Never use fixed-height containers for text content.

### Screen Reader Verification

Every new screen must be validated with:
- **TalkBack** (Android) before merging.
- **VoiceOver** (iOS) before merging.

Focus order, labels, and roles must be correct on both platforms.

---

## Documentation

- Write `///` doc comments for all public APIs (classes, methods, fields,
  typedefs, extensions).
- Private code needs comments only when logic is genuinely non-obvious.
- First line: one concise sentence ending with a period.
- Explain **why**, not **what**. The code already shows what.
- No trailing inline comments. Comments go on the line above.

```dart
// ❌ States the obvious
/// Increments the counter.
void increment() => _counter++;

// ✅ Explains the non-obvious constraint
/// Debounce chosen to match the server's minimum rate limit window.
/// Reducing this causes 429 responses under normal typing cadence.
static const Duration _searchDebounce = Duration(milliseconds: 300);
```
