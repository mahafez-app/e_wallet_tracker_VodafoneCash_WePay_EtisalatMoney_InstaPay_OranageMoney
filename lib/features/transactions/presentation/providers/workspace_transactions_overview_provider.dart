import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/workspace_transactions_overview_entity.dart';
import '../../domain/usecases/get_workspace_transactions_overview_usecase.dart';
import '../../providers/transactions_providers.dart';
import '../navigation/transactions_route_data.dart';

final workspaceTransactionsOverviewProvider = FutureProvider.autoDispose
    .family<
      WorkspaceTransactionsOverviewEntity,
      WorkspaceTransactionsRouteData
    >((ref, routeData) async {
      final result = await ref.read(getWorkspaceTransactionsOverviewUseCaseProvider)(
        GetWorkspaceTransactionsOverviewParams(
          walletIds: routeData.wallets.map((wallet) => wallet.walletId).toList(),
        ),
      );

      return switch (result) {
        Success(:final data) => data,
        FailureResult(:final failure) => throw failure,
      };
    });
