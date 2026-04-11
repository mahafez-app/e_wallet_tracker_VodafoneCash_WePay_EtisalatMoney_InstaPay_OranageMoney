// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../features/auth/providers/auth_providers.dart';
import '../../providers/notes/notes_controller.dart';
import '../../providers/transaction_details_controller.dart';
import '../notes/note_card.dart';
import '../notes/note_input_field.dart';
import '../notes/notes_section_header.dart';

/// Top-level entry point consumed by [TransactionDetailsBottomSheet].
/// Thin assembler — all state is owned by [NotesController].
class NotesSection extends StatelessWidget {
  const NotesSection({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) =>
      _NotesSectionBody(transaction: transaction);
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _NotesSectionBody extends ConsumerWidget {
  const _NotesSectionBody({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesControllerProvider(transaction));
    final currentUser = ref.watch(authStateChangesProvider).value;
    final notifier = ref.read(notesControllerProvider(transaction).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotesSectionHeader(onAddTap: notifier.toggleAddField),
        if (notesState.showAddField) ...[
          AppSpacing.sm.verticalSpace,
          _AddNoteRow(
            transaction: transaction,
            notifier: notifier,
            isAdding: notesState.isAdding,
          ),
          AppSpacing.sm.verticalSpace,
        ],
        _NotesList(transaction: transaction, currentUserUid: currentUser?.uid),
      ],
    );
  }
}

// ── Notes list ────────────────────────────────────────────────────────────────

class _NotesList extends ConsumerWidget {
  const _NotesList({
    super.key,
    required this.transaction,
    required this.currentUserUid,
  });

  final TransactionEntity transaction;
  final String? currentUserUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(
      transactionDetailsControllerProvider(transaction).select((s) => s.notes),
    );

    return Column(
      children: notes
          .map(
            (note) => NoteCard(
              key: ValueKey(note.id),
              note: note,
              isOwner: currentUserUid == note.authorUid,
              transaction: transaction,
            ),
          )
          .toList(),
    );
  }
}

// ── Add note row ──────────────────────────────────────────────────────────────

class _AddNoteRow extends ConsumerStatefulWidget {
  const _AddNoteRow({
    super.key,
    required this.transaction,
    required this.notifier,
    required this.isAdding,
  });

  final TransactionEntity transaction;
  final NotesController notifier;
  final bool isAdding;

  @override
  ConsumerState<_AddNoteRow> createState() => _AddNoteRowState();
}

class _AddNoteRowState extends ConsumerState<_AddNoteRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteInputField(
      controller: _controller,
      isBusy: widget.isAdding,
      onSubmit: _submit,
    );
  }

  Future<void> _submit() async {
    await widget.notifier.addNote(_controller.text);
    if (!mounted) return;

    final addFieldClosed = !ref
        .read(notesControllerProvider(widget.transaction))
        .showAddField;
    if (addFieldClosed) {
      _controller.clear();
    }
  }
}
