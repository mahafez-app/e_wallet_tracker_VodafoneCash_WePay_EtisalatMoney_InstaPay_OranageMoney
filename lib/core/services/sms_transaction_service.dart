import 'dart:developer';

import 'package:another_telephony/telephony.dart';

import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../data/models/pending_sms_retry_item.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/entities/wallet_entity.dart';
import '../domain/enums/transaction_type.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';
import 'background_sms_handler.dart';
import 'pending_sms_retry_service.dart';

final class SmsTransactionService {
  SmsTransactionService({
    required SaveTransactionUseCase saveTransactionUseCase,
    required PendingSmsRetryService pendingSmsRetryService,
  }) : _saveTransactionUseCase = saveTransactionUseCase,
       _pendingSmsRetryService = pendingSmsRetryService;

  final SaveTransactionUseCase _saveTransactionUseCase;
  final PendingSmsRetryService _pendingSmsRetryService;

  List<WalletEntity> _wallets = const [];
  bool _isListening = false;

  static const _tag = 'SmsTransactionService';

  void updateWallets(List<WalletEntity> wallets) => _wallets = wallets;

  void startListening() {
    if (_isListening) return;

    Telephony.instance.listenIncomingSms(
      onNewMessage: _handleForegroundMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    _isListening = true;
    log('SMS listener active (wallets: ${_wallets.length})', name: _tag);
  }

  Future<void> handleIncomingSms({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) async {
    if (await _processCore(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
    )) {
      await sweepRetryQueue();
    }
  }

  Future<void> sweepRetryQueue() async {
    await _pendingSmsRetryService.retryPending(
      processItem: (item) => _processCore(
        sender: item.sender,
        body: item.body,
        smsReceivedAt: item.smsReceivedAt,
      ),
    );
  }

  void _handleForegroundMessage(SmsMessage message) {
    logSmsDetails(message, isBackground: false);
    final sender = message.address, body = message.body;
    if (sender == null || body == null) return;

    handleIncomingSms(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
    );
  }

  Future<bool> _processCore({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) async {
    final parseResult = SmsParsingService.parseRaw(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
    );

    if (parseResult == null) return true;

    final matchResult = _resolveWallet(
      sender: sender,
      amount: parseResult.amount,
      transactionType: parseResult.type,
      parsedBalance: parseResult.balance,
      counterpartyNumber: parseResult.counterpartyNumber,
      mentionedPhoneNumbers: parseResult.mentionedPhoneNumbers,
    );

    switch (matchResult) {
      case SmsWalletDefiniteMiss():
        // Wallet phone derived from SMS structure matches no registered wallet.
        // The transaction provably does not belong here — discard silently.
        log(
          'Definite miss: derived wallet phone matches no registered wallet. '
          'Discarding.',
          name: _tag,
        );
        return true;
      case SmsWalletNoCandidate():
        log('Wallet not found for recognized provider. Enqueuing.', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: smsReceivedAt,
          error: 'Wallet not found',
        );
        return false;
      case SmsWalletMatchedResult(:final wallet):
        final transaction = SmsParsingService.buildEntity(
          result: parseResult,
          walletId: wallet.id,
          walletOwnerUid: wallet.ownerUid,
          walletPhoneNumber: wallet.phoneNumber,
          rawMessage: body,
        );
        return _save(transaction, sender: sender, body: body);
    }
  }

  SmsWalletMatchResult _resolveWallet({
    required String sender,
    double? amount,
    TransactionType? transactionType,
    double? parsedBalance,
    String? counterpartyNumber,
    List<String> mentionedPhoneNumbers = const <String>[],
  }) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return const SmsWalletNoCandidate();

    final candidates = _wallets
        .where((w) => w.provider == parser.provider)
        .toList();
    if (candidates.isEmpty) {
      log('No wallet registered for provider ${parser.provider}.', name: _tag);
      return const SmsWalletNoCandidate();
    }

    final input = SmsWalletMatchInput(
      amount: amount,
      transactionType: transactionType,
      parsedBalance: parsedBalance,
      counterpartyNumber: counterpartyNumber,
      mentionedPhoneNumbers: mentionedPhoneNumbers,
    );

    return SmsWalletMatcher.resolve(wallets: candidates, input: input);
  }

  Future<bool> _save(
    TransactionEntity transaction, {
    required String sender,
    required String body,
  }) async {
    final result = await _saveTransactionUseCase(transaction);
    return result.fold(
      (failure) {
        log('Failed to save transaction: ${failure.runtimeType}', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: transaction.createdAt,
          walletId: transaction.walletId,
          providerName: transaction.provider.toValue,
          error: failure.toString(),
        );
        return false;
      },
      (_) {
        log('Transaction saved: ${transaction.id}', name: _tag);
        return true;
      },
    );
  }

  void _enqueueFailure({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    String? walletId,
    String? providerName,
    required String error,
  }) {
    final item = PendingSmsRetryItem.create(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      walletId: walletId,
      providerName: providerName,
      error: error,
    );
    if (item != null) _pendingSmsRetryService.enqueue(item);
  }
}
