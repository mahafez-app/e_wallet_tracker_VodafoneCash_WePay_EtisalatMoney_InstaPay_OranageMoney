import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final theme = Theme.of(context);
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.responsiveRadius,
              height: 80.responsiveRadius,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasActiveFilter
                    ? Icons.search_off_rounded
                    : Icons.receipt_long_outlined,
                size: 36.responsiveRadius,
                color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
              ),
            ),
            AppSpacing.lg.verticalSpace,
            Text(
              hasActiveFilter
                  ? context.l10n.transactions_emptyWithFilter
                  : context.l10n.noTransactionsTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasActiveFilter) ...{
              AppSpacing.lg.verticalSpace,
              OutlinedButton.icon(
                onPressed: () => controller.clearAllFilters(),
                icon: const Icon(Icons.filter_alt_off_rounded),
                label: Text(context.l10n.transactions_clearFilters),
              ),
            },
          ],
        ),
      ),
    );
  }
}
