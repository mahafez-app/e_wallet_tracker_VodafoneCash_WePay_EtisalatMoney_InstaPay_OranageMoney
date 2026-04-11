import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../transaction_details_controller.dart';
import 'notes_section_state.dart';

final notesSectionControllerProvider = NotifierProvider.autoDispose
    .family<NotesSectionController, NotesSectionState, TransactionEntity>(
      NotesSectionController.new,
    );

class NotesSectionController extends Notifier<NotesSectionState> {
  NotesSectionController(this.arg);

  final TransactionEntity arg;

  @override
  NotesSectionState build() => const NotesSectionState();

  // ── Add field visibility ──────────────────────────────────────────────────

  void toggleAddField() =>
      state = state.copyWith(showAddField: !state.showAddField);

  void hideAddField() => state = state.copyWith(showAddField: false);

  // ── Add note ──────────────────────────────────────────────────────────────

  Future<void> addNote(String text) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(isAdding: true);

    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .addNote(text);

    if (!ref.mounted) return;
    if (!_lastActionSucceeded) {
      state = state.copyWith(isAdding: false);
      return;
    }

    state = state.copyWith(isAdding: false, showAddField: false);
  }

  // ── Edit note ─────────────────────────────────────────────────────────────

  void enterEditMode(String noteId) =>
      state = state.copyWith(editingNoteId: noteId);

  void exitEditMode() => state = state.copyWith(editingNoteId: null);

  Future<void> editNote({required String noteId, required String text}) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(savingNoteId: noteId);

    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .editNote(noteId: noteId, text: text);

    if (!ref.mounted) return;
    if (!_lastActionSucceeded) {
      state = state.copyWith(savingNoteId: null);
      return;
    }

    state = state.copyWith(savingNoteId: null, editingNoteId: null);
  }

  // ── Delete note ───────────────────────────────────────────────────────────

  Future<void> deleteNote(String noteId, String noteText) async {
    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .deleteNote(noteId);

    if (!ref.mounted) return;
    if (!_lastActionSucceeded) return;

    state = state.copyWith(deletedNoteText: noteText);
  }

  String? takeDeletedNoteText() {
    final deletedNoteText = state.deletedNoteText;
    if (deletedNoteText == null) return null;

    state = state.copyWith(deletedNoteText: null);
    return deletedNoteText;
  }

  /// Re-adds a previously deleted note (undo support).
  Future<void> restoreNote(String text) async {
    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .addNote(text);
  }

  bool get _lastActionSucceeded =>
      ref.read(transactionDetailsControllerProvider(arg)).actionError == null;
}
