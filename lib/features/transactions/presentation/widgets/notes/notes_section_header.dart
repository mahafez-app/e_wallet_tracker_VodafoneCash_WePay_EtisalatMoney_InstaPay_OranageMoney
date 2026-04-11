import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_responsive.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../generated/l10n.dart';

/// Header row with a "Notes" title and an "Add" button.
class NotesSectionHeader extends StatelessWidget {
  const NotesSectionHeader({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          S.of(context).transaction_notes,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onAddTap,
          icon: Icon(Icons.add_rounded, size: 16.responsiveRadius),
          label: Text(S.of(context).transaction_addNote),
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
