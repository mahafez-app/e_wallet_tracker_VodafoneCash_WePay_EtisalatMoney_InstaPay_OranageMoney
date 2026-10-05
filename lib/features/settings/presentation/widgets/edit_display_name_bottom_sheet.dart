// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_validators.dart';
import '../../../../core/utils/extensions/localization_extension.dart';

import 'package:identity_product/identity_product.dart';

class EditDisplayNameBottomSheet extends StatelessWidget {
  const EditDisplayNameBottomSheet({super.key, required this.currentName});

  final String currentName;

  static Future<void> show(
    BuildContext context, {
    required String currentName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditDisplayNameBottomSheet(currentName: currentName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EditDisplayNameSheetBody(currentName: currentName);
  }
}

class _EditDisplayNameSheetBody extends ConsumerStatefulWidget {
  const _EditDisplayNameSheetBody({super.key, required this.currentName});

  final String currentName;

  @override
  ConsumerState<_EditDisplayNameSheetBody> createState() =>
      _EditDisplayNameSheetBodyState();
}

class _EditDisplayNameSheetBodyState
    extends ConsumerState<_EditDisplayNameSheetBody> {
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
    ref.listen<IdentityAuthState>(identityAuthControllerProvider, (
      previous,
      next,
    ) {
      final hasCompletedUpdate =
          previous?.loadingMethod == IdentityLoadingMethod.confirmName &&
          next.loadingMethod == IdentityLoadingMethod.none &&
          next.error == null;

      if (hasCompletedUpdate && context.mounted) {
        Navigator.of(context).pop();
      }
    });

    final user = ref.watch(identityCurrentUserProvider);
    final authState = ref.watch(identityAuthControllerProvider);

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
              context.l10n.userSettingsEditNameTitle,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            MahafezSpacing.sm.verticalSpace,
            Text(
              context.l10n.userSettingsEditNameDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
            MahafezTextField(
              label: context.l10n.fullName,
              hintText: context.l10n.fullNamePlaceholder,
              controller: _nameController,
              keyboardType: TextInputType.name,
              onChanged: (_) {},
              validator: (value) => AppValidators.required(context, value),
            ),
            MahafezSpacing.lg.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: MahafezButton(
                label: context.l10n.userSettingsEditNameSaveAction,
                isLoading:
                    authState.loadingMethod ==
                    IdentityLoadingMethod.confirmName,
                onPressed: user == null ? null : () => _submit(user.uid),
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _submit(String uid) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final displayName = _nameController.text.trim();
    if (displayName == widget.currentName.trim()) {
      Navigator.of(context).pop();
      return;
    }

    ref
        .read(identityAuthControllerProvider.notifier)
        .updateDisplayName(uid: uid, displayName: displayName);
  }
}
