import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
import '../../../../../core/domain/enums/transaction_type.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'details_card_section.dart';
import 'sms_section.dart';
import 'transaction_header_section.dart';

class TransactionReceiptImage extends StatelessWidget {
  const TransactionReceiptImage({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final horizontalContentInset = transaction.type == TransactionType.send
        ? AppSpacing.lg
        : 0.0;

    return Padding(
      padding: AppSpacing.pagePadding.copyWith(
        left: AppSpacing.pagePadding.left + horizontalContentInset,
        right: AppSpacing.pagePadding.right + horizontalContentInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: TransactionHeaderSection(transaction: transaction)),
          AppSpacing.lg.verticalSpace,
          DetailsCardSection(transaction: transaction, isReadOnly: true),
          if (transaction.message != null) ...[
            AppSpacing.xl.verticalSpace,
            SmsSection(message: transaction.message!),
          ],
          AppSpacing.xl.verticalSpace,
        ],
      ),
    );
  }
}
