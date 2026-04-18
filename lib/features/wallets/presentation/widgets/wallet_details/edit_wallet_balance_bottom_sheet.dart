import 'package:flutter/material.dart';

import 'edit_wallet_balance_bottom_sheet_body.dart';

class EditWalletBalanceBottomSheet extends StatelessWidget {
  const EditWalletBalanceBottomSheet({
    super.key,
    required this.walletId,
    required this.currentBalance,
    required this.suggestedBalance,
  });

  final String walletId;
  final double currentBalance;
  final double suggestedBalance;

  static Future<void> show(
    BuildContext context, {
    required String walletId,
    required double currentBalance,
    required double suggestedBalance,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditWalletBalanceBottomSheet(
          walletId: walletId,
          currentBalance: currentBalance,
          suggestedBalance: suggestedBalance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditWalletBalanceBottomSheetBody(
      walletId: walletId,
      currentBalance: currentBalance,
      suggestedBalance: suggestedBalance,
    );
  }
}
