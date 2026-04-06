---
name: new-feature
description: Scaffold a new feature following the architecture and rules defined in .claude/rules/. Only creates the layers the feature actually needs. Use: `new-feature auth`, `new-feature splash`, `new-feature order-history`.
---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

Scaffold a new feature. Read `.claude/rules/architecture.md` for the folder
structure, layer rules, and provider wiring pattern. All generated code must conform to
every file in `.claude/rules/`. KISS applies — only create what the feature
actually requires.

## Step 1 — Confirm the feature name

- `snake_case` for files and directories.
- `PascalCase` for class names.

## Step 2 — Analyse what layers this feature needs

Answer from context. Only ask the user if genuinely impossible to determine:

| Question                                               | If yes → create         | If no → skip            |
| ------------------------------------------------------ | ----------------------- | ----------------------- |
| Does the feature fetch or write remote/local data?     | `data/` layer           | No `data/` layer        |
| Does the feature have business rules or entities?      | `domain/` layer         | No `domain/` layer      |
| Does the feature need a use case to orchestrate logic? | `domain/usecases/`      | No use cases            |
| Does the feature have state beyond simple navigation?  | `providers/` logic file | Plain `StatelessWidget` |

**Examples:**

- `splash` → UI only. `presentation/` only. No providers file.
- `auth` → Remote API, entity, use cases. All layers.
- `settings` (local prefs) → `data/` + `presentation/`. No domain layer.
- `profile` (display passed data) → `presentation/` only.

If still unclear: "Does [feature] fetch or write data from an API or local storage?"

## Step 3 — Create only the folders and files justified by Step 2

Use the folder structure defined in `architecture.md` as the reference.
Only instantiate the layers determined in Step 2.

If the feature has state:

- Create `providers/feature_name_providers.dart` for data/domain dependency
  wiring.
- Create `presentation/providers/[feature]_controller.dart` for UI state logic.
- Keep these two files separated; do not merge DI wiring with UI state logic.
- Do not create `*_state.dart` unless the exception criteria in
  `state-management.md` are met and documented.

## Step 4 — Generate each file

Follow every rule in `.claude/rules/` for the file type being created:

- Entities, repositories, use cases → `architecture.md`
- Models, serialization → `data-serialization.md`
- Notifiers/Providers (single logic file) → `state-management.md`
- Screens, widgets → `code-quality.md`, `ui.md`
- Error handling in repositories → `error-handling.md`
- All code → `dart-best-practices.md`, `linting-testing.md`

## Step 5 — Register Providers

Follow `architecture.md` provider wiring rules. Skip entirely if the feature
is pure UI.

## Step 6 — Register route

Follow `routing.md`. Route builders should return screens directly. Feature
state is consumed inside the screen body through `ref.watch`/`ref.listen`.

## Step 7 — Report

- Analysis: which layers were created and why, which were skipped and why.
- Every file created.
- Providers added (or "None — pure UI feature").
- Route constant and path added.
- What still needs to be filled in.
