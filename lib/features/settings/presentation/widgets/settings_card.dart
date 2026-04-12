import 'package:flutter/material.dart';

import '../../../../core/theme/app_color_extension.dart';
import '../../../../core/theme/app_responsive.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 20.responsiveRadius,
            offset: Offset(0, 10.responsiveHeight),
          ),
        ],
      ),
      child: child,
    );
  }
}
