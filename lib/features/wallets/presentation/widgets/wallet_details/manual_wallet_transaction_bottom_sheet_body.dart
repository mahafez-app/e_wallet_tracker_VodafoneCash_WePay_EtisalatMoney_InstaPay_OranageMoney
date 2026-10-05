import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../domain/entities/manual_wallet_transaction_assessment.dart';
import '../../providers/manual_wallet_transaction_controller.dart';
import '../../providers/manual_wallet_transaction_state.dart';
import '../../providers/wallet_details_controller.dart';
import 'manual_wallet_transaction_action_section.dart';
import 'manual_wallet_transaction_assessment_card.dart';
import 'manual_wallet_transaction_input_section.dart';

class ManualWalletTransactionBottomSheetBody extends ConsumerStatefulWidget {
  const ManualWalletTransactionBottomSheetBody({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  ConsumerState<ManualWalletTransactionBottomSheetBody> createState() =>
      _ManualWalletTransactionBottomSheetBodyState();
}

class _ManualWalletTransactionBottomSheetBodyState
    extends ConsumerState<ManualWalletTransactionBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ManualWalletTransactionState>(
      manualWalletTransactionControllerProvider(widget.walletId),
      (previous, next) {
        final hasNewFailure =
            previous?.failure != next.failure &&
            next.status == ManualWalletTransactionStatus.failure;
        if (hasNewFailure && next.failure != null) {
          AppSnackbar.showFailure(context, failure: next.failure!);

          // If the manual transaction already exists, there is nothing more the user
          // can do in this bottom sheet. Pop it so they can see the error clearly.
          final failure = next.failure;
          final isAlreadyExists = failure is ValidationFailure &&
              failure.code == 'transaction-already-exists';

          if (isAlreadyExists) {
            Navigator.of(context).pop();
          }
        }

        final hasSaved =
            previous?.status != ManualWalletTransactionStatus.success &&
            next.status == ManualWalletTransactionStatus.success;
        if (hasSaved && context.mounted) {
          ref.invalidate(walletDetailsControllerProvider(widget.walletId));
          AppSnackbar.show(
            context,
            message: context.l10n.walletManualTransactionSaved,
            type: AppSnackbarType.success,
          );
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(
      manualWalletTransactionControllerProvider(widget.walletId),
    );

    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ManualWalletTransactionInputSection(
               messageController: _messageController,
               isCompact: state.assessment != null,
               validator: _validateMessage,
               onChanged: (value) {
                 ref
                     .read(
                       manualWalletTransactionControllerProvider(
                         widget.walletId,
                       ).notifier,
                     )
                     .preview(value);
               },
               onPastePressed: _pasteFromClipboard,
             ),
            if (state.assessment != null) ...[
              AppSpacing.lg.verticalSpace,
              ManualWalletTransactionAssessmentCard(
                assessment: state.assessment!,
              ),
            ],
            AppSpacing.lg.verticalSpace,
            ManualWalletTransactionActionSection(
              primaryLabel: _primaryActionLabel(context, state),
              isLoading: state.isBusy,
              onPrimaryPressed: _resolvePrimaryAction(state),
              cancelLabel: context.l10n.commonCancelAction,
              onCancelPressed: state.isBusy
                  ? null
                  : () => Navigator.of(context).pop(),
            ),
            AppSpacing.lg.verticalSpace,
          ],
        ),
      ),
    );
  }

  String? _validateMessage(String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.errorManualTransactionMessageRequired;
    }

    return null;
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final pastedText = clipboardData?.text?.trim();
    if (pastedText == null || pastedText.isEmpty) {
      return;
    }

    _messageController.text = pastedText;
    ref
        .read(
          manualWalletTransactionControllerProvider(widget.walletId).notifier,
        )
        .preview(pastedText);
  }

  VoidCallback? _resolvePrimaryAction(ManualWalletTransactionState state) {
    if (state.isBusy) {
      return null;
    }

    final assessment = state.assessment;
    if (assessment == null) {
      return _analyzeMessage;
    }

    if (!assessment.allowsSaveToSelectedWallet) {
      return null;
    }

    return () => ref
        .read(
          manualWalletTransactionControllerProvider(widget.walletId).notifier,
        )
        .confirmSelectedWalletSave();
  }

  String _primaryActionLabel(
    BuildContext context,
    ManualWalletTransactionState state,
  ) {
    final assessment = state.assessment;
    if (assessment == null) {
      return context.l10n.walletManualTransactionAnalyzeAction;
    }

    return switch (assessment.reviewKind) {
      ManualWalletTransactionReviewKind.needsConfirmation =>
        context.l10n.walletManualTransactionConfirmAction,
      ManualWalletTransactionReviewKind.inferredWalletMismatch =>
        context.l10n.walletManualTransactionForceAction,
      ManualWalletTransactionReviewKind.explicitWalletMismatch =>
        context.l10n.walletManualTransactionForceAction,
      ManualWalletTransactionReviewKind.none =>
        context.l10n.walletManualTransactionSaveAction,
    };
  }

  void _analyzeMessage() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    ref
        .read(
          manualWalletTransactionControllerProvider(widget.walletId).notifier,
        )
        .analyze(_messageController.text);
  }
}
