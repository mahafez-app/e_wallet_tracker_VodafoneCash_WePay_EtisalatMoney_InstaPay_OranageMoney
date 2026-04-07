# Code Quality & Widget Architecture

---

## General Principles

- **SOLID — strictly applied:**
  - **SRP:** One widget, one responsibility. One function, one purpose. A
    screen that fetches, formats, and renders violates SRP — split into
    provider (data), mapper if needed (formatting), widget (rendering).
  - **OCP:** Extend through composition and optional parameters. Never modify
    an existing widget or function to accommodate a new use case if it breaks
    or changes existing behavior.
  - **LSP:** Subtypes must be fully substitutable for their parent type.
    If a subtype cannot honor all promises of the interface, the hierarchy
    is wrong.
  - **ISP:** Repository interfaces define only the methods the feature uses.
    Do not create one mega-repository interface for an entire domain.
  - **DIP:** All classes receive dependencies via constructor injection.
    Accessing global singletons inside classes is forbidden.
- **KISS:** Prefer the simplest implementation that correctly solves the
  problem. Complexity must be justified by a real requirement.
- **DRY:** Extract shared logic only when it genuinely reduces duplication.
  Premature abstraction is worse than duplication.

---

## Naming

- `PascalCase` for classes, enums, typedefs, extensions.
- `camelCase` for variables, functions, parameters, named constructors.
- `snake_case` for file names and directory names.
- `SCREAMING_SNAKE_CASE` for compile-time constants.
- No abbreviations. `userAuthenticationController` not `uac`.
  `authRepository` not `repo`.
- Private widgets in a file use a `_` prefix: `_LoginForm`, `_HeaderSection`.
- Feature-specific widgets use feature context: `_DownloadCard`, `_HistoryItem`.
- Core shared widgets use `App` prefix: `AppButton`, `AppTextField`.

---

## Variables & Mutability

- `final` by default for every variable, field, and parameter. Mutability
  must be explicitly justified, not the default.
- `const` on all compile-time-known values: widget constructors, string
  literals, numerical constants, empty collections.
- No `late` unless the field is genuinely initialized before first use and
  cannot be made nullable or assigned in the constructor. Overuse trades
  compile-time safety for runtime crashes.
- No `dynamic`. Use generics, `Object?`, sealed types, or explicit casts.

---

## Functions & Methods

- Maximum 20 lines per function. One function = one responsibility. Extract
  immediately when the limit is reached.
- Arrow `=>` only when the entire body is a single expression. Never for
  multi-line ternaries or `switch` blocks.
- No trailing inline comments. Explanatory comments go on the line above the
  code they describe.
- No `print`. Use `dart:developer`'s `log()` with a descriptive `name`.

---

## Error Handling

- No silent failures. Every error path is handled explicitly.
- No empty `catch` blocks. Catching an exception and ignoring it is forbidden.
- No `catch (e)` without `log()`-ing the error.
- No `!` operator unless non-null is structurally guaranteed at that exact
  point in the type system.
- For `AppLocalizations.of(context)!` — the `!` is correct and expected when
  localization delegates are configured properly in `main.dart`. Never guard
  with `if (l10n == null)` or silently fall back to a `SizedBox.shrink()`.
  A missing localization delegate is a configuration error — fail loudly.

---

## No Hardcoded Values in Widget Trees

```dart
// ❌ Hardcoded spacing
Padding(padding: EdgeInsets.all(16), child: ...)

// ✅ Named constant
Padding(padding: EdgeInsets.all(AppSpacing.md), child: ...)

// ❌ Hardcoded typography
Text('Hello', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))

// ✅ Theme-driven
Text('Hello', style: Theme.of(context).textTheme.titleLarge)

// ❌ Hardcoded color
Container(color: Color(0xFF1A73E8))

// ✅ ColorScheme
Container(color: Theme.of(context).colorScheme.primary)

// ❌ Hardcoded string
Text('Continue')

// ✅ Localized
Text(AppLocalizations.of(context)!.continueButton)
```

---

## Widget Architecture

### `StatelessWidget` by Default

Upgrade to `StatefulWidget` only for local ephemeral state:

- `AnimationController` / `Animation<T>`
- `TextEditingController`
- `FocusNode`
- `PageController` / `ScrollController`
- `TabController`

Business state and shared state belong in Riverpod — never in `setState`.

### Decompose by Responsibility, Not by Size

Every distinct UI section is its own named `StatelessWidget`. Do not wait
for a widget to grow large before decomposing. A screen with a header, a
form, and a button list has three responsibilities from line one.

### Private vs Separate File

| Condition                                         | Decision                                        |
| ------------------------------------------------- | ----------------------------------------------- |
| < ~30 lines, used once, tightly coupled to parent | Private in same file (`_WidgetName`)            |
| > ~30 lines                                       | Extract to `widgets/` file                      |
| Used more than once                               | Extract to `widgets/` file                      |
| Represents a named UI concept                     | Extract to `widgets/` file                      |
| Screen file > 200 lines                           | Mandatory extraction to `presentation/widgets/` |
| Feature has many widgets                          | Group in `widgets/concern/` subfolders          |

When a feature contains multiple screens, do not keep all files directly
under `presentation/screens/`. Create grouping folders under `screens/`
and place related screens together.

### No Private Helper Methods Returning Widgets

```dart
// ❌ Helper method — bypasses Flutter's element tree optimisation
Widget _buildHeader() => Text('...');

// ✅ Named StatelessWidget
class _Header extends StatelessWidget {
  const _Header({super.key});
  @override
  Widget build(BuildContext context) => Text('...');
}
```

### `super.key` on Every Constructor

Every widget constructor must declare `{super.key}` — including private
widgets. This enables key-based reconciliation in the element tree.

```dart
class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});
  // ...
}
```

### Key Usage Rules

- **Never** pass `Key`, `ValueKey`, `ObjectKey`, or `UniqueKey` at a call
  site unless the widget is a direct child of `ListView.builder`,
  `SliverList`, `GridView.builder`, or another indexed builder where Flutter
  cannot reconcile by position.
- In `switch` arms, `if`/`else` trees, and `Consumer`/`ref.watch`-driven
  builders, passing a key is wrong — remove it.
- Never use `UniqueKey()` inside `build()`. It defeats reconciliation.

### Screen Structure — Mandatory Two-Layer Split

```dart
// ✅ Correct screen structure
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context)!.loginTitle)),
    body: SafeArea(child: const _LoginBody()),
  );
}

// _LoginBody owns: Consumer/ref.listen, state-driven switch, all rendering
class _LoginBody extends ConsumerWidget {
  const _LoginBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<UserEntity?>>(authControllerProvider, (_, next) {
      // side effects here
    });

    final state = ref.watch(authControllerProvider);
    return switch (state) {
      AsyncLoading() => const AppLoader(),
      AsyncData()   => const _LoginForm(),
      AsyncError()  => const _LoginForm(),
    };
  }
}
```

The `Screen` widget contains **only**: `Scaffold`, `AppBar`, `SafeArea`, and
top-level navigation structure. `Consumer`, `ref.listen`, state-driven
`switch`, and all rendering belong in `_[ScreenName]Body`. Body widgets are
always named `_[ScreenName]Body` — never `View`, `Content`, or `Page`.

### `build()` is Pure

No calculations, transformations, filtering, or heavy operations inside
`build()`. All derived data is computed before `build()` is called (in the
provider or constructor arguments).

---

## UI Quality Standards

- **Material 3 components correctly:** `FilledButton` for primary actions,
  `OutlinedButton` for secondary, `TextButton` for tertiary. Never use
  raw `ElevatedButton` for primary CTAs in M3 apps.
- **Typography hierarchy:** Every screen must have a clear visual hierarchy.
  Use `displayLarge`/`titleLarge` for headings, `bodyLarge`/`bodyMedium` for
  content, `labelSmall` for supporting text. Never use one style for all text.
- **Spacing rhythm:** Section gaps use `AppSpacing.xl`, related elements use
  `AppSpacing.sm`, padding uses `AppSpacing.lg`. Never mix raw doubles.
- **No bare `Scaffold` bodies:** Every screen body must have meaningful
  padding, alignment, and structure.
- **Interactive feedback:** Every tappable element must have visual feedback.
  Use `InkWell`, `InkResponse`, or Material button ripples. Never use
  `GestureDetector` for elements that should feel like buttons.

---

## `const` Rules

- `const` on every widget constructor call where all arguments are
  compile-time constants.
- `const` on every `EdgeInsets`, `BorderRadius`, `Duration`, `TextStyle`
  that uses only known constants.
- `const` on empty collections: `const []`, `const {}`.
- If a widget takes at least one runtime argument, the constructor call
  cannot be `const` — this is expected and correct.

---

## Container vs SizedBox

- `SizedBox` for fixed sizing and fixed-dimension spacing gaps.
- `Container` only when decoration, clipping, or combined constraints are
  needed simultaneously. Never use `Container` as a plain sizing wrapper.

---

## List Rendering

- `ListView.builder` with explicit `itemCount` for all dynamic lists.
  Never `ListView(children: [...])` for lists of unknown length.
- `GridView.builder` for grids. Same rule.
- `ValueKey(item.id)` for list items with unique IDs in dynamic lists.
- `ObjectKey(item)` for object identity when no unique ID exists.
- Never `UniqueKey()` in list builders — defeats efficient reconciliation.
- Never pass keys to static widgets in fixed positions.

---

## Heavy Computation

- `compute()` for large dataset processing, image manipulation, cryptographic
  operations, and parsing large files.
- Do not use `compute()` for standard `json_serializable` parsing — it adds
  overhead without benefit for normal-sized payloads.
