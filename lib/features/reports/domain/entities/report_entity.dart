import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  const ReportEntity({
    required this.totalIncome,
    required this.totalOutcome,
    required this.balanceChange,
    required this.transactionCount,
    required this.transactionsByDay,
  });

  final double totalIncome;
  final double totalOutcome;
  final double balanceChange;
  final int transactionCount;
  final Map<DateTime, double> transactionsByDay;

  @override
  List<Object?> get props => [
        totalIncome,
        totalOutcome,
        balanceChange,
        transactionCount,
        transactionsByDay,
      ];
}
