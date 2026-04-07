import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/theme/app_responsive.dart';
import 'package:wallet_tracker/core/utils/app_constants.dart';

class AppLogoName extends StatelessWidget {
  const AppLogoName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppConstants.appNameArabic,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            height: 1.0,
            fontSize: 48.responsiveFont,
            letterSpacing: -1.20.responsiveWidth,
          ),
        ),
        SizedBox(height: 8.responsiveHeight),
        Text(
          AppConstants.appNameEnglish,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            fontSize: 14.responsiveFont,
            height: 1.43,
            letterSpacing: 2.80.responsiveWidth,
          ),
        ),
      ],
    );
  }
}
