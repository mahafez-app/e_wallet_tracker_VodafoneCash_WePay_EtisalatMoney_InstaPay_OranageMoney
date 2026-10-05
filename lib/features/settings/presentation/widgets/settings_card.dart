import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow.withAlpha(20),
            blurRadius: 20,
            offset: Offset(0, 5.responsiveHeight),
          ),
        ],
      ),
      child: child,
    );
  }
}
