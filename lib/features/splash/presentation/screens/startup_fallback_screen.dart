import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/app_logo_name.dart';
class StartupFallbackScreen extends StatelessWidget {
  const StartupFallbackScreen({
    super.key,
    required this.isRetrying,
    required this.onRetry,
  });

  final bool isRetrying;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return _StartupFallbackScaffold(isRetrying: isRetrying, onRetry: onRetry);
  }
}

class _StartupFallbackScaffold extends StatelessWidget {
  const _StartupFallbackScaffold({
    required this.isRetrying,
    required this.onRetry,
  });

  final bool isRetrying;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _StartupFallbackBody(isRetrying: isRetrying, onRetry: onRetry),
      ),
    );
  }
}

class _StartupFallbackBody extends StatelessWidget {
  const _StartupFallbackBody({this.isRetrying = false, this.onRetry});

  final bool isRetrying;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: MahafezSpacing.pagePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo(
            size: MahafezSpacing.xxxl.responsiveWidth * 3,
            shape: AppLogoShape.circle,
          ),
          MahafezSpacing.xl.verticalSpace,
          const AppLogoName(),
          MahafezSpacing.xxl.verticalSpace,
          Text(
            context.l10n.startupFallbackTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          MahafezSpacing.md.verticalSpace,
          Text(
            context.l10n.startupFallbackMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          MahafezSpacing.xxl.verticalSpace,
          MahafezButton(
            label: context.l10n.startupFallbackRetryAction,
            onPressed: onRetry == null ? null : () => onRetry!(),
            isLoading: isRetrying,
          ),
        ],
      ),
    );
  }
}
