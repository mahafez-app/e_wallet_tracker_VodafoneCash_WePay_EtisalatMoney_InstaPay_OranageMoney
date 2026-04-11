import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../generated/l10n.dart';

/// Section 3: raw SMS text in a muted selectable container.
class SmsSection extends StatelessWidget {
  const SmsSection({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: S.of(context).transaction_smsText),
        AppSpacing.sm.verticalSpace,
        Container(
          padding: AppResponsive.allPadding(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
            borderRadius: BorderRadius.circular(16.responsiveRadius),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withAlpha(60),
            ),
          ),
          child: SelectableText(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
  );
}
