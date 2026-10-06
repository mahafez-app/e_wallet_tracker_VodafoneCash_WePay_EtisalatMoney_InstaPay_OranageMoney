# Mahafez

Mahafez is a Flutter platform for tracking personal and shared e-wallet activity in Egypt. It organizes the mobile application and reusable code into independent repositories using a four-layer platform architecture.

## Platform architecture

```text
Layer 4 — Experience       mahafez_app
              ↓
Layer 3 — Products         wallet_product · identity_product · workspace_product
              ↓
Layer 2 — Capabilities     sms_engine · identity_service
              ↓
Layer 1 — Platform         mahafez_core · mahafez_design_system
```

Dependencies point downward only. Products do not depend on peer products. The app shell composes the products and owns application route registration, startup and platform integration. Wallets and their transaction ledger are one product; workspace-to-wallet composition passes neutral identifiers and summary contracts through the app.

## Repositories

- [mahafez_app](https://github.com/mahafez-app/mahafez_app) — Layer 4 Flutter shell and app composition.
- [wallet_product](https://github.com/mahafez-app/wallet_product) — Layer 3 wallets, transaction ledger, reports and wallet-specific SMS integration.
- [identity_product](https://github.com/mahafez-app/identity_product) — Layer 3 authentication and profile experiences.
- [workspace_product](https://github.com/mahafez-app/workspace_product) — Layer 3 workspace and invitation product.
- [sms_engine](https://github.com/mahafez-app/sms_engine) — Layer 2 generic SMS parsing and matching capability.
- [identity_service](https://github.com/mahafez-app/identity_service) — Layer 2 headless identity capability.
- [mahafez_core](https://github.com/mahafez-app/mahafez_core) — Layer 1 pure Dart contracts and utilities.
- [mahafez_design_system](https://github.com/mahafez-app/mahafez_design_system) — Layer 1 shared design tokens and UI primitives.

## Architecture status

The package dependency checks cover dependency direction, product isolation, app-to-capability boundaries, public imports and pinned Git refs. Workspace navigation uses the host-provided `WorkspaceNavigation` contract, and the architecture gate rejects router dependencies/usages in Layer 3 products. `workspace_product` v2.0.0 is merged and published; the app pins it. The gate and Flutter analyzers pass, and the existing app tests pass. Supported platform builds and end-to-end wallet, workspace and identity verification remain before an app release tag.

For the detailed evidence and remediation list, see [the architecture audit](https://github.com/mahafez-app/mahafez_app/blob/main/docs/ARCHITECTURE_AUDIT.md). Each repository contains its own README describing its layer, responsibilities and public usage.
