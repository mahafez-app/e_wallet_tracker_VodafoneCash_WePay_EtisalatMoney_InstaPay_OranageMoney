// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/domain/enums/transaction_type.dart';
import '../../../../../core/theme/app_color_extension.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../providers/transaction_details_controller.dart';

/// Details card with wallet, date/time, and (for receive) paid status chips.
class DetailsCardSection extends ConsumerWidget {
  const DetailsCardSection({
    super.key,
    required this.transaction,
    this.controllerTransaction,
    this.isReadOnly = false,
  });

  final TransactionEntity transaction;
  final TransactionEntity? controllerTransaction;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final l10n = context.l10n;
    final dateTimeText = transaction.createdAt.toTransactionDateTimeLabel(
      context,
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: l10n.transaction_wallet,
            child: _WalletChip(transaction: transaction),
          ),
          _Divider(),
          if (transaction.counterpartyNumber != null &&
              transaction.counterpartyNumber!.trim().isNotEmpty) ...[
            _DetailRow(
              label: transaction.type == TransactionType.receive
                  ? l10n.transaction_receivedFrom
                  : l10n.transaction_sentTo,
              child: Text(
                transaction.counterpartyNumber!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            _Divider(),
          ],
          _DetailRow(
            label: l10n.transaction_dateTime,
            child: Text(
              dateTimeText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if (transaction.type == TransactionType.receive) ...[
            _Divider(),
            _PaidStatusRow(
              transaction: transaction,
              controllerTransaction: controllerTransaction ?? transaction,
              isReadOnly: isReadOnly,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.lg,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 0.5,
    indent: AppSpacing.lg.responsiveWidth,
    endIndent: AppSpacing.lg.responsiveWidth,
    color: Theme.of(context).colorScheme.outlineVariant.withAlpha(60),
  );
}

class _WalletChip extends StatelessWidget {
  const _WalletChip({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = transaction.provider.brandColor;
    final onBrand = transaction.provider.onBrandColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26.responsiveRadius,
          height: 26.responsiveRadius,
          decoration: BoxDecoration(
            color: brandColor,
            borderRadius: BorderRadius.circular(8.responsiveRadius),
          ),
          child: Icon(
            transaction.provider.icon,
            size: 13.responsiveRadius,
            color: onBrand,
          ),
        ),
        AppSpacing.sm.horizontalSpace,
        Expanded(
          child: Text(
            '${transaction.provider.displayName(context)} · ${transaction.phoneNumber.formattedEgyptianPhoneNumber}',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Paid status chips ─────────────────────────────────────────────────────────

class _PaidStatusRow extends ConsumerWidget {
  const _PaidStatusRow({
    super.key,
    required this.transaction,
    required this.controllerTransaction,
    required this.isReadOnly,
  });

  final TransactionEntity transaction;
  final TransactionEntity controllerTransaction;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final isPaid = transaction.isPaid ?? false;

    final controller = isReadOnly
        ? null
        : ref.read(
            transactionDetailsControllerProvider(
              controllerTransaction,
            ).notifier,
          );

    return _DetailRow(
      label: context.l10n.paymentStatus,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PaidChip(
            label: context.l10n.transactionStatusPaid,
            isActive: isPaid,
            activeColor: colors.success,
            onTap: isReadOnly || isPaid ? null : () => controller?.markAsPaid(),
          ),
          AppSpacing.sm.horizontalSpace,
          _PaidChip(
            label: context.l10n.transactionStatusUnpaid,
            isActive: !isPaid,
            activeColor: colors.danger,
            onTap: isReadOnly || !isPaid
                ? null
                : () => controller?.markAsUnpaid(),
          ),
        ],
      ),
    );
  }
}

class _PaidChip extends StatelessWidget {
  const _PaidChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppResponsive.symmetricPadding(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          border: Border.all(
            color: isActive
                ? activeColor
                : theme.colorScheme.outlineVariant.withAlpha(150),
          ),
          borderRadius: BorderRadius.circular(20.responsiveRadius),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
