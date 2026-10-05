// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/app_validators.dart';
import '../../../../../core/utils/extensions/failure_extension.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../providers/invite_member_controller.dart';

class InviteMemberBottomSheet extends StatelessWidget {
  const InviteMemberBottomSheet({super.key, required this.workspaceId});

  final String workspaceId;

  static Future<bool?> show(
    BuildContext context, {
    required String workspaceId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: InviteMemberBottomSheet(workspaceId: workspaceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InviteMemberBottomSheetBody(workspaceId: workspaceId);
  }
}

class _InviteMemberBottomSheetBody extends ConsumerStatefulWidget {
  const _InviteMemberBottomSheetBody({required this.workspaceId});

  final String workspaceId;

  @override
  ConsumerState<_InviteMemberBottomSheetBody> createState() =>
      _InviteMemberBottomSheetBodyState();
}

class _InviteMemberBottomSheetBodyState
    extends ConsumerState<_InviteMemberBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<InviteMemberState>(
      inviteMemberControllerProvider(widget.workspaceId),
      (previous, next) {
        if (previous?.submissionStatus !=
                InviteMemberSubmissionStatus.success &&
            next.submissionStatus == InviteMemberSubmissionStatus.success) {
          MahafezSnackbar.show(
            context,
            message: context.l10n.invitationSentSuccess,
            type: MahafezSnackbarType.success,
          );
          Navigator.of(context).pop(true);
        }
      },
    );

    final state = ref.watch(inviteMemberControllerProvider(widget.workspaceId));
    final controller = ref.read(
      inviteMemberControllerProvider(widget.workspaceId).notifier,
    );

    return Padding(
      padding: MahafezSpacing.pagePadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MahafezSpacing.sm.verticalSpace,
            Text(
              context.l10n.inviteMemberTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            MahafezSpacing.sm.verticalSpace,
            Text(
              context.l10n.inviteMemberDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
            MahafezTextField(
              label: context.l10n.inviteMemberEmailLabel,
              hintText: context.l10n.inviteMemberEmailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: controller.updateEmail,
              validator: (value) => AppValidators.email(context, value),
            ),
            if (state.failure != null) ...[
              MahafezSpacing.md.verticalSpace,
              _InviteMemberFailureBanner(
                message: state.failure!.toLocalizedString(context),
              ),
            ],
            MahafezSpacing.lg.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: MahafezButton(
                label: context.l10n.inviteMemberSendAction,
                isLoading: state.isSubmitting,
                onPressed: state.isSubmitting
                    ? null
                    : () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        controller.submit();
                      },
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _InviteMemberFailureBanner extends StatelessWidget {
  const _InviteMemberFailureBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.md),
      decoration: BoxDecoration(
        color: colors.dangerContainer.withAlpha(70),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
        border: Border.all(color: colors.dangerContainer),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colors.danger,
            size: 18.responsiveRadius,
          ),
          MahafezSpacing.sm.horizontalSpace,
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
