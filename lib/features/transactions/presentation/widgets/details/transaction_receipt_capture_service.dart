// ignore_for_file: unused_element_parameter

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'transaction_receipt_image.dart';

final class TransactionReceiptCaptureService {
  const TransactionReceiptCaptureService();

  Future<Uint8List> capture({
    required BuildContext context,
    required TransactionEntity transaction,
  }) {
    final mediaQueryData = MediaQuery.of(context);
    final receiptWidth = mediaQueryData.size.width;

    return ScreenshotController().captureFromLongWidget(
      _buildCaptureTree(
        context: context,
        mediaQueryData: mediaQueryData,
        receiptWidth: receiptWidth,
        transaction: transaction,
      ),
      pixelRatio: 3.0,
      delay: const Duration(milliseconds: 200),
      constraints: BoxConstraints(
        minWidth: receiptWidth,
        maxWidth: receiptWidth,
      ),
    );
  }

  Widget _buildCaptureTree({
    required BuildContext context,
    required MediaQueryData mediaQueryData,
    required double receiptWidth,
    required TransactionEntity transaction,
  }) {
    return Theme(
      data: Theme.of(context),
      child: MediaQuery(
        data: mediaQueryData,
        child: Localizations.override(
          context: context,
          child: Directionality(
            textDirection: Directionality.of(context),
            child: _ReceiptCaptureRoot(
              width: receiptWidth,
              child: TransactionReceiptImage(transaction: transaction),
            ),
          ),
        ),
      ),
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
