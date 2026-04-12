import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/extensions/phone_number_extension.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../providers/add_wallet_state.dart';

class AddWalletPhoneNumberSection extends StatelessWidget {
  const AddWalletPhoneNumberSection({
    super.key,
    required this.state,
    required this.onPhoneNumberChanged,
  });

  final AddWalletState state;
  final ValueChanged<String> onPhoneNumberChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isLoadingDevicePhoneNumbers) ...[
          const LinearProgressIndicator(),
          AppSpacing.md.verticalSpace,
        ],
        if (state.devicePhoneNumbers.isEmpty)
          _ManualPhoneNumberField(
            phoneNumber: state.phoneNumber,
            onChanged: onPhoneNumberChanged,
          )
        else
          _DetectedPhoneNumbersList(
            state: state,
            onPhoneNumberChanged: onPhoneNumberChanged,
          ),
      ],
    );
  }
}

class _ManualPhoneNumberField extends StatefulWidget {
  const _ManualPhoneNumberField({
    required this.phoneNumber,
    required this.onChanged,
  });

  final String phoneNumber;
  final ValueChanged<String> onChanged;

  @override
  State<_ManualPhoneNumberField> createState() =>
      _ManualPhoneNumberFieldState();
}

class _ManualPhoneNumberFieldState extends State<_ManualPhoneNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void didUpdateWidget(covariant _ManualPhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text == widget.phoneNumber) return;

    _controller.value = TextEditingValue(
      text: widget.phoneNumber,
      selection: TextSelection.collapsed(offset: widget.phoneNumber.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AppTextField(
      label: s.phoneNumber,
      controller: _controller,
      hintText: AppConstants.egyptPhoneHint,
      keyboardType: TextInputType.phone,
      onChanged: widget.onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
    );
  }
}

class _DetectedPhoneNumbersList extends StatelessWidget {
  const _DetectedPhoneNumbersList({
    required this.state,
    required this.onPhoneNumberChanged,
  });

  final AddWalletState state;
  final ValueChanged<String> onPhoneNumberChanged;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(s.phoneNumber, style: theme.textTheme.titleMedium),
        AppSpacing.md.verticalSpace,
        ...state.devicePhoneNumbers.map((phoneNumber) {
          return Padding(
            padding: AppResponsive.onlyPadding(bottom: AppSpacing.sm),
            child: _PhoneNumberOption(
              phoneNumber: phoneNumber,
              isSelected: state.phoneNumber == phoneNumber,
              onTap: () => onPhoneNumberChanged(phoneNumber),
            ),
          );
        }),
      ],
    );
  }
}

class _PhoneNumberOption extends StatelessWidget {
  const _PhoneNumberOption({
    required this.phoneNumber,
    required this.isSelected,
    required this.onTap,
  });

  final String phoneNumber;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.responsiveRadius),
        child: Ink(
          padding: AppResponsive.allPadding(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withAlpha(30)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.responsiveRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2.responsiveWidth : 1.responsiveWidth,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              AppSpacing.md.horizontalSpace,
              Text(
                phoneNumber.formattedEgyptianPhoneNumber,
                style: isSelected
                    ? theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      )
                    : theme.textTheme.titleMedium,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
