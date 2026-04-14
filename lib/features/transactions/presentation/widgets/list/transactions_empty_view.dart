import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/transactions/no_transactions_card.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';

class TransactionsEmptyView extends ConsumerWidget {
  const TransactionsEmptyView({
    super.key,
    required this.routeData,
    required this.hasActiveFilter,
  });

  final TransactionsRouteData routeData;
  final bool hasActiveFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );
    final footer = hasActiveFilter
        ? SizedBox(
            width: double.infinity,
            child: AppButton(
              label: context.l10n.transactions_clearFilters,
              type: AppButtonType.secondary,
              icon: Icon(
                Icons.filter_alt_off_rounded,
                size: AppSpacing.lg.responsiveRadius,
              ),
              onPressed: controller.clearAllFilters,
            ),
          )
        : null;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoTransactionsCard(
                  title: hasActiveFilter
                      ? context.l10n.transactions_emptyWithFilterTitle
                      : context.l10n.transactions_emptyTitle,
                  description: hasActiveFilter
                      ? context.l10n.transactions_emptyWithFilterDescription
                      : _emptyDescription(context),
                  variant: NoTransactionsCardVariant.fullScreen,
                  footer: footer,
                ),
                if (!hasActiveFilter) ...[
                  AppSpacing.xl.verticalSpace,
                  const TransactionsEmptyHintCard(),
                ],
                AppSpacing.xxl.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _emptyDescription(BuildContext context) => switch (routeData) {
    WalletTransactionsRouteData() =>
      context.l10n.transactions_emptyWalletDescription,
    WorkspaceTransactionsRouteData() =>
      context.l10n.transactions_emptyWorkspaceDescription,
  };
}
