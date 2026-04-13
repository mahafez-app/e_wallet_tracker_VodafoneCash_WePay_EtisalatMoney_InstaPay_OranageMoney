import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../../../core/domain/enums/transaction_type.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';

enum TransactionTypeFilter { all, receive, send }

enum DatePreset { none, today, yesterday, week, month, custom }

final class TransactionsState extends Equatable {
  const TransactionsState({
    this.transactions = const <TransactionEntity>[],
    this.typeFilter = TransactionTypeFilter.all,
    this.datePreset = DatePreset.none,
    this.customDateRange,
    this.useAllWallets = true,
    this.selectedWalletIds = const <String>[],
    this.totalCount = 0,
    this.nextCursor,
    this.isLoadingInitial = true,
    this.isLoadingMore = false,
    this.error,
  });

  final List<TransactionEntity> transactions;
  final TransactionTypeFilter typeFilter;
  final DatePreset datePreset;
  final DateTimeRange? customDateRange;
  final bool useAllWallets;
  final List<String> selectedWalletIds;
  final int totalCount;
  final TransactionsPageCursor? nextCursor;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final Failure? error;

  bool get hasMore => nextCursor != null;
  bool get hasActiveFilter =>
      typeFilter != TransactionTypeFilter.all ||
      datePreset != DatePreset.none ||
      !useAllWallets;

  TransactionType? get resolvedType => switch (typeFilter) {
    TransactionTypeFilter.all => null,
    TransactionTypeFilter.receive => TransactionType.receive,
    TransactionTypeFilter.send => TransactionType.send,
  };

  Map<DateTime, List<TransactionEntity>> get groupedTransactions {
    final map = <DateTime, List<TransactionEntity>>{};
    for (final transaction in transactions) {
      final day = DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      );
      (map[day] ??= <TransactionEntity>[]).add(transaction);
    }
    return map;
  }

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
        customDateRange == null
            ? null
            : TransactionDateRange(
                start: customDateRange!.start,
                end: customDateRange!.end,
              ),
    };
  }

  TransactionsState copyWith({
    List<TransactionEntity>? transactions,
    TransactionTypeFilter? typeFilter,
    DatePreset? datePreset,
    Object? customDateRange = _sentinel,
    bool? useAllWallets,
    Object? selectedWalletIds = _sentinel,
    int? totalCount,
    Object? nextCursor = _sentinel,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    Object? error = _sentinel,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      typeFilter: typeFilter ?? this.typeFilter,
      datePreset: datePreset ?? this.datePreset,
      customDateRange: identical(customDateRange, _sentinel)
          ? this.customDateRange
          : customDateRange as DateTimeRange?,
      useAllWallets: useAllWallets ?? this.useAllWallets,
      selectedWalletIds: identical(selectedWalletIds, _sentinel)
          ? this.selectedWalletIds
          : selectedWalletIds as List<String>,
      totalCount: totalCount ?? this.totalCount,
      nextCursor: identical(nextCursor, _sentinel)
          ? this.nextCursor
          : nextCursor as TransactionsPageCursor?,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _sentinel) ? this.error : error as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    typeFilter,
    datePreset,
    customDateRange,
    useAllWallets,
    selectedWalletIds,
    totalCount,
    nextCursor,
    isLoadingInitial,
    isLoadingMore,
    error,
  ];
}

const Object _sentinel = Object();
