# Visual Design & Theming

---

## Core Rules

- **Material 3 only.** Always set `useMaterial3: true`. Never mix M2 and M3
  component APIs. Never use deprecated M2 component names.
- **Theme files in `core/theme/` only.** Never define `ThemeData`, `ColorScheme`,
  or `TextTheme` in `main.dart`, `app.dart`, or inside feature folders.
- **No inline styles.** Every color, spacing value, text style, and font
  family reference in a widget tree must come from the theme or a named
  constant — never hardcoded.
- **Both themes always.** Always define both `AppTheme.light()` and
  `AppTheme.dark()`. An app with only a light theme is incomplete.
- **`ThemeMode` via Riverpod.** Control theme switching through
  `themeModeProvider` (a `NotifierProvider<ThemeNotifier, ThemeMode>`).
  Never use `ChangeNotifier` for theme state.

---

## File Structure

```
core/theme/
├── app_colors.dart          # Seed color + semantic color constants
├── app_spacing.dart         # Spacing scale constants
├── app_theme.dart           # AppTheme.light() and AppTheme.dark()
├── app_color_extension.dart # ThemeExtension for semantic colors
└── providers/
    └── theme_notifier.dart  # ThemeNotifier + themeModeProvider
```

---

## `AppColors` (`core/theme/app_colors.dart`)

All color constants in one place. `seedColor` is the single source for the
entire `ColorScheme`. Semantic colors are used only through `AppColorExtension`
— never referenced directly in widget trees.

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Single seed for ColorScheme.fromSeed(). Update to match brand palette.
  static const Color seedColor = Color(0xFF1A73E8);

  // Semantic colors — access via Theme.of(context).extension<AppColorExtension>()!
  // Never use these constants directly in widget trees.
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  static const Color danger  = Color(0xFFEA4335);
  static const Color info    = Color(0xFF4285F4);

  // Neutrals (used in ThemeData component themes if needed)
  static const Color grey50  = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey900 = Color(0xFF212121);
}
```

---

## `AppSpacing` (`core/theme/app_spacing.dart`)

All `EdgeInsets`, `SizedBox`, and `Padding` values in widget trees must
reference these constants — never raw doubles.

```dart
abstract final class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Common EdgeInsets
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: xl);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
}
```

---

## `AppColorExtension` (`core/theme/app_color_extension.dart`)

For semantic colors not covered by `ColorScheme` (success, warning, danger,
info) and any brand-specific design tokens. Always provide both light and
dark named constructors. Access in widgets via
`Theme.of(context).extension<AppColorExtension>()!` — never via `AppColors`
constants directly in widget trees.

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

final class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.info,
    required this.infoContainer,
  });

  const AppColorExtension.light()
      : success          = AppColors.success,
        successContainer = const Color(0xFFE6F4EA),
        warning          = AppColors.warning,
        warningContainer = const Color(0xFFFEF7E0),
        danger           = AppColors.danger,
        dangerContainer  = const Color(0xFFFCE8E6),
        info             = AppColors.info,
        infoContainer    = const Color(0xFFE8F0FE);

  const AppColorExtension.dark()
      : success          = const Color(0xFF81C995),
        successContainer = const Color(0xFF1E3A26),
        warning          = const Color(0xFFFDD663),
        warningContainer = const Color(0xFF3A2E00),
        danger           = const Color(0xFFF28B82),
        dangerContainer  = const Color(0xFF3B1614),
        info             = const Color(0xFF8AB4F8),
        infoContainer    = const Color(0xFF0D2A6B);

  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color info;
  final Color infoContainer;

  @override
  AppColorExtension copyWith({
    Color? success, Color? successContainer,
    Color? warning, Color? warningContainer,
    Color? danger, Color? dangerContainer,
    Color? info, Color? infoContainer,
  }) => AppColorExtension(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    danger: danger ?? this.danger,
    dangerContainer: dangerContainer ?? this.dangerContainer,
    info: info ?? this.info,
    infoContainer: infoContainer ?? this.infoContainer,
  );

  @override
  AppColorExtension lerp(AppColorExtension? other, double t) {
    if (other == null) return this;
    return AppColorExtension(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}
```

---

## `AppTheme` (`core/theme/app_theme.dart`)

`final class` with `static ThemeData light()` and `static ThemeData dark()`.

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_color_extension.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
    ),
    textTheme: _textTheme,
    extensions: const [AppColorExtension.light()],
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    extensions: const [AppColorExtension.dark()],
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  // Shared text theme — same scale for both themes, color resolved by brightness
  static const TextTheme _textTheme = TextTheme(
    displayLarge  : TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
    displayMedium : TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall  : TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge : TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall : TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge    : TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium   : TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall    : TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge     : TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium    : TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall     : TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelLarge    : TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelMedium   : TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    labelSmall    : TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );
}
```

---

## Theme Notifier (`core/theme/providers/theme_notifier.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setLight()  => state = ThemeMode.light;
  void setDark()   => state = ThemeMode.dark;
  void setSystem() => state = ThemeMode.system;
  void toggle()    => state = state == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}
```

---

## Accessing Theme in Widgets

```dart
// ColorScheme
final scheme = Theme.of(context).colorScheme;
Container(color: scheme.primary)
Text('...', style: TextStyle(color: scheme.onSurface))

// TextTheme — always via textTheme, never hardcoded
Text('Title', style: Theme.of(context).textTheme.titleLarge)

// Semantic colors via extension
final ext = Theme.of(context).extension<AppColorExtension>()!;
Icon(Icons.check, color: ext.success)

// ❌ Never hardcode
Text('...', style: TextStyle(color: Color(0xFF1A73E8), fontSize: 18))
```

---

## `WidgetStateProperty` — Interactive States

Use `WidgetStateProperty.resolveWith` for component styles that respond to
interaction states. Use `withValues(alpha:)` for opacity — `withOpacity` is
soft-deprecated in Flutter 3.27+.

```dart
FilledButton.styleFrom().copyWith(
  backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.disabled)) {
      return colorScheme.primary.withValues(alpha: 0.38);
    }
    return colorScheme.primary;
  }),
)
```

---

## Typography Rules

- Use M3 names only. **Forbidden deprecated names:**
  `headline1–6`, `bodyText1–2`, `subtitle1–2`, `button`, `caption`,
  `overline`.
- Never apply `fontFamily` inline. Define it once in `ThemeData`.
- At most two font families per app.
- All text that may overflow must have `overflow: TextOverflow.ellipsis`
  or be wrapped in `Flexible`.
