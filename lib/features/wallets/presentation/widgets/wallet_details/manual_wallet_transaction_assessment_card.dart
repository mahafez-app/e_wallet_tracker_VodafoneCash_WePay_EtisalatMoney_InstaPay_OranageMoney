import 'package:flutter/material.dart';

import '../../../../../core/theme/app_responsive.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/extensions/localization_extension.dart';
import '../../../../../core/widgets/wallets/wallet_provider_info.dart';
import '../../../domain/entities/manual_wallet_transaction_assessment.dart';
import 'manual_wallet_transaction_summary_row.dart';

class ManualWalletTransactionAssessmentCard extends StatelessWidget {
  const ManualWalletTransactionAssessmentCard({
    super.key,
    required this.assessment,
  });

  final ManualWalletTransactionAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = _resolveColors(colorScheme);

    return Container(
      width: double.infinity,
      padding: AppResponsive.allPadding(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.$2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: AppResponsive.allPadding(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.$2.withAlpha(26),
                  borderRadius: BorderRadius.circular(14.responsiveRadius),
                ),
                child: Icon(_icon, color: colors.$3, size: 22.responsiveRadius),
              ),
              AppSpacing.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.xs.verticalSpace,
                    Text(
                      _description(context),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.lg.verticalSpace,
          ManualWalletTransactionSummaryRow(assessment: assessment),
          if (assessment.suggestedWallet != null) ...[
            AppSpacing.lg.verticalSpace,
            Text(
              context.l10n.walletManualTransactionSuggestedWalletLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.sm.verticalSpace,
            WalletProviderInfo(
              provider: assessment.suggestedWallet!.provider,
              phoneNumber: assessment.suggestedWallet!.phoneNumber,
              borderRadius: 12,
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, Color) _resolveColors(ColorScheme colorScheme) {
    return switch (assessment.reviewKind) {
      ManualWalletTransactionReviewKind.explicitWalletMismatch => (
        colorScheme.errorContainer.withAlpha(120),
        colorScheme.error.withAlpha(80),
        colorScheme.error,
      ),
      ManualWalletTransactionReviewKind.inferredWalletMismatch => (
        colorScheme.tertiaryContainer.withAlpha(120),
        colorScheme.tertiary.withAlpha(80),
        colorScheme.tertiary,
      ),
      ManualWalletTransactionReviewKind.needsConfirmation => (
        colorScheme.primaryContainer.withAlpha(100),
        colorScheme.primary.withAlpha(70),
        colorScheme.primary,
      ),
      ManualWalletTransactionReviewKind.none => (
        colorScheme.surfaceContainerHighest,
        colorScheme.outlineVariant,
        colorScheme.primary,
      ),
    };
  }

  IconData get _icon => switch (assessment.reviewKind) {
    ManualWalletTransactionReviewKind.explicitWalletMismatch =>
      Icons.phone_locked_rounded,
    ManualWalletTransactionReviewKind.inferredWalletMismatch =>
      Icons.balance_rounded,
    ManualWalletTransactionReviewKind.needsConfirmation => Icons.rule_rounded,
    ManualWalletTransactionReviewKind.none => Icons.check_circle_rounded,
  };

  String _title(BuildContext context) => switch (assessment.reviewKind) {
    ManualWalletTransactionReviewKind.explicitWalletMismatch =>
      context.l10n.walletManualTransactionExplicitMismatchTitle,
    ManualWalletTransactionReviewKind.inferredWalletMismatch =>
      context.l10n.walletManualTransactionInferredMismatchTitle,
    ManualWalletTransactionReviewKind.needsConfirmation =>
      context.l10n.walletManualTransactionReviewTitle,
    ManualWalletTransactionReviewKind.none =>
      context.l10n.walletManualTransactionReviewTitle,
  };

  String _description(BuildContext context) => switch (assessment.reviewKind) {
    ManualWalletTransactionReviewKind.explicitWalletMismatch =>
      context.l10n.walletManualTransactionExplicitMismatchDescription,
    ManualWalletTransactionReviewKind.inferredWalletMismatch =>
      context.l10n.walletManualTransactionInferredMismatchDescription,
    ManualWalletTransactionReviewKind.needsConfirmation =>
      context.l10n.walletManualTransactionReviewDescription,
    ManualWalletTransactionReviewKind.none =>
      context.l10n.walletManualTransactionReviewDescription,
  };
}
