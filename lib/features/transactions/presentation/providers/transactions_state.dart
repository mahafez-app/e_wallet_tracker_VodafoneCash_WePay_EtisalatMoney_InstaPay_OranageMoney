import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_date_range.dart';

/// Type-filter option in the segmented chip row.
enum TransactionTypeFilter { all, receive, send }

/// Date-range preset chips.
enum DatePreset { none, today, yesterday, week, month, custom }

/// Immutable state for [TransactionsController].
final class TransactionsState extends Equatable {
  const TransactionsState({
    this.transactions = const [],
    this.typeFilter = TransactionTypeFilter.all,
    this.datePreset = DatePreset.none,
    this.customDateRange,
    this.selectedWalletId,
    this.totalCount = 0,
    this.lastCursor,
    this.isLoadingInitial = true,
    this.isLoadingMore = false,
    this.error,
  });

  final List<TransactionEntity> transactions;
  final TransactionTypeFilter typeFilter;
  final DatePreset datePreset;

  /// Non-null only when [datePreset] == [DatePreset.custom].
  final DateTimeRange? customDateRange;

  /// Non-null when a wallet chip is selected (WorkspaceContext only).
  final String? selectedWalletId;

  final int totalCount;

  /// Opaque cursor object for the next page; null when no more pages exist.
  final Object? lastCursor;

  final bool isLoadingInitial;
  final bool isLoadingMore;

  /// Non-null on error; cleared on next successful load.
  final Failure? error;

  bool get hasMore => lastCursor != null;
  bool get hasActiveFilter =>
      typeFilter != TransactionTypeFilter.all ||
      datePreset != DatePreset.none ||
      selectedWalletId != null;

  /// Resolved [TransactionType] or null when showing all types.
  TransactionType? get resolvedType => switch (typeFilter) {
    TransactionTypeFilter.all => null,
    TransactionTypeFilter.receive => TransactionType.receive,
    TransactionTypeFilter.send => TransactionType.send,
  };

  /// Pre-computed grouping of transactions by calendar day.
  Map<DateTime, List<TransactionEntity>> get groupedTransactions {
    final map = <DateTime, List<TransactionEntity>>{};
    for (final tx in transactions) {
      final day = DateTime(
        tx.createdAt.year,
        tx.createdAt.month,
        tx.createdAt.day,
      );
      (map[day] ??= []).add(tx);
    }
    return map;
  }

  /// Resolved [DateTimeRange] from the selected preset or custom range.
  TransactionDateRange? get resolvedDateRange {
    final now = DateTime.now();
    return switch (datePreset) {
      DatePreset.none => null,
      DatePreset.today => TransactionDateRange(
        start: DateTime(now.year, now.month, now.day),
        end: now,
      ),
      DatePreset.yesterday => TransactionDateRange(
        start: DateTime(now.year, now.month, now.day - 1),
        end: DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(microseconds: 1)),
      ),
      DatePreset.week => TransactionDateRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
      DatePreset.month => TransactionDateRange(
        start: now.subtract(const Duration(days: 30)),
        end: now,
      ),
      DatePreset.custom =>
        customDateRange != null
            ? TransactionDateRange(
                start: customDateRange!.start,
                end: customDateRange!.end,
              )
            : null,
    };
  }

  TransactionsState copyWith({
    List<TransactionEntity>? transactions,
    TransactionTypeFilter? typeFilter,
    DatePreset? datePreset,
    DateTimeRange? customDateRange,
    Object? selectedWalletId = _sentinel,
    int? totalCount,
    Object? lastCursor = _sentinel,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    Object? error = _sentinel,
  }) => TransactionsState(
    transactions: transactions ?? this.transactions,
    typeFilter: typeFilter ?? this.typeFilter,
    datePreset: datePreset ?? this.datePreset,
    customDateRange: customDateRange ?? this.customDateRange,
    selectedWalletId: identical(selectedWalletId, _sentinel)
        ? this.selectedWalletId
        : selectedWalletId as String?,
    totalCount: totalCount ?? this.totalCount,
    lastCursor: identical(lastCursor, _sentinel) ? this.lastCursor : lastCursor,
    isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: identical(error, _sentinel) ? this.error : error as Failure?,
  );

  @override
  List<Object?> get props => [
    transactions,
    typeFilter,
    datePreset,
    customDateRange,
    selectedWalletId,
    totalCount,
    lastCursor,
    isLoadingInitial,
    isLoadingMore,
    error,
  ];
}

// Private sentinel for nullable copyWith.
const Object _sentinel = Object();
