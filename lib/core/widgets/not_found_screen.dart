import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: AppResponsive.symmetricPadding(
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
              AppSpacing.lg.verticalSpace,
              Text(
                context.l10n.notFoundStatusCode,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              AppSpacing.sm.verticalSpace,
              Text(
                context.l10n.notFoundPageTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
