import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/domain/enums/report_period.dart';

class ReportFilterEntity extends Equatable {
  const ReportFilterEntity({
    required this.period,
    this.customRange,
    this.selectedWalletIds = const [],
  });

  final ReportPeriod period;
  final DateTimeRange? customRange;
  final List<String> selectedWalletIds;

  ReportFilterEntity copyWith({
    ReportPeriod? period,
    DateTimeRange? customRange,
    List<String>? selectedWalletIds,
  }) {
    return ReportFilterEntity(
      period: period ?? this.period,
      customRange: customRange ?? this.customRange,
      selectedWalletIds: selectedWalletIds ?? this.selectedWalletIds,
    );
  }

  @override
  List<Object?> get props => [period, customRange, selectedWalletIds];
}
