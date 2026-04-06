# Visual Design & Theming

- **Material 3 Only:** Always set `useMaterial3: true`. Never mix Material 2
  and Material 3 component APIs.
- **Theme Files in `core/theme/`:** Define all `ThemeData`, `ColorScheme`,
  `TextTheme`, and `ThemeExtension` objects in `core/theme/`. Never define
  theme configuration in `main.dart`.
- **`ColorScheme.fromSeed()`:** Generate the full color palette from a single
  seed color constant defined in `AppColors`. Never hardcode `Color(...)`
  values outside `core/theme/`.
- **Light & Dark Themes:** Always define both `theme` and `darkTheme` in
  `AppTheme`. Control `themeMode` through a Riverpod notifier — never via
  `ChangeNotifier`.
- **Component Themes:** Centralize all component styles in `ThemeData`
  (e.g., `appBarTheme`, `elevatedButtonTheme`, `cardTheme`). Never apply
  inline styles to components that can be themed globally.
- **`ThemeExtension` for Custom Tokens:** Use `AppColorExtension` for semantic
  colors (success, warning, danger) and any brand-specific design tokens that
  are not part of `ColorScheme`. Always provide both light and dark variants
  via named constructors. Access in widgets via
  `Theme.of(context).extension<AppColorExtension>()!`.
- **Text Styles via `textTheme` Only:** Always use
  `Theme.of(context).textTheme`. Never hardcode `TextStyle` values inline.
  Use current M3 names only — never deprecated names (`headline6`,
  `bodyText2`, `subtitle1`, etc.).
- **`WidgetStateProperty`:** Use `WidgetStateProperty.resolveWith` for any
  component style that responds to interaction states (pressed, hovered,
  disabled, focused). Use `withValues(alpha:)` for opacity — `withOpacity`
  is soft-deprecated in Flutter 3.27+.

## AppColors

Define all project colors as constants in `core/theme/app_colors.dart`.
The file must contain:

- `seedColor` — the single source for `ColorScheme.fromSeed()`.
- Semantic colors: `success`, `warning`, `danger` — used by
  `AppColorExtension`, never referenced directly in widgets.

Colors are project-specific. Never commit placeholder or example color
values to a shared rules file. Update `AppColors` to match the actual
brand palette before starting UI work.

## AppSpacing

Define all spacing constants in `core/theme/app_spacing.dart` as a
consistent scale: `xs`, `sm`, `md`, `lg`, `xl`, `xxl`. All `EdgeInsets`,
`SizedBox`, and `Padding` values in widget trees must reference these
constants — never raw doubles.

## AppTheme

`AppTheme` is a `final class` with `static ThemeData light()` and
`static ThemeData dark()` methods. Both methods must:

- Set `useMaterial3: true`.
- Use `ColorScheme.fromSeed` with the appropriate `brightness`.
- Define `textTheme` with the full M3 typographic scale.
- Register `AppColorExtension` in `extensions`.

## Theme Provider

`ThemeNotifier` is a thin `Notifier<ThemeMode>` in
`core/theme/providers/theme_notifier.dart`. Expose `setLight()`, `setDark()`,
and `toggle()`. Wire to `MaterialApp.router` via a top-level
`ConsumerWidget` that watches `themeModeProvider`.
