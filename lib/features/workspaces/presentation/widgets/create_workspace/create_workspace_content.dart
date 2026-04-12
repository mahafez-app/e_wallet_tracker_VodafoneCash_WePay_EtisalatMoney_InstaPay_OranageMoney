import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/info_card.dart';
import '../../providers/create_workspace_controller.dart';
import 'create_workspace_preview_card.dart';

class CreateWorkspaceContent extends StatelessWidget {
  const CreateWorkspaceContent({
    super.key,
    required this.state,
    required this.ownerName,
    required this.onNameChanged,
    required this.onSubmit,
  });

  final CreateWorkspaceState state;
  final String ownerName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CreateWorkspacePreviewCard(
                  workspaceName: state.name,
                  ownerName: ownerName,
                ),
                AppSpacing.lg.verticalSpace,
                InfoCard(text: l10n.createWorkspaceDescription),
                AppSpacing.lg.verticalSpace,
                AppTextField(
                  label: l10n.workspaceNameLabel,
                  hintText: l10n.workspaceNameHint,
                  onChanged: onNameChanged,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withAlpha(102),
                  prefixIcon: Icon(
                    Icons.business_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppResponsive.allPadding(AppSpacing.md),
          child: AppButton(
            label: l10n.createWorkspaceAction,
            icon: const Icon(Icons.add_business_outlined),
            isLoading: state.isSubmitting,
            onPressed: state.canSubmit ? onSubmit : null,
          ),
        ),
      ],
    );
  }
}
