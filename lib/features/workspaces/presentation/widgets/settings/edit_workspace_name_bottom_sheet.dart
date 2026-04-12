import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_validators.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../providers/workspace_settings_controller.dart';

class EditWorkspaceNameBottomSheet extends StatelessWidget {
  const EditWorkspaceNameBottomSheet({
    super.key,
    required this.workspaceId,
    required this.currentName,
  });

  final String workspaceId;
  final String currentName;

  static Future<void> show(
    BuildContext context, {
    required String workspaceId,
    required String currentName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditWorkspaceNameBottomSheet(
          workspaceId: workspaceId,
          currentName: currentName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EditWorkspaceNameBottomSheetBody(
      workspaceId: workspaceId,
      currentName: currentName,
    );
  }
}

class _EditWorkspaceNameBottomSheetBody extends ConsumerStatefulWidget {
  const _EditWorkspaceNameBottomSheetBody({
    required this.workspaceId,
    required this.currentName,
  });

  final String workspaceId;
  final String currentName;

  @override
  ConsumerState<_EditWorkspaceNameBottomSheetBody> createState() =>
      _EditWorkspaceNameBottomSheetBodyState();
}

class _EditWorkspaceNameBottomSheetBodyState
    extends ConsumerState<_EditWorkspaceNameBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<WorkspaceSettingsState>>(
      workspaceSettingsControllerProvider(widget.workspaceId),
      (previous, next) {
        final previousState = previous?.asData?.value;
        final nextState = next.asData?.value;
        if (previousState == null || nextState == null) {
          return;
        }

        final hasCompletedRename =
            previousState.isUpdatingName &&
            !nextState.isUpdatingName &&
            nextState.details.workspace.name == _nameController.text.trim();
        if (hasCompletedRename && context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(
      workspaceSettingsControllerProvider(widget.workspaceId),
    );
    final settings = state.asData?.value;
    final isLoading = settings?.isUpdatingName ?? false;
    final controller = ref.read(
      workspaceSettingsControllerProvider(widget.workspaceId).notifier,
    );

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
              context.l10n.workspaceSettingsEditNameTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            AppSpacing.sm.verticalSpace,
            Text(
              context.l10n.workspaceSettingsEditNameDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.lg.verticalSpace,
            AppTextField(
              label: context.l10n.workspaceNameLabel,
              hintText: context.l10n.workspaceNameHint,
              controller: _nameController,
              onChanged: (_) {},
              validator: (value) => AppValidators.required(context, value),
            ),
            AppSpacing.lg.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: context.l10n.workspaceSettingsEditNameAction,
                isLoading: isLoading,
                onPressed: isLoading ? null : () => _submit(controller),
              ),
            ),
            AppSpacing.lg.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _submit(WorkspaceSettingsController controller) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final name = _nameController.text.trim();
    if (name == widget.currentName.trim()) {
      Navigator.of(context).pop();
      return;
    }

    controller.updateWorkspaceName(name);
  }
}
