import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/amount_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../providers/wallet_balance_edit_controller.dart';
import '../../providers/wallet_details_controller.dart';

class EditWalletBalanceBottomSheetBody extends ConsumerStatefulWidget {
  const EditWalletBalanceBottomSheetBody({
    super.key,
    required this.walletId,
    required this.currentBalance,
    required this.suggestedBalance,
  });

  final String walletId;
  final double currentBalance;
  final double suggestedBalance;

  @override
  ConsumerState<EditWalletBalanceBottomSheetBody> createState() =>
      _EditWalletBalanceBottomSheetBodyState();
}

class _EditWalletBalanceBottomSheetBodyState
    extends ConsumerState<EditWalletBalanceBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController(
      text: _formatBalance(widget.suggestedBalance),
    );
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WalletBalanceEditState>(
      walletBalanceEditControllerProvider(widget.walletId),
      (previous, next) {
        if (_hasNewFailure(previous, next) && next.failure != null) {
          AppSnackbar.showFailure(context, failure: next.failure!);
        }

        if (_hasCompletedSuccess(previous, next) && context.mounted) {
          ref.invalidate(walletDetailsControllerProvider(widget.walletId));
          AppSnackbar.show(
            context,
            message: context.l10n.walletBalanceEditSuccess,
            type: AppSnackbarType.success,
          );
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(
      walletBalanceEditControllerProvider(widget.walletId),
    );
    final hasSuggestion = widget.suggestedBalance != widget.currentBalance;

    return Padding(
      padding: AppSpacing.pagePadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.sm.verticalSpace,
            Text(
              context.l10n.walletBalanceEditTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            AppSpacing.sm.verticalSpace,
            Text(
              context.l10n.walletBalanceEditDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasSuggestion) ...[
              AppSpacing.md.verticalSpace,
              Text(
                context.l10n.walletBalanceEditSuggested(
                  widget.suggestedBalance.toCurrencyText(context),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            AppSpacing.lg.verticalSpace,
            AppTextField(
              label: context.l10n.currentBalance,
              hintText: context.l10n.walletBalanceEditHint,
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) {},
              validator: _validateBalance,
            ),
            AppSpacing.lg.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: context.l10n.walletBalanceEditAction,
                isLoading: state.isSubmitting,
                onPressed: state.isSubmitting ? null : _submit,
              ),
            ),
            AppSpacing.lg.verticalSpace,
          ],
        ),
      ),
    );
  }

  bool _hasNewFailure(
    WalletBalanceEditState? previous,
    WalletBalanceEditState next,
  ) {
    return previous?.failure != next.failure &&
        next.status == WalletBalanceEditStatus.failure;
  }

  bool _hasCompletedSuccess(
    WalletBalanceEditState? previous,
    WalletBalanceEditState next,
  ) {
    return previous?.status != WalletBalanceEditStatus.success &&
        next.status == WalletBalanceEditStatus.success;
  }

  String? _validateBalance(String? value) {
    final rawValue = value?.trim();
    if (rawValue == null || rawValue.isEmpty) {
      return context.l10n.errorValidation;
    }

    final balance = double.tryParse(rawValue);
    if (balance == null || balance < 0) {
      return context.l10n.walletBalanceEditInvalid;
    }

    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final balance = double.parse(_balanceController.text.trim());
    if (balance == widget.currentBalance) {
      Navigator.of(context).pop();
      return;
    }

    ref
        .read(walletBalanceEditControllerProvider(widget.walletId).notifier)
        .updateBalance(balance);
  }

  String _formatBalance(double balance) {
    final text = balance.toStringAsFixed(2);
    return text.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
