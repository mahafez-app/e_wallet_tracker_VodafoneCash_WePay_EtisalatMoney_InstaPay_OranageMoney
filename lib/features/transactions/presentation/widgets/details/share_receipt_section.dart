// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/transaction_share_extension.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../providers/share_receipt/share_receipt_controller.dart';
import '../../providers/transaction_details_controller.dart';
import 'transaction_receipt_capture_service.dart';

class ShareReceiptSection extends ConsumerWidget {
  const ShareReceiptSection({super.key, required this.transaction});

  final TransactionEntity transaction;
  static const TransactionReceiptCaptureService _captureService =
      TransactionReceiptCaptureService();

  void _share({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionEntity transaction,
  }) {
    unawaited(
      _captureAndShare(context: context, ref: ref, transaction: transaction),
    );
  }

  Future<void> _captureAndShare({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionEntity transaction,
  }) async {
    try {
      final shareMessage = context.l10n.transaction_shareReceipt;
      final receiptBytes = await _captureService.capture(
        context: context,
        transaction: transaction,
      );

      if (!context.mounted) return;

      ref
          .read(shareReceiptControllerProvider.notifier)
          .shareReceipt(
            receiptBytes: receiptBytes,
            fileName: transaction.receiptFileName,
            shareMessage: shareMessage,
          );
    } catch (error, stackTrace) {
      final failure = const FailureMapper().map(error);
      log(
        'ShareReceiptSection.capture: $failure',
        name: 'Presentation',
        error: error,
        stackTrace: stackTrace,
      );
      if (!context.mounted) return;
      AppSnackbar.showFailure(context, failure: failure);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(shareReceiptControllerProvider, (
      previous,
      state,
    ) {
      if (state.hasError && !state.isLoading) {
        final error = state.error;
        if (previous?.error == error) return;
        final failure = error is Failure
            ? error
            : const UnknownFailure(
                technicalMessage: 'Unexpected share receipt failure.',
              );
        if (error is! Failure && error != null) {
          log('ShareReceiptSection: $error', name: 'Presentation');
        }
        AppSnackbar.showFailure(context, failure: failure);
      }
    });

    final detailsState = ref.watch(
      transactionDetailsControllerProvider(transaction),
    );
    final isCapturing = ref.watch(shareReceiptControllerProvider).isLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ShareButton(
          isCapturing: isCapturing,
          onSharePressed: () {
            _share(
              context: context,
              ref: ref,
              transaction: detailsState.transaction,
            );
          },
        ),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    super.key,
    required this.isCapturing,
    required this.onSharePressed,
  });

  final bool isCapturing;
  final VoidCallback onSharePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: AppResponsive.symmetricPadding(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(60),
            width: 0.5,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isCapturing ? null : onSharePressed,
          icon: isCapturing
              ? SizedBox(
                  width: 20.responsiveRadius,
                  height: 20.responsiveRadius,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.share_rounded),
          label: Text(context.l10n.transaction_shareReceipt),
          style: FilledButton.styleFrom(
            padding: AppResponsive.symmetricPadding(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.responsiveRadius),
            ),
          ),
        ),
      ),
    );
  }
}
