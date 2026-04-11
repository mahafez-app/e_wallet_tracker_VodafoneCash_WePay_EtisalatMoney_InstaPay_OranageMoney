// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/sms_providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../providers/wallets_providers.dart';
import '../providers/add_wallet_controller.dart';
import '../widgets/add_wallet/add_wallet_content.dart';

class AddWalletScreen extends StatelessWidget {
  const AddWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addWalletTitle), centerTitle: true),
      body: const SafeArea(child: _AddWalletBody()),
    );
  }
}

class _AddWalletBody extends ConsumerWidget {
  const _AddWalletBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddWalletState>(addWalletControllerProvider, (previous, next) {
      _handleStateChange(previous, next, ref, context);
    });

    final state = ref.watch(addWalletControllerProvider);
    final controller = ref.read(addWalletControllerProvider.notifier);

    return AddWalletContent(
      state: state,
      onPhoneNumberChanged: controller.updatePhoneNumber,
      onProviderToggled: controller.toggleProvider,
      onSubmit: controller.submit,
    );
  }

  Future<void> _handleStateChange(
    AddWalletState? previous,
    AddWalletState next,
    WidgetRef ref,
    BuildContext context,
  ) async {
    if (_hasNewLoadFailure(previous, next)) {
      _showFailureSnackbar(context, next.loadFailure!);
      return;
    }

    if (_hasNewSubmissionFailure(previous, next)) {
      _showFailureSnackbar(context, next.submissionFailure!);
      return;
    }

    if (!_hasSuccessfulSubmission(previous, next)) return;

    final hasPermission = await _checkSmsPermission(ref);
    if (!context.mounted) return;

    if (hasPermission) {
      context.go(AppRoutes.home);
      return;
    }

    ref.read(hasPromptedWalletPermissionsSessionProvider.notifier).state = true;
    context.push(AppRoutes.smsPermissions);
  }

  bool _hasNewLoadFailure(AddWalletState? previous, AddWalletState next) {
    return next.loadFailure != null &&
        previous?.loadFailure != next.loadFailure;
  }

  bool _hasNewSubmissionFailure(AddWalletState? previous, AddWalletState next) {
    return next.submissionStatus == AddWalletSubmissionStatus.failure &&
        previous?.submissionFailure != next.submissionFailure &&
        next.submissionFailure != null;
  }

  bool _hasSuccessfulSubmission(AddWalletState? previous, AddWalletState next) {
    return previous?.submissionStatus != AddWalletSubmissionStatus.success &&
        next.submissionStatus == AddWalletSubmissionStatus.success;
  }

  Future<bool> _checkSmsPermission(WidgetRef ref) async {
    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    return result.dataOrNull == true;
  }

  void _showFailureSnackbar(BuildContext context, Failure failure) {
    AppSnackbar.show(
      context,
      message: failure.toLocalizedString(context),
      type: AppSnackbarType.error,
    );
  }
}
