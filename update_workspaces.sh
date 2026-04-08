#!/bin/bash
sed -i '' -e 's/s.homeMinutesAgo/s.homeMinutesAgo(diff.inMinutes)/g' \
          -e 's/.replaceAll(.*//g' \
          -e 's/s.homeActiveWallets/s.homeActiveWallets(workspace.activeWalletsCount)/g' \
          lib/features/home/presentation/widgets/home_workspaces_section.dart
