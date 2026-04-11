import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_tracker/features/transactions/presentation/providers/transactions_controller.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../features/auth/providers/auth_providers.dart';
import '../../domain/usecases/mark_paid_usecases.dart';
import '../../domain/usecases/note_usecases.dart';
import '../../providers/transactions_providers.dart';
import 'transaction_details_state.dart';

/// Keyed by [TransactionEntity] so the full object is available on build().
final transactionDetailsControllerProvider = NotifierProvider.autoDispose
    .family<
      TransactionDetailsController,
      TransactionDetailsState,
      TransactionEntity
    >(TransactionDetailsController.new);

class TransactionDetailsController extends Notifier<TransactionDetailsState> {
  TransactionDetailsController(this.arg);

  final TransactionEntity arg;

  @override
  TransactionDetailsState build() {
    _listenNotes();
    _listenHistory();
    return TransactionDetailsState(transaction: arg);
  }

  String get _walletId => arg.walletId;
  String get _transactionId => arg.id;

  // ── Streams ───────────────────────────────────────────────────────────────

  void _listenNotes() {
    final params = NoteStreamParams(
      walletId: _walletId,
      transactionId: _transactionId,
    );
    final subscription = ref.read(getNotesUseCaseProvider).call(params).listen((
      result,
    ) {
      if (!ref.mounted) return;
      result.fold(
        (failure) => log('Notes stream error: $failure', name: 'Presentation'),
        (notes) => state = state.copyWith(notes: notes),
      );
    });
    ref.onDispose(subscription.cancel);
  }

  void _listenHistory() {
    final params = NoteStreamParams(
      walletId: _walletId,
      transactionId: _transactionId,
    );
    final subscription = ref
        .read(getHistoryUseCaseProvider)
        .call(params)
        .listen((result) {
          if (!ref.mounted) return;
          result.fold(
            (failure) =>
                log('History stream error: $failure', name: 'Presentation'),
            (entries) => state = state.copyWith(history: entries),
          );
        });
    ref.onDispose(subscription.cancel);
  }

  // ── Mark paid / unpaid ────────────────────────────────────────────────────

  Future<void> markAsPaid() => _updatePaidStatus(isPaid: true);
  Future<void> markAsUnpaid() => _updatePaidStatus(isPaid: false);

  Future<void> _updatePaidStatus({required bool isPaid}) async {
    _startAction(TransactionDetailsAction.markingPaid);

    final user = _requireCurrentUser();
    if (user == null) return;

    final useCase = isPaid
        ? ref.read(markAsPaidUseCaseProvider)
        : ref.read(markAsUnpaidUseCaseProvider);

    final result = await useCase(
      MarkPaidParams(
        walletId: _walletId,
        transactionId: _transactionId,
        userId: user.uid,
        userName: user.name,
      ),
    );

    if (!ref.mounted) return;

    result.fold(
      (failure) {
        log('markPaid failed: $failure', name: 'Presentation');
        _finishWithFailure(failure);
      },
      (_) {
        final updatedTx = state.transaction.copyWith(isPaid: isPaid);
        _finishWithTransaction(updatedTx);
        ref.read(transactionUpdatesProvider.notifier).notifyUpdated(updatedTx);
      },
    );
  }

  // ── Notes ─────────────────────────────────────────────────────────────────

  Future<void> addNote(String text) async {
    if (text.trim().isEmpty) return;
    _startAction(TransactionDetailsAction.addingNote);

    final user = _requireCurrentUser();
    if (user == null) return;

    final result = await ref.read(addNoteUseCaseProvider)(
      AddNoteParams(
        walletId: _walletId,
        transactionId: _transactionId,
        text: text.trim(),
        userId: user.uid,
        userName: user.name,
      ),
    );

    if (!ref.mounted) return;

    result.fold((failure) {
      log('addNote failed: $failure', name: 'Presentation');
      _finishWithFailure(failure);
    }, (_) => _finishWithoutError());
  }

  Future<void> editNote({required String noteId, required String text}) async {
    if (text.trim().isEmpty) return;
    _startAction(TransactionDetailsAction.editingNote);

    final result = await ref.read(editNoteUseCaseProvider)(
      EditNoteParams(
        walletId: _walletId,
        transactionId: _transactionId,
        noteId: noteId,
        text: text.trim(),
      ),
    );

    if (!ref.mounted) return;

    result.fold((failure) {
      log('editNote failed: $failure', name: 'Presentation');
      _finishWithFailure(failure);
    }, (_) => _finishWithoutError());
  }

  Future<void> deleteNote(String noteId) async {
    _startAction(TransactionDetailsAction.deletingNote);

    final result = await ref.read(deleteNoteUseCaseProvider)(
      DeleteNoteParams(
        walletId: _walletId,
        transactionId: _transactionId,
        noteId: noteId,
      ),
    );

    if (!ref.mounted) return;

    result.fold((failure) {
      log('deleteNote failed: $failure', name: 'Presentation');
      _finishWithFailure(failure);
    }, (_) => _finishWithoutError());
  }

  void _startAction(TransactionDetailsAction action) {
    state = state.copyWith(currentAction: action, actionError: null);
  }

  UserEntity? _requireCurrentUser() {
    final user = ref.read(currentUserProvider);
    if (user != null) return user;

    _finishWithFailure(
      const AuthFailure(
        code: 'not-authenticated',
        technicalMessage: 'No authenticated user is available.',
      ),
    );
    return null;
  }

  void _finishWithoutError() {
    state = state.copyWith(
      currentAction: TransactionDetailsAction.none,
      actionError: null,
    );
  }

  void _finishWithFailure(Failure failure) {
    state = state.copyWith(
      currentAction: TransactionDetailsAction.none,
      actionError: failure,
    );
  }

  void _finishWithTransaction(TransactionEntity transaction) {
    state = state.copyWith(
      currentAction: TransactionDetailsAction.none,
      actionError: null,
      transaction: transaction,
    );
  }
}
