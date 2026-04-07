import 'package:flutter/material.dart';
import 'package:wallet_tracker/generated/l10n.dart';

import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: AppResponsive.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.responsiveWidth,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: AppSpacing.lg.responsiveHeight),
              Text(
                S.of(context).notFoundStatusCode,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: AppSpacing.sm.responsiveHeight),
              Text(
                S.of(context).notFoundPageTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
