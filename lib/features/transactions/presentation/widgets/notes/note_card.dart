// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../../core/theme/app_color_extension.dart';
import '../../../../../../core/theme/app_responsive.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/note_entity.dart';
import '../../providers/notes/notes_section_controller.dart';
import 'note_input_field.dart';
import 'note_read_view.dart';

/// A single note card that toggles between read and edit mode.
///
/// Local [StatefulWidget] owns only the [TextEditingController].
/// The boolean edit-mode flag and all Firestore mutations are delegated to
/// [NotesSectionController].
class NoteCard extends ConsumerStatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.isOwner,
    required this.transaction,
  });

  final NoteEntity note;
  final bool isOwner;
  final TransactionEntity transaction;

  @override
  ConsumerState<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<NoteCard> {
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.note.text);
  }

  bool get _isEditing =>
      ref
          .read(notesSectionControllerProvider(widget.transaction))
          .editingNoteId ==
      widget.note.id;

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.note.text != widget.note.text) {
      _editController.text = widget.note.text;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    _editController
      ..text = widget.note.text
      ..selection = TextSelection.collapsed(offset: widget.note.text.length);
    _notifier.enterEditMode(widget.note.id);
  }

  void _exitEditMode() => _notifier.exitEditMode();

  Future<void> _saveEdit() async {
    await _notifier.editNote(
      noteId: widget.note.id,
      text: _editController.text,
    );
  }

  NotesSectionController get _notifier =>
      ref.read(notesSectionControllerProvider(widget.transaction).notifier);

  bool get _isSaving =>
      ref
          .watch(notesSectionControllerProvider(widget.transaction))
          .savingNoteId ==
      widget.note.id;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: AppResponsive.onlyPadding(bottom: AppSpacing.sm),
      padding: AppResponsive.allPadding(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child:
          ref
                  .watch(notesSectionControllerProvider(widget.transaction))
                  .editingNoteId ==
              widget.note.id
          ? _EditingContent(
              controller: _editController,
              isSaving: _isSaving,
              onSave: _saveEdit,
              onCancel: _exitEditMode,
            )
          : NoteReadView(
              note: widget.note,
              isOwner: widget.isOwner,
              onEditTap: _enterEditMode,
              onDeleteTap: () =>
                  _notifier.deleteNote(widget.note.id, widget.note.text),
            ),
    );
  }
}

// ── Editing content ───────────────────────────────────────────────────────────

class _EditingContent extends StatelessWidget {
  const _EditingContent({
    super.key,
    required this.controller,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NoteInputField(
          controller: controller,
          isBusy: isSaving,
          onSubmit: onSave,
        ),
        AppSpacing.xs.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: onCancel,
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        ),
      ],
    );
  }
}
