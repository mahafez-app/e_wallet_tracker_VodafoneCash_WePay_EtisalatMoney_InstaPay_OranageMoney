import '../../../../core/domain/entities/wallet_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../../../core/utils/sms/registry/sms_parser_registry.dart';
import '../../../../core/utils/sms/sms_parsing_service.dart';
import '../../../../core/utils/sms/sms_wallet_matcher.dart';
import '../entities/manual_wallet_transaction_assessment.dart';
import '../repositories/wallet_repository.dart';

final class ProcessManualWalletTransactionParams {
  const ProcessManualWalletTransactionParams({
    required this.walletId,
    required this.message,
    required this.smsReceivedAt,
  });

  final String walletId;
  final String message;
  final DateTime smsReceivedAt;
}

final class ProcessManualWalletTransactionUseCase
    implements
        UseCase<
          ManualWalletTransactionAssessment,
          ProcessManualWalletTransactionParams
        > {
  const ProcessManualWalletTransactionUseCase(this._walletRepository);

  final WalletRepository _walletRepository;

  @override
  Future<Result<ManualWalletTransactionAssessment>> call(
    ProcessManualWalletTransactionParams params,
  ) async {
    final walletsResult = await _walletRepository.getWallets();
    return walletsResult.fold(
      FailureResult.new,
      (wallets) => _process(wallets: wallets, params: params),
    );
  }

  Result<ManualWalletTransactionAssessment> _process({
    required List<WalletEntity> wallets,
    required ProcessManualWalletTransactionParams params,
  }) {
    final trimmedMessage = params.message.trim();
    if (trimmedMessage.isEmpty) {
      return const FailureResult(
        ValidationFailure(code: 'manual-transaction-message-required'),
      );
    }

    final selectedWallet = _findWalletById(wallets, params.walletId);
    if (selectedWallet == null) {
      return const FailureResult(ValidationFailure(code: 'wallet-not-found'));
    }

    final parser = SmsParserRegistry.resolveByProvider(selectedWallet.provider);
    final parseResult = parser?.parse(
      trimmedMessage,
      params.smsReceivedAt,
      useContentDate: true,
    );
    if (parseResult == null) {
      return const FailureResult(
        ValidationFailure(code: 'manual-transaction-unrecognized'),
      );
    }

    final explicitWalletPhone = _resolveIntendedWalletPhone(
      trimmedMessage,
      parseResult.counterpartyNumber,
    );

    final assessment = ManualWalletTransactionAssessment(
      transaction: SmsParsingService.buildEntity(
        result: parseResult,
        walletId: selectedWallet.id,
        walletOwnerUid: selectedWallet.ownerUid,
        walletPhoneNumber: selectedWallet.phoneNumber,
        rawMessage: trimmedMessage,
      ),
      explicitWalletPhone: explicitWalletPhone,
    );
    final input = SmsWalletMatchInput(
      amount: parseResult.amount,
      transactionType: parseResult.type,
      parsedBalance: parseResult.balance,
      counterpartyNumber: parseResult.counterpartyNumber,
      mentionedPhoneNumbers: parseResult.mentionedPhoneNumbers,
    );

    final explicitlyMentionedWallet = _findWalletByPhone(
      wallets,
      explicitWalletPhone,
    );

    if (explicitlyMentionedWallet != null &&
        explicitlyMentionedWallet.id != selectedWallet.id) {
      return Success(
        ManualWalletTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualWalletTransactionReviewKind.explicitWalletMismatch,
          suggestedWallet: explicitlyMentionedWallet,
          explicitWalletPhone: explicitWalletPhone,
        ),
      );
    }

    if (explicitWalletPhone != null && explicitlyMentionedWallet == null) {
      // Return Success instead of Failure to show the user the parsed data and the mismatch.
      return Success(
        ManualWalletTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualWalletTransactionReviewKind.explicitWalletMismatch,
          explicitWalletPhone: explicitWalletPhone,
        ),
      );
    }

    final candidateWallets = wallets
        .where((wallet) => wallet.provider == selectedWallet.provider)
        .toList();

    final matchResult = SmsWalletMatcher.resolve(
      wallets: candidateWallets,
      input: input,
    );

    return switch (matchResult) {
      SmsWalletMatchedResult(:final wallet)
          when wallet.id == selectedWallet.id =>
        Success(assessment),
      SmsWalletMatchedResult(:final wallet) => Success(
        ManualWalletTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualWalletTransactionReviewKind.inferredWalletMismatch,
          suggestedWallet: wallet,
        ),
      ),
      SmsWalletNoCandidate() => Success(
        ManualWalletTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualWalletTransactionReviewKind.needsConfirmation,
        ),
      ),
      SmsWalletDefiniteMiss() => Success(
        ManualWalletTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualWalletTransactionReviewKind.explicitWalletMismatch,
          explicitWalletPhone: explicitWalletPhone,
        ),
      ),
    };
  }

  WalletEntity? _findWalletById(List<WalletEntity> wallets, String walletId) {
    for (final wallet in wallets) {
      if (wallet.id == walletId) {
        return wallet;
      }
    }

    return null;
  }

  WalletEntity? _findWalletByPhone(
    List<WalletEntity> wallets,
    String? phoneNumber,
  ) {
    if (phoneNumber == null) {
      return null;
    }

    final normalizedPhone = EgyptianPhoneNumber.normalize(phoneNumber);

    for (final wallet in wallets) {
      final normalizedWalletPhone = EgyptianPhoneNumber.normalize(
        wallet.phoneNumber,
      );
      if (normalizedWalletPhone == normalizedPhone ||
          normalizedWalletPhone.endsWith(normalizedPhone) ||
          normalizedPhone.endsWith(normalizedWalletPhone)) {
        return wallet;
      }
    }

    return null;
  }

  /// Identifies the "intended" wallet phone from the message structure.
  /// As per the rule: the first phone found in the text is the counterparty,
  /// the second one is the destination wallet.
  String? _resolveIntendedWalletPhone(String message, String? counterparty) {
    final numbers =
        RegExp(r'01[0125]\d+')
            .allMatches(message)
            .map((m) => m.group(0)!)
            .toList();

    if (numbers.isEmpty) return null;

    final normalizedCounterparty =
        counterparty != null ? EgyptianPhoneNumber.normalize(counterparty) : null;

    // If we have at least one secondary number, it should be the wallet.
    for (final number in numbers) {
      final normalized = EgyptianPhoneNumber.normalize(number);
      if (normalized == normalizedCounterparty) continue;

      return normalized;
    }

    return null;
  }
}
