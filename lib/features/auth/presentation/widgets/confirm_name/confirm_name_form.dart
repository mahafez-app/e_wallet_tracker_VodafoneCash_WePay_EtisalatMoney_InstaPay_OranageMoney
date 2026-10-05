import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_providers.dart';
import '../../providers/auth_controller.dart';

class ConfirmNameForm extends ConsumerStatefulWidget {
  const ConfirmNameForm({super.key});

  @override
  ConsumerState<ConfirmNameForm> createState() => _ConfirmNameFormState();
}

class _ConfirmNameFormState extends ConsumerState<ConfirmNameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null && user.name.isNotEmpty) {
        _nameController.text = user.name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref
            .read(authNotifierProvider.notifier)
            .updateDisplayName(
              uid: user.uid,
              displayName: _nameController.text.trim(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.loadingMethod == AuthLoadingMethod.confirmName;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          MahafezTextField(
            controller: _nameController,
            label: l10n.fullName,
            hintText: l10n.fullNamePlaceholder,
            prefixIcon: const Icon(Icons.person_outline),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.fullNameValidationEmpty;
              }
              return null;
            },
          ),

          40.responsiveHeight.verticalSpace,

          // Submit Button
          MahafezButton(
            label: l10n.confirm,
            onPressed: _submit,
            isLoading: isLoading,
          ),

          MahafezSpacing.xl.verticalSpace,
        ],
      ),
    );
  }
}
