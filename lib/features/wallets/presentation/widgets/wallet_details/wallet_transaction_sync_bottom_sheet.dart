import 'package:flutter/material.dart';

import 'wallet_transaction_sync_bottom_sheet_body.dart';

class WalletTransactionSyncBottomSheet extends StatelessWidget {
  const WalletTransactionSyncBottomSheet({super.key, required this.walletId});

  final String walletId;

  static Future<void> show(BuildContext context, {required String walletId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          WalletTransactionSyncBottomSheet(walletId: walletId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WalletTransactionSyncBottomSheetBody(walletId: walletId);
  }
}
