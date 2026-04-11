import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/extensions/failure_extension.dart';
import '../../../../core/utils/extensions/wallet_provider_ext.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../generated/l10n.dart';
import '../../providers/wallets_providers.dart';
import '../providers/add_wallet_controller.dart';

class AddWalletScreen extends StatelessWidget {
  const AddWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addWalletTitle),
        centerTitle: true,
      ),
      body: const SafeArea(child: _AddWalletBody()),
    );
  }
}

class _AddWalletBody extends ConsumerWidget {
  const _AddWalletBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(addWalletSubmitProvider, (previous, next) {
      _handleStateChange(previous, next, ref, context);
    });

    final s = S.of(context);
    final theme = Theme.of(context);
    final submitState = ref.watch(addWalletSubmitProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppResponsive.allPadding(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoCard(text: s.addWalletDescription),
                AppSpacing.xxl.verticalSpace,
                AppTextField(
                  label: s.phoneNumber,
                  hintText: AppConstants.egyptPhoneHint,
                  keyboardType: TextInputType.phone,
                  onChanged: ref
                      .read(addWalletControllerProvider.notifier)
                      .updatePhoneNumber,
                  prefixIcon: Padding(
                    padding: AppResponsive.symmetricPadding(
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Text(
                          AppConstants.egyptCountryCode,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          AppConstants.egyptFlag,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.xl.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                AppSpacing.md.verticalSpace,
                const _ProvidersGrid(key: ValueKey('_ProvidersGrid')),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppResponsive.allPadding(AppSpacing.lg),
          child: AppButton(
            label: s.addWalletAction,
            icon: const Icon(Icons.add_circle_outline),
            isLoading: submitState.isLoading,
            onPressed: () {
              ref.read(addWalletSubmitProvider.notifier).submit();
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleStateChange(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
    WidgetRef ref,
    BuildContext context,
  ) async {
    if (next is AsyncError) {
      if (!context.mounted) return;
      final error = next.error;
      AppSnackbar.show(
        context,
        message: error is Failure
            ? error.toLocalizedString(context)
            : error.toString(),
        type: AppSnackbarType.error,
      );
      return;
    }

    if (next is AsyncData && previous?.isLoading == true) {
      if (!context.mounted) return;
      final hasPerm = await _checkSmsPermission(ref);
      if (!context.mounted) return;

      if (hasPerm) {
        context.go(AppRoutes.home);
      } else {
        ref.read(hasPromptedSmsPermissionSessionProvider.notifier).state = true;
        context.push(AppRoutes.smsPermissions);
      }
    }
  }

  Future<bool> _checkSmsPermission(WidgetRef ref) async {
    final result = await ref.read(checkSmsPermissionUseCaseProvider)();
    return result.dataOrNull == true;
  }
}

class _ProvidersGrid extends ConsumerWidget {
  const _ProvidersGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addWalletControllerProvider);
    final providers = WalletProvider.values
        .where((p) => p != WalletProvider.unknown)
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md.responsiveWidth,
        mainAxisSpacing: AppSpacing.md.responsiveHeight,
        childAspectRatio: 1.5,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        final isSelected = state.selectedProviders.contains(provider);
        return GestureDetector(
          onTap: () => ref
              .read(addWalletControllerProvider.notifier)
              .toggleProvider(provider),
          child: _ProviderCard(
            key: ValueKey('_ProviderCard_${provider.name}'),
            name: provider.displayName(context),
            iconData: provider.icon,
            color: provider.brandColor,
            isSelected: isSelected,
          ),
        );
      },
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.name,
    required this.iconData,
    required this.color,
    this.isSelected = false,
  });

  final String name;
  final IconData iconData;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppResponsive.allPadding(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: color),
          ),
          AppSpacing.sm.verticalSpace,
          Text(
            name,
            style: isSelected
                ? theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
