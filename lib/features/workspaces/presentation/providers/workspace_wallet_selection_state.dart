import '../../../../core/domain/entities/wallet_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
const workspaceWalletSelectionUnsetFailure = Object();

enum WorkspaceWalletSelectionSubmissionStatus {
  idle,
  loading,
  success,
  failure,
}

class WorkspaceWalletSelectionState {
  const WorkspaceWalletSelectionState({
    required this.workspaceName,
    required this.ownedWallets,
    required this.linkedWalletIds,
    required this.selectedWalletIds,
    required this.submissionStatus,
    required this.submissionFailure,
    required this.linkedCount,
  });

  final String workspaceName;
  final List<WalletEntity> ownedWallets;
  final Set<String> linkedWalletIds;
  final Set<String> selectedWalletIds;
  final WorkspaceWalletSelectionSubmissionStatus submissionStatus;
  final Failure? submissionFailure;
  final int linkedCount;

  List<WalletEntity> get selectableWallets => ownedWallets
      .where((wallet) => !linkedWalletIds.contains(wallet.id))
      .toList();

  bool get isSubmitting =>
      submissionStatus == WorkspaceWalletSelectionSubmissionStatus.loading;

  bool get hasSelectableWallets => selectableWallets.isNotEmpty;

  bool get canSubmit =>
      !isSubmitting && (!hasSelectableWallets || selectedWalletIds.isNotEmpty);

  WorkspaceWalletSelectionState copyWith({
    String? workspaceName,
    List<WalletEntity>? ownedWallets,
    Set<String>? linkedWalletIds,
    Set<String>? selectedWalletIds,
    WorkspaceWalletSelectionSubmissionStatus? submissionStatus,
    Object? submissionFailure = workspaceWalletSelectionUnsetFailure,
    int? linkedCount,
  }) {
    return WorkspaceWalletSelectionState(
      workspaceName: workspaceName ?? this.workspaceName,
      ownedWallets: ownedWallets ?? this.ownedWallets,
      linkedWalletIds: linkedWalletIds ?? this.linkedWalletIds,
      selectedWalletIds: selectedWalletIds ?? this.selectedWalletIds,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure:
          identical(submissionFailure, workspaceWalletSelectionUnsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
      linkedCount: linkedCount ?? this.linkedCount,
    );
  }
}
