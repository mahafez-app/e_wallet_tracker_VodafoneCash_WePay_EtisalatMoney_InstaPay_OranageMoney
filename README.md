# Mahafez App

Layer 4 Experience application for Mahafez. The app is the runtime shell: it initializes platform services, owns the application router, composes product packages, handles OS permissions and lifecycle integration, and stores app-specific preferences.

## Product composition

- `wallet_product`: wallets, transaction history and reports, plus wallet-aware SMS workflows.
- `identity_product`: sign-in, sign-up and profile completion.
- `workspace_product`: workspaces, memberships, invitations and workspace settings.

The app depends directly on Layer 1 packages and Layer 3 products. Layer 2 capabilities are consumed through the products that own their use; the app has no direct Layer 2 package dependency. Firebase and device APIs used by the shell are wired at the app composition/bootstrap boundary.

## App-owned responsibilities

- Route table and application navigation orchestration (`lib/core/router`).
- Startup and dependency composition (`lib/app_bootstrap.dart`, `lib/core/di`, providers).
- Platform permission prompts, app lifecycle and connectivity signals.
- App preferences and shell-level home composition.

Product entry points are registered in the app router and package APIs are imported through their public barrels. The app supplies `WorkspaceNavigation` callbacks that translate workspace navigation requests into app-owned `GoRouter` operations. See [`docs/ARCHITECTURE_AUDIT.md`](docs/ARCHITECTURE_AUDIT.md).

## Development

Use the Flutter/Dart versions constrained by `pubspec.yaml`. The GitHub Actions architecture workflow checks package boundaries, lock refs and Flutter analysis. Tests, platform builds and end-to-end flows remain pending release verification; see [`MODULARIZATION_PLAN.md`](MODULARIZATION_PLAN.md).
