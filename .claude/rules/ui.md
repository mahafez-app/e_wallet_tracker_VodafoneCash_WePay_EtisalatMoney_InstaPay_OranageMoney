# UI — Layout, Typography, Assets, Documentation, Accessibility

## Layout Best Practices

- **`SafeArea` on All Screens:** Wrap every screen's root with `SafeArea` at
  the `Scaffold` body level to avoid notch/status bar intrusions.
- **`LayoutBuilder` for Constraints:** Use for layout decisions based on
  available space — not `MediaQuery.of(context).size`.
- **`MediaQuery` for Device-Level Data Only:** Use only for `padding`,
  `viewInsets`, `textScaler`, `platformBrightness`. Use
  `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context).size`
  to avoid full rebuilds on unrelated `MediaQueryData` changes.
- **Responsive Breakpoints:** Define as constants. Never hardcode inline.

```dart
abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= AppBreakpoints.medium) {
      return const _TabletLayout();
    }
    return const _MobileLayout();
  },
)
```

- **`Expanded` vs `Flexible`:** `Expanded` fills all remaining space.
  `Flexible` takes only what it needs but may shrink. They can coexist.
- **`Spacer` for Flexible Gaps:** Use `Spacer` in `Row`/`Column`. Use
  `SizedBox` only for fixed-size gaps.
- **`Wrap`:** Use instead of `Row` when children may overflow the width.
- **`SingleChildScrollView`:** For fixed-size content that may overflow only.
  Never substitute for `ListView.builder`.
- **`Stack` / `Positioned`:** `Positioned` to anchor by edges. `Align` for
  alignment-based placement within a `Stack`.
- **`OverlayPortal`:** Use for UI that must render above the widget tree —
  custom dropdowns, tooltips, contextual menus.

## Responsive Sizing — No Package Required

Never use a third-party package for responsive sizing. Flutter provides all
the tools needed.

- **No fixed `width`/`height` on adaptive elements.** Buttons, cards, and
  containers must never have hardcoded pixel dimensions. Use `double.infinity`,
  `Flexible`, `Expanded`, or `FractionallySizedBox`.
- **`LayoutBuilder` over `MediaQuery` for layout decisions.** Use
  `MediaQuery.sizeOf(context)` only when the raw screen size is genuinely
  needed — never `MediaQuery.of(context).size`.
- **Text overflow must always be handled.** Every `Text` that could overflow
  must have `overflow: TextOverflow.ellipsis` or be wrapped in `Flexible`.
- **Images use `AspectRatio` or `fit`.** Never hardcode pixel dimensions for
  images. Use `AspectRatio` + `BoxFit.cover` or constrain via `Flexible`.

## Color Scheme & Typography

- **WCAG 2.1 Contrast:** Normal text 4.5:1; large text (18pt / 14pt bold) 3:1.
  Verify both light and dark themes.
- **60-30-10 Rule:** 60% dominant/neutral, 30% secondary, 10% accent. Map to
  `ColorScheme` roles: `primary`, `secondary`, `tertiary`.
- **Font Families:** At most two per app. Define inside `AppTheme` — never
  apply `fontFamily` inline in widget trees.
- **Typographic Scale:** All text styles in `ThemeData.textTheme`. Use M3
  names only. Never use deprecated names (`headline6`, `bodyText2`, etc.).

## Assets & Images

- **Asset Constants:** Define all paths in `core/utils/app_assets.dart`.
  Never use raw path strings inline.

```dart
abstract final class AppAssets {
  static const String logo = 'assets/images/logo.png';
  static const String onboardingHero = 'assets/images/onboarding_hero.png';
  static const String iconSuccess = 'assets/icons/success.svg';
}
```

- **Local Images:** `Image.asset(AppAssets.logo)`
- **Network Images — `CachedNetworkImage` by Default:** `Image.network` only
  for one-off cases where caching provides no value. Always provide
  `placeholder` and `errorWidget`.

```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (_, __) => const CircularProgressIndicator.adaptive(),
  errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
)
```

- **SVG Assets:** Use `flutter_svg`. Never rasterize SVGs to PNGs.

```dart
SvgPicture.asset(AppAssets.iconSuccess)
```

## Documentation

- Write `///` doc comments for all public APIs.
- Private code needs comments only when logic is genuinely non-obvious.
- First line: a single concise sentence ending with a period.
- Explain **why**, not **what**. No trailing inline comments.

```dart
// Wrong — restates the obvious
/// Increments the counter by one.
void increment() => _counter++;

// Correct — explains non-obvious constraint
/// Debounce duration chosen to match the server's minimum request interval.
/// Reducing this value will cause 429 responses under normal typing speed.
final debounce = Duration(milliseconds: 300);
```

## Accessibility (A11Y)

- **Semantic Labels:** Add `Semantics` with `label` on any interactive element
  lacking visible text — icon-only buttons, image buttons, `GestureDetector`,
  `InkWell` without a text child.

```dart
Semantics(
  label: 'Close dialog',
  button: true,
  child: IconButton(
    icon: const Icon(Icons.close),
    onPressed: Navigator.of(context).pop,
  ),
)
```

- **Exclude Decorative Elements:** Use `ExcludeSemantics` on purely decorative
  images so screen readers do not announce meaningless content.

```dart
ExcludeSemantics(child: Image.asset(AppAssets.onboardingHero))
```

- **Color Contrast:** Body text 4.5:1. Large text 3:1. Verify both themes.
- **Dynamic Text Scaling:** Test with largest system font size. Use `TextScaler`
  for manual size calculations. Never use deprecated `textScaleFactor`.
- **Screen Reader Testing:** Verify every new screen with TalkBack (Android)
  and VoiceOver (iOS) before shipping.
