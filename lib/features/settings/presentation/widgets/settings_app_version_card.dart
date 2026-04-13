// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import 'settings_card.dart';
import 'settings_compact_tile.dart';

class SettingsAppVersionCard extends StatelessWidget {
  const SettingsAppVersionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      child: SettingsCompactTile(
        icon: Icons.info_outline_rounded,
        title: context.l10n.userSettingsAppVersionLabel,
        trailingLabel: AppConstants.appVersion,
        showChevron: false,
      ),
    );
  }
}
