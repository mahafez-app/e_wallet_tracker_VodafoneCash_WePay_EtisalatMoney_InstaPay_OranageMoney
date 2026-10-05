import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: MahafezResponsive.symmetricPadding(
          horizontal: MahafezSpacing.lg,
          vertical: MahafezSpacing.xl,
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
              MahafezSpacing.lg.verticalSpace,
              Text(
                context.l10n.notFoundStatusCode,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              MahafezSpacing.sm.verticalSpace,
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
