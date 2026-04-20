import 'package:flutter/material.dart';

import 'manual_wallet_transaction_bottom_sheet_body.dart';

class ManualWalletTransactionBottomSheet extends StatelessWidget {
  const ManualWalletTransactionBottomSheet({super.key, required this.walletId});

  final String walletId;

  static Future<void> show(BuildContext context, {required String walletId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ManualWalletTransactionBottomSheet(walletId: walletId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ManualWalletTransactionBottomSheetBody(walletId: walletId);
  }
}
