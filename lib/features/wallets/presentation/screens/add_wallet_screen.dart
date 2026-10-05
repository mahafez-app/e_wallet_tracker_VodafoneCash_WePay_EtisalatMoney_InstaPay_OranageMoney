// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/providers/sms_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../settings/presentation/providers/sms_permission_controller.dart';
import '../providers/add_wallet_controller.dart';
import '../providers/add_wallet_state.dart';
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
    ref.listen<SmsPermissionState>(smsPermissionControllerProvider, (
      previous,
      next,
    ) {
      if (next.error == null) return;

      _showFailureSnackbar(context, next.error!);
      ref.read(smsPermissionControllerProvider.notifier).clearError();
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
    if (_hasNewSubmissionFailure(previous, next)) {
      _showFailureSnackbar(context, next.submissionFailure!);
      return;
    }

    if (!_hasSuccessfulSubmission(previous, next)) return;

    ref.invalidate(smsReadinessProvider);
    ref
        .read(smsPermissionControllerProvider.notifier)
        .handleWalletSetupFlow(
          navigateHome: () {
            if (context.mounted) context.go(AppRoutes.home);
          },
          navigateToPermission: () {
            if (context.mounted) context.push(AppRoutes.smsPermissions);
          },
        );
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

  void _showFailureSnackbar(BuildContext context, Failure failure) {
    AppSnackbar.showFailure(context, failure: failure);
  }
}
