// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';

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
        _SectionTitle(
          title: context.l10n.transaction_smsText,
          icon: Icons.message_rounded,
        ),
        AppSpacing.md.verticalSpace,
        Stack(
          children: [
            Container(
              padding: AppResponsive.allPadding(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(24.responsiveRadius),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withAlpha(60),
                ),
              ),
              child: SelectableText(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                  letterSpacing: 0.2,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.responsiveFont,
                ),
              ),
            ),
            Positioned(
              right: 12.responsiveRadius,
              top: 12.responsiveRadius,
              child: Icon(
                Icons.format_quote_rounded,
                color: theme.colorScheme.onSurfaceVariant.withAlpha(30),
                size: 32.responsiveRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16.responsiveRadius,
          color: theme.colorScheme.primary,
        ),
        AppSpacing.sm.horizontalSpace,
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
