import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';

class ManualWalletTransactionInputSection extends StatelessWidget {
  const ManualWalletTransactionInputSection({
    super.key,
    required this.messageController,
    required this.validator,
    required this.onChanged,
    required this.onPastePressed,
  });

  final TextEditingController messageController;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final VoidCallback onPastePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.sm.verticalSpace,
        Text(
          context.l10n.walletManualTransactionTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.sm.verticalSpace,
        Text(
          context.l10n.walletManualTransactionDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.lg.verticalSpace,
        AppTextField(
          label: context.l10n.walletManualTransactionFieldLabel,
          hintText: context.l10n.walletManualTransactionFieldHint,
          controller: messageController,
          keyboardType: TextInputType.multiline,
          minLines: 6,
          maxLines: 10,
          validator: validator,
          onChanged: onChanged,
        ),
        AppSpacing.sm.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AppButton(
            label: context.l10n.walletManualTransactionPasteAction,
            type: AppButtonType.tertiary,
            icon: const Icon(Icons.content_paste_rounded),
            onPressed: onPastePressed,
          ),
        ),
      ],
    );
  }
}
