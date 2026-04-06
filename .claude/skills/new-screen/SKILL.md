---
name: new-screen
description: Generate a production-ready screen with its Riverpod provider logic inside an existing feature. Use when a feature already exists but needs a new screen: `new-screen login`, `new-screen profile-details`, `new-screen order-summary`.
---

Before executing any step, re-read `CLAUDE.md` to ensure the persona,
production standards, and interaction rules are active for this task.

Generate a new screen inside an existing feature. All generated code must
conform to every file in `.claude/rules/`.

## Step 1 — Identify the target feature

Determine from context. If not clear, ask: "Which feature does this screen
belong to?" This is the one permitted clarification question.

## Step 2 — Create the files

Follow the folder structure defined in `architecture.md`.

## Step 3 — Generate each file

- **Provider logic file** — follow `state-management.md` and `error-handling-flow.md`.
- **Screen** — follow `code-quality.md`, `ui.md`, and `error-handling-flow.md`.

The provider logic file must live in `presentation/providers/` (for example,
`[feature]_controller.dart` or `[feature]_provider.dart`) and focus only on UI
state orchestration. Dependency wiring stays in
`providers/feature_name_providers.dart`.

Do not create a separate `*_state.dart` file unless the exception criteria in
`state-management.md` are explicitly met and documented.

For screen integration, enforce:

- `ref.watch(provider)` for rendering.
- `ref.read(provider.notifier)` in action handlers.
- `ref.listen(provider, ...)` for one-off side effects.
- `ConsumerStatefulWidget` only when local form/controller state is needed.

## Step 4 — Register route

Follow `routing.md`. Route builders should return screen widgets directly.

## Step 5 — Register feature providers

Add provider wiring in the feature's own
`providers/feature_name_providers.dart` file.
Never register feature wiring in core provider files.

## Step 6 — Report

- List files created.
- State what fields, use cases, and UI components still need to be filled in.
