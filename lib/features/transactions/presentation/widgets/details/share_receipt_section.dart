// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/failure_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/utils/extensions/transaction_share_extension.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../providers/share_receipt/share_receipt_controller.dart';
import '../../providers/transaction_details_controller.dart';
import 'transaction_receipt_image.dart';

class ShareReceiptSection extends ConsumerWidget {
  const ShareReceiptSection({super.key, required this.transaction});

  final TransactionEntity transaction;

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
      final screenshotController = ScreenshotController();
      final shareMessage = context.l10n.transaction_shareReceipt;
      final mediaQueryData = MediaQuery.of(context);
      final receiptWidth = mediaQueryData.size.width;
      final receiptWidget = _ReceiptCaptureRoot(
        width: receiptWidth,
        child: TransactionReceiptImage(transaction: transaction),
      );

      final receiptBytes = await screenshotController.captureFromLongWidget(
        Theme(
          data: Theme.of(context),
          child: MediaQuery(
            data: mediaQueryData,
            child: Localizations.override(
              context: context,
              child: Directionality(
                textDirection: Directionality.of(context),
                child: receiptWidget,
              ),
            ),
          ),
        ),
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minWidth: receiptWidth,
          maxWidth: receiptWidth,
        ),
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
      AppSnackbar.show(
        context,
        message: failure.toLocalizedString(context),
        type: AppSnackbarType.error,
      );
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
        AppSnackbar.show(
          context,
          message: failure.toLocalizedString(context),
          type: AppSnackbarType.error,
        );
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

class _ReceiptCaptureRoot extends StatelessWidget {
  const _ReceiptCaptureRoot({
    super.key,
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppSpacing.xl.responsiveRadius);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerLow,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: AppResponsive.onlyPadding(
            top: AppSpacing.xl,
            end: AppSpacing.md,
            bottom: AppSpacing.xl,
            start: AppSpacing.md,
          ),
          child: Material(
            color: theme.scaffoldBackgroundColor,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
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
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
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
