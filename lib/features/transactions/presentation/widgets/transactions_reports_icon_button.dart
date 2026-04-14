import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../navigation/transactions_route_data.dart';

class TransactionsReportsIconButton extends StatelessWidget {
  const TransactionsReportsIconButton({super.key, required this.routeData});

  final WorkspaceTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bar_chart_rounded),
      tooltip: context.l10n.workspaceReportsAction,
      onPressed: () {
        context.push(
          AppRoutes.workspaceReportsPath(routeData.workspaceId),
          extra: routeData,
        );
      },
    );
  }
}
