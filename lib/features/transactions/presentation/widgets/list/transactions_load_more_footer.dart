import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';

class TransactionsLoadMoreFooter extends ConsumerWidget {
  const TransactionsLoadMoreFooter({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );

    if (state.isLoadingMore) {
      return Padding(
        padding: AppResponsive.symmetricPadding(vertical: AppSpacing.xl),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasMore) return AppSpacing.lg.verticalSpace;

    return Padding(
      padding: AppResponsive.symmetricPadding(vertical: AppSpacing.lg),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.loadMore(),
            child: Container(
              width: 56.responsiveRadius,
              height: 56.responsiveRadius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.expand_more_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 28.responsiveRadius,
              ),
            ),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            context.l10n.transactions_loadMore,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            context.l10n.transactions_viewingCountOfTotal(
              state.transactions.length,
              state.totalCount,
            ),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
