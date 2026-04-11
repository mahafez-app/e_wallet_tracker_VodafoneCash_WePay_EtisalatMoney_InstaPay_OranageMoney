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
        Text(
          l10n.transaction_notes,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onAddTap,
          icon: Icon(Icons.add_rounded, size: 16.responsiveRadius),
          label: Text(l10n.transaction_addNote),
          style: TextButton.styleFrom(
            padding: AppResponsive.symmetricPadding(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
          ),
        ),
      ],
    );
  }
}
