import 'package:flutter/material.dart';
import 'package:wallet_tracker/core/utils/extensions/localization_extension.dart';

import '../../../../../core/domain/enums/wallet_provider.dart';
import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/info_card.dart';
import '../../providers/add_wallet_state.dart';
import 'add_wallet_phone_number_section.dart';
import 'add_wallet_provider_grid.dart';

class AddWalletContent extends StatelessWidget {
  const AddWalletContent({
    super.key,
    required this.state,
    required this.onPhoneNumberChanged,
    required this.onProviderToggled,
    required this.onSubmit,
  });

  final AddWalletState state;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<WalletProvider> onProviderToggled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoCard(text: s.addWalletDescription),
                AppSpacing.lg.verticalSpace,
                AddWalletPhoneNumberSection(
                  phoneNumber: state.phoneNumber,
                  onPhoneNumberChanged: onPhoneNumberChanged,
                ),
                AppSpacing.lg.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                AppSpacing.md.verticalSpace,
                AddWalletProviderGrid(
                  selectedProviders: state.selectedProviders,
                  allowedProviders: state.allowedProviders,
                  onProviderToggled: onProviderToggled,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppResponsive.allPadding(AppSpacing.md),
          child: AppButton(
            label: s.addWalletAction,
            icon: const Icon(Icons.add_circle_outline),
            isLoading: state.isSubmitting,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
