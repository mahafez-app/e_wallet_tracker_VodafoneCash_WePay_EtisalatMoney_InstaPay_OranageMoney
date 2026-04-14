import 'package:flutter/material.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../core/widgets/wallets/wallet_provider_icon.dart';
import '../navigation/transactions_route_data.dart';

class TransactionsScreenTitle extends StatelessWidget {
  const TransactionsScreenTitle({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return switch (routeData) {
      WalletTransactionsRouteData(:final provider, :final phoneNumber) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WalletProviderIcon(provider: provider, size: 32.responsiveRadius),
          AppSpacing.md.horizontalSpace,
          Flexible(
            child: _DoubleLineTitleText(
              title: provider.displayName(context),
              subtitle: phoneNumber.formattedEgyptianPhoneNumber,
            ),
          ),
        ],
      ),
      WorkspaceTransactionsRouteData(:final workspaceName) =>
        _DoubleLineTitleText(
          title: workspaceName,
          subtitle: l10n.allTransactions,
        ),
    };
  }
}

class _DoubleLineTitleText extends StatelessWidget {
  const _DoubleLineTitleText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
