import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';

class ManualWalletTransactionActionSection extends StatelessWidget {
  const ManualWalletTransactionActionSection({
    super.key,
    required this.primaryLabel,
    required this.isLoading,
    required this.onPrimaryPressed,
    required this.cancelLabel,
    required this.onCancelPressed,
  });

  final String primaryLabel;
  final bool isLoading;
  final VoidCallback? onPrimaryPressed;
  final String cancelLabel;
  final VoidCallback? onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: cancelLabel,
            type: AppButtonType.secondary,
            onPressed: onCancelPressed,
          ),
        ),
        AppSpacing.md.horizontalSpace,
        Expanded(
          child: AppButton(
            label: primaryLabel,
            isLoading: isLoading,
            onPressed: onPrimaryPressed,
          ),
        ),
      ],
    );
  }
}
