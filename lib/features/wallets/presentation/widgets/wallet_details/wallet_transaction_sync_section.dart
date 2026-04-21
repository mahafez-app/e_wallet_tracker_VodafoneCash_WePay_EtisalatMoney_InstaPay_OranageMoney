import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../auth/providers/auth_providers.dart';
import '../../../domain/entities/wallet_details_entity.dart';
import 'wallet_transaction_sync_bottom_sheet.dart';

class WalletTransactionSyncSection extends ConsumerWidget {
  const WalletTransactionSyncSection({super.key, required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.uid == details.wallet.ownerUid;

    if (!isOwner) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletSyncTransactionsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.xs.verticalSpace,
          Text(
            context.l10n.walletSyncTransactionsDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.md.verticalSpace,
          AppButton(
            label: context.l10n.walletSyncTransactionsAction,
            icon: const Icon(Icons.sync_rounded),
            onPressed: () => WalletTransactionSyncBottomSheet.show(
              context,
              walletId: details.wallet.id,
            ),
          ),
        ],
      ),
    );
  }
}
