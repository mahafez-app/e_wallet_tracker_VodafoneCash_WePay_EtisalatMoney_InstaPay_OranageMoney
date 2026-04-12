import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppResponsive.horizontalPadding(AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
