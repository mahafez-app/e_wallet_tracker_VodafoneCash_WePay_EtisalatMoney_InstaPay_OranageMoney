import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet_tracker/features/transactions/domain/entities/note_entity.dart';

import '../../../../../../core/theme/app_color_extension.dart';
import '../../../../../../core/theme/app_responsive.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../generated/l10n.dart';

/// Renders a single note in read mode: text, author line, edit/delete actions.
class NoteReadView extends StatelessWidget {
  const NoteReadView({
    super.key,
    required this.note,
    required this.isOwner,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final NoteEntity note;
  final bool isOwner;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat.MMMd(locale).format(note.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoteTextRow(
          note: note,
          isOwner: isOwner,
          onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
        ),
        AppSpacing.xs.verticalSpace,
        _NoteMetaRow(note: note, dateStr: dateStr, theme: theme),
      ],
    );
  }
}

class _NoteTextRow extends StatelessWidget {
  const _NoteTextRow({
    required this.note,
    required this.isOwner,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final NoteEntity note;
  final bool isOwner;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            note.text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ),
        if (isOwner) ...[
          AppSpacing.xs.horizontalSpace,
          _ActionIconButton(
            icon: Icons.edit_outlined,
            onPressed: onEditTap,
            color: colors.info,
          ),
          _ActionIconButton(
            icon: Icons.delete_outline_rounded,
            onPressed: onDeleteTap,
            color: theme.colorScheme.error,
          ),
        ],
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      iconSize: 18.responsiveRadius,
      padding: AppResponsive.allPadding(8),
      constraints: const BoxConstraints(),
    );
  }
}

class _NoteMetaRow extends StatelessWidget {
  const _NoteMetaRow({
    required this.note,
    required this.dateStr,
    required this.theme,
  });

  final NoteEntity note;
  final String dateStr;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${S.of(context).transaction_by(note.authorName)} · $dateStr',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
          ),
        ),
        if (note.wasEdited) ...[
          AppSpacing.xs.horizontalSpace,
          Text(
            S.of(context).transaction_edited,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
