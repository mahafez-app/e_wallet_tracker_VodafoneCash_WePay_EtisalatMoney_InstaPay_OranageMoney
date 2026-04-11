// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/failure_extension.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../providers/transaction_details_controller.dart';
import 'details_card_section.dart';
import 'history_section.dart';
import 'notes_section.dart';
import 'share_receipt_section.dart';
import 'sms_section.dart';
import 'transaction_header_section.dart';

class TransactionDetailsBottomSheet extends ConsumerWidget {
  const TransactionDetailsBottomSheet({super.key, required this.transaction});

  final TransactionEntity transaction;

  static Future<void> show(
    BuildContext context,
    TransactionEntity transaction,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionDetailsBottomSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.responsiveRadius),
            ),
          ),
          child: Column(
            children: [
              _BottomSheetHandle(theme: theme),
              Expanded(
                child: _DetailsScrollContent(
                  transaction: transaction,
                  scrollController: scrollController,
                ),
              ),
              ShareReceiptSection(transaction: transaction),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drag handle ───────────────────────────────────────────────────────────────

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppResponsive.symmetricPadding(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          width: 40.responsiveWidth,
          height: 4.responsiveHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant.withAlpha(120),
            borderRadius: BorderRadius.circular(4.responsiveRadius),
          ),
        ),
      ),
    );
  }
}

// ── Scrollable body ───────────────────────────────────────────────────────────

class _DetailsScrollContent extends ConsumerWidget {
  const _DetailsScrollContent({
    super.key,
    required this.transaction,
    required this.scrollController,
  });

  final TransactionEntity transaction;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailsControllerProvider(transaction));

    ref.listen(transactionDetailsControllerProvider(transaction), (
      previous,
      next,
    ) {
      final actionError = next.actionError;
      if (actionError == null || previous?.actionError == actionError) return;
      AppSnackbar.show(
        context,
        message: actionError.toLocalizedString(context),
        type: AppSnackbarType.error,
      );
    });

    return ListView(
      controller: scrollController,
      padding: AppSpacing.pagePadding,
      children: [
        TransactionHeaderSection(transaction: state.transaction),
        AppSpacing.lg.verticalSpace,
        DetailsCardSection(
          transaction: state.transaction,
          controllerTransaction: transaction,
        ),
        AppSpacing.xl.verticalSpace,
        if (state.transaction.message != null) ...[
          SmsSection(message: state.transaction.message!),
          AppSpacing.xl.verticalSpace,
        ],
        NotesSection(transaction: state.transaction),
        AppSpacing.xl.verticalSpace,
        if (state.history.isNotEmpty) HistorySection(entries: state.history),
        AppSpacing.xl.verticalSpace,
      ],
    );
  }
}

// ── End of Bottom Sheet ────────────────────────────────────────────────────────
