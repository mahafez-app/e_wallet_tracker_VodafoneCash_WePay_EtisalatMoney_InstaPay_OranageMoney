import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

class AddWalletPhoneNumberSection extends StatelessWidget {
  const AddWalletPhoneNumberSection({
    super.key,
    required this.onPhoneNumberChanged,
  });

  final ValueChanged<String> onPhoneNumberChanged;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: s.phoneNumber,
          border: const OutlineInputBorder(),
        ),
        onChanged: onPhoneNumberChanged,
      ),
    );
  }
}
