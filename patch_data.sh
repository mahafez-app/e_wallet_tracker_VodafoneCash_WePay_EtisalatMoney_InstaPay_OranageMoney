#!/bin/bash
sed -i '' '/lastBalanceAt: timestamp/a \
- `totalReceived`: number \
- `totalSent`: number' mahafez_app_spec.md

sed -i '' '/createdAt: timestamp/a \
- `totalReceived`: number \
- `totalSent`: number\
- `walletsCount`: number\
- `latestActivityAt`: timestamp' mahafez_app_spec.md

sed -i '' '/joinedAt: timestamp/i \
- `uid`: string' mahafez_app_spec.md
