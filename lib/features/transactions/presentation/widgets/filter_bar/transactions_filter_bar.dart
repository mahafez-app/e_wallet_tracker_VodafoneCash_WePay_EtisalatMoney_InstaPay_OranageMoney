import 'package:flutter/material.dart';

import '../../navigation/transactions_route_data.dart';
import 'transaction_date_filter_row.dart';
import 'transaction_type_filter_row.dart';
import 'transaction_wallet_filter_row.dart';

class TransactionsFilterBar extends StatelessWidget {
  const TransactionsFilterBar({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TransactionTypeFilterRow(routeData: routeData),
        TransactionDateFilterRow(routeData: routeData),
        if (routeData is WorkspaceTransactionsRouteData)
          TransactionWalletFilterRow(
            routeData: routeData as WorkspaceTransactionsRouteData,
          ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
        ),
      ],
    );
  }
}
