import 'package:flutter/material.dart';

import '../../../../../core/domain/entities/transaction_entity.dart';
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
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      width: double.infinity,
      padding: AppSpacing.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TransactionHeaderSection(transaction: transaction),
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
