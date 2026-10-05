import 'package:mahafez_core/mahafez_core.dart';
import '../entities/workspace_transactions_overview_entity.dart';
import '../repositories/workspace_transaction_repository.dart';

final class GetWorkspaceTransactionsOverviewParams {
  const GetWorkspaceTransactionsOverviewParams({required this.walletIds});

  final List<String> walletIds;
}

final class GetWorkspaceTransactionsOverviewUseCase
    implements
        UseCase<
          WorkspaceTransactionsOverviewEntity,
          GetWorkspaceTransactionsOverviewParams
        > {
  const GetWorkspaceTransactionsOverviewUseCase(this._repository);

  final WorkspaceTransactionRepository _repository;

  @override
  Future<Result<WorkspaceTransactionsOverviewEntity>> call(
    GetWorkspaceTransactionsOverviewParams params,
  ) {
    return _repository.getWorkspaceTransactionsOverview(walletIds: params.walletIds);
  }
}
