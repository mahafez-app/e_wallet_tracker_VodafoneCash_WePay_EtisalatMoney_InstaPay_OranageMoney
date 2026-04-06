---
name: setup-project
description: Set up the architecture and core infrastructure of an already-created Flutter project following Feature-First Clean Architecture. Installs approved packages, sets up localization, generates all core infrastructure files, and verifies the project compiles and passes flutter analyze. Use once after `flutter create`: `setup-project`.
---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

Set up the architecture and core infrastructure of the current Flutter project. The project already exists — do not run `flutter create`. The output must compile, passes `flutter analyze`
with zero issues, and conforms to every rule in `.claude/rules/` from line
one.

## Phase 1 — Clean up generated boilerplate

```shell
rm lib/main.dart
rm test/widget_test.dart
mkdir -p assets/images assets/icons
touch assets/images/.gitkeep assets/icons/.gitkeep
```

## Phase 2 — `pubspec.yaml`

Use all packages from the approved packages table in `dependencies.md` at
their latest stable versions. Include `flutter_localizations` and set
`generate: true`. Declare `assets/images/` and `assets/icons/` directories.
Dev dependencies: `flutter_lints`, `json_serializable`, `build_runner`,
`mocktail`, `checks`, `integration_test`.

## Phase 3 — `analysis_options.yaml`

Use the exact configuration defined in `linting-testing.md`.

## Phase 4 — Localization

**`l10n.yaml`**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**`lib/l10n/app_en.arb`** — seed with all error message keys that
`failure_extension.dart` references:
`networkError`, `serverError`, `unauthorizedError`, `forbiddenError`,
`notFoundError`, `cacheError`, `validationError`, `validationErrorWithCode`,
`unknownError`.

## Phase 5 — Core Infrastructure Files

Generate each file following the corresponding rules file. Use the project
folder structure defined in `architecture.md`.

| File                                        | Rules reference                               |
| ------------------------------------------- | --------------------------------------------- |
| `core/error/result.dart`                    | `error-handling.md`                           |
| `core/error/failures.dart`                  | `error-handling.md`                           |
| `core/error/failure_mapper.dart`            | `error-handling.md`                           |
| `core/usecase/usecase.dart`                 | `architecture.md`                             |
| `core/utils/repository_handler.dart`        | `error-handling.md`                           |
| `core/utils/failure_extension.dart`         | `error-handling-flow.md`                      |
| `core/utils/app_assets.dart`                | `ui.md`                                       |
| `core/theme/app_colors.dart`                | `theming.md`                                  |
| `core/theme/app_spacing.dart`               | `theming.md`                                  |
| `core/theme/app_breakpoints.dart`           | `ui.md`                                       |
| `core/theme/app_color_extension.dart`       | `theming.md`                                  |
| `core/theme/app_theme.dart`                 | `theming.md`                                  |
| `core/theme/providers/theme_notifier.dart`  | `state-management.md`, `theming.md`           |
| `core/router/app_routes.dart`               | `routing.md`                                  |
| `core/router/go_router_refresh_stream.dart` | `routing.md`                                  |
| `core/router/app_router.dart`               | `routing.md`                                  |
| `core/providers/core_providers.dart`        | `architecture.md`                             |
| `lib/main.dart`                             | `theming.md`, `routing.md`, `architecture.md` |

## Phase 6 — Base Test Structure

Create `test/` mirroring `lib/` as defined in `linting-testing.md`.
Generate `test/core/error/failure_mapper_test.dart` with tests covering:
connection error → `NetworkFailure`, server error → `ServerFailure` with
status code, unknown error → `UnknownFailure`.

## Phase 7 — Verify

```shell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```

All commands must complete with zero errors before reporting done.

## Phase 8 — Report

- List every file created.
- Confirm `flutter analyze` zero issues.
- Confirm `flutter test` passed.
- Next steps:
  ```
  1. Run `new-feature [name]` to scaffold your first feature.
  2. Update AppColors.seedColor in core/theme/app_colors.dart.
  3. Add your API base URL to core/providers/core_providers.dart Dio setup.
  4. Replace the placeholder route in core/router/app_router.dart.
  ```
