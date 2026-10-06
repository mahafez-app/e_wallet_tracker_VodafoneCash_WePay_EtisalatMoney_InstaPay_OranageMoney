# Monetization Architecture Notes

## Current state

The repository currently has no subscription, in-app purchase, payment provider, or entitlement implementation, and no previous monetization plan document was present. No pricing, free-tier limits, payment provider, or launch date is defined here.

## Architecture placement

- Wallet-specific paid features and entitlement rules belong in `wallet_product`.
- If payment processing or store billing is introduced as a reusable capability, isolate provider communication in a Layer 2 capability. It must not depend on `wallet_product` or another product.
- The product should consume a capability contract and own decisions about which wallet features require an entitlement.
- `mahafez_app` may host platform setup, purchase/restore entry points, and navigation, but should not own entitlement rules or call billing vendors from feature screens.
- Workspace behavior remains in `workspace_product`; wallet monetization must not create a dependency between the workspace and wallet products.

## Decisions required before implementation

1. Define the paid features and free-tier limits.
2. Choose supported stores and payment provider(s), including web if required.
3. Define entitlement source of truth, restore behavior, refunds, and account transfer behavior.
4. Decide whether entitlements are account-wide or scoped to a wallet/workspace.
5. Specify offline behavior, grace periods, and failure handling.

Until those product decisions are made, keep monetization out of runtime code and package dependencies. Record approved decisions here before implementation begins.
