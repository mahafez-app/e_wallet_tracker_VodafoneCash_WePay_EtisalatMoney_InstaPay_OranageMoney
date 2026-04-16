// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../navigation/transactions_route_data.dart';
import '../widgets/transactions_filter_icon_button.dart';
import '../widgets/transactions_screen_body.dart';
import '../widgets/transactions_screen_title.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.transactionsContext});

  final TransactionsRouteData transactionsContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TransactionsScreenTitle(routeData: transactionsContext),
        centerTitle: true,
        actions: [
          TransactionsFilterIconButton(routeData: transactionsContext),
          AppSpacing.lg.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: TransactionsScreenBody(routeData: transactionsContext),
      ),
    );
  }
}
