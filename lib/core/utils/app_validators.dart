import 'package:flutter/widgets.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

abstract final class AppValidators {
  static String? email(BuildContext context, String? value) {
    final l10n = context.l10n;
    final val = value?.trim();
    if (val == null || val.isEmpty) {
      return l10n.errorValidation;
    }

    final isValid = RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(val);
    if (!isValid) {
      return l10n.errorAuthInvalidEmail;
    }
    return null;
  }

  static String? password(BuildContext context, String? value) {
    final l10n = context.l10n;
    if (value == null || value.isEmpty) {
      return l10n.errorValidation;
    }
    if (value.length < 6) {
      // Return a general validation error or a specific one if added to arb
      return l10n.errorValidation;
    }
    return null;
  }

  static String? required(BuildContext context, String? value) {
    final l10n = context.l10n;
    if (value == null || value.trim().isEmpty) {
      return l10n.errorValidation;
    }
    return null;
  }
}
