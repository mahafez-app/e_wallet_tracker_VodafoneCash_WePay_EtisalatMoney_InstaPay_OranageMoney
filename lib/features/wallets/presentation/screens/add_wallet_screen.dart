import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/failure_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
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
    ref.listen<AsyncValue<void>>(addWalletSubmitProvider, (_, next) async {
      if (next is AsyncData) {
        final checkPerm = ref.read(checkSmsPermissionUseCaseProvider);
        final hasPerm = await checkPerm();

        if (context.mounted) {
          if (hasPerm.dataOrNull == true) {
            context.go(AppRoutes.home);
          } else {
            context.push(AppRoutes.smsPermissions);
          }
        }
      } else if (next is AsyncError) {
        final error = next.error;
        final message = error is Failure
            ? error.toLocalizedString(context)
            : error.toString();

        AppSnackbar.show(
          context,
          message: message,
          type: AppSnackbarType.error,
        );
      }
    });

    final s = S.of(context);
    final theme = Theme.of(context);
    final submitState = ref.watch(addWalletSubmitProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg.responsiveRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoCard(text: s.addWalletDescription),
                AppSpacing.xxl.verticalSpace,
                AppTextField(
                  label: s.phoneNumber,
                  hintText: '01X XXXX XXXX',
                  keyboardType: TextInputType.phone,
                  onChanged: ref
                      .read(addWalletControllerProvider.notifier)
                      .updatePhoneNumber,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md.responsiveWidth,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('+20', style: theme.textTheme.titleSmall),
                        AppSpacing.xs.horizontalSpace,
                        Text('🇪🇬', style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
                AppSpacing.xl.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                AppSpacing.md.verticalSpace,
                const _ProvidersGrid(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.lg.responsiveRadius),
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
}

class _InfoCard extends StatelessWidget {
  final String text;

  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.responsiveRadius),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(12.responsiveRadius),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4.responsiveWidth,
          ),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProvidersGrid extends ConsumerWidget {
  const _ProvidersGrid();

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
  final String name;
  final IconData iconData;
  final Color color;
  final bool isSelected;

  const _ProviderCard({
    required this.name,
    required this.iconData,
    required this.color,
    this.isSelected = false,
  });

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
            padding: EdgeInsets.all(AppSpacing.sm.responsiveRadius),
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
