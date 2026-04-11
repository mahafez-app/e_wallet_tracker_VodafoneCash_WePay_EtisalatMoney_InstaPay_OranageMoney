import 'package:equatable/equatable.dart';

/// Tracks lightweight UI state local to the notes section:
/// whether the add-field is visible and which note (by id) is currently
/// being saved after an edit. All CRUD side-effects are delegated to
/// [TransactionDetailsController].
final class NotesSectionState extends Equatable {
  const NotesSectionState({
    this.showAddField = false,
    this.savingNoteId,
    this.isAdding = false,
    this.editingNoteId,
    this.deletedNoteText,
  });

  /// Whether the inline "add note" TextField is expanded.
  final bool showAddField;

  /// The id of the note currently being persisted via [editNote].
  /// Null when no edit save is in flight.
  final String? savingNoteId;

  /// True while [addNote] is in flight.
  final bool isAdding;

  /// The id of the note currently being edited.
  final String? editingNoteId;

  /// Stores recently deleted note text to present an undo snackbar.
  final String? deletedNoteText;

  NotesSectionState copyWith({
    bool? showAddField,
    Object? savingNoteId = _sentinel,
    bool? isAdding,
    Object? editingNoteId = _sentinel,
    Object? deletedNoteText = _sentinel,
  }) => NotesSectionState(
    showAddField: showAddField ?? this.showAddField,
    savingNoteId: identical(savingNoteId, _sentinel)
        ? this.savingNoteId
        : savingNoteId as String?,
    isAdding: isAdding ?? this.isAdding,
    editingNoteId: identical(editingNoteId, _sentinel)
        ? this.editingNoteId
        : editingNoteId as String?,
    deletedNoteText: identical(deletedNoteText, _sentinel)
        ? this.deletedNoteText
        : deletedNoteText as String?,
  );

  @override
  List<Object?> get props => [
    showAddField,
    savingNoteId,
    isAdding,
    editingNoteId,
    deletedNoteText,
  ];
}

const Object _sentinel = Object();
