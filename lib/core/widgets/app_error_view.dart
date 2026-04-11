import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../generated/l10n.dart';
import '../error/failures.dart';
import '../theme/app_responsive.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/failure_extension.dart';
import 'app_button.dart';
import 'app_loader.dart';

/// Standard error view for all AsyncError states.
/// Renders a localized message from [Failure] subtypes, falling back to
/// [S.of(context).errorUnknown] for untyped errors.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error is Failure
        ? (error as Failure).toLocalizedString(context)
        : S.of(context).errorUnknown;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.responsiveRadius,
              color: theme.colorScheme.error,
            ),
            AppSpacing.md.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.lg.verticalSpace,
              AppButton(label: 'Retry', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}

/// Convenience widget for showing a full-screen async state.
/// Wraps [AppLoader], [AppErrorView], and a content builder.
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.state,
    required this.dataBuilder,
    this.onRetry,
  });

  final AsyncValue<T> state;
  final Widget Function(T data) dataBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (state) {
    AsyncLoading() => const AppLoader(),
    AsyncData(:final value) => dataBuilder(value),
    AsyncError(:final error) => AppErrorView(error: error, onRetry: onRetry),
  };
}
