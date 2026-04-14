import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_responsive.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/extensions/localization_extension.dart';

/// Header row with a "Notes" title and an "Add" button.
class NotesSectionHeader extends StatelessWidget {
  const NotesSectionHeader({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.sticky_note_2_rounded,
          size: 16.responsiveRadius,
          color: theme.colorScheme.primary,
        ),
        AppSpacing.sm.horizontalSpace,
        Text(
          l10n.transaction_notes,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            padding: AppResponsive.symmetricPadding(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12.responsiveRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 14.responsiveRadius,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.xs.horizontalSpace,
                Text(
                  l10n.transaction_addNote,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
