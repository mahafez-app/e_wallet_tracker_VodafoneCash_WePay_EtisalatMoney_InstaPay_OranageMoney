import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/entities/wallet_entity.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';
import 'background_sms_handler.dart';

/// Wraps [Telephony.instance.listenIncomingSms] and routes every incoming
/// SMS through the parser pipeline. If a transaction is recognized it is
/// persisted via [SaveTransactionUseCase].
///
/// Call [startListening] once per session (typically when wallets load on the
/// home screen). Call [stopListening] (or rely on Riverpod [ref.onDispose])
/// when the provider is disposed.
class SmsTransactionService {
  SmsTransactionService({
    required List<WalletEntity> wallets,
    required SaveTransactionUseCase saveTransactionUseCase,
  }) : _wallets = wallets,
       _saveTransactionUseCase = saveTransactionUseCase;

  final List<WalletEntity> _wallets;
  final SaveTransactionUseCase _saveTransactionUseCase;

  static const _tag = 'SmsTransactionService';

  void startListening() {
    Telephony.instance.listenIncomingSms(
      onNewMessage: _handleForegroundMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    log('SMS listener active (Wallets: ${_wallets.length})', name: _tag);
  }

  void stopListening() {
    log('SMS listener disposed.', name: _tag);
  }

  void _handleForegroundMessage(SmsMessage message) {
    logSmsDetails(message, isBackground: false);
    final sender = message.address;
    final body = message.body;

    if (sender == null || body == null) return;

    _processMessage(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
      subscriptionId: message.subscriptionId,
    );
  }

  void _processMessage({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required int? subscriptionId,
  }) {
    final wallet = _getWalletForSender(sender, subscriptionId);
    if (wallet == null) return;

    final transaction = SmsParsingService.parse(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
      walletId: wallet.id,
      walletPhoneNumber: wallet.phoneNumber,
    );

    if (transaction != null) {
      _saveTransaction(transaction);
    } else {
      log(
        'SMS from $sender did not match any transaction pattern.',
        name: _tag,
      );
    }
  }

  WalletEntity? _getWalletForSender(String sender, int? subscriptionId) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return null;

    final matchingWallets = _wallets
        .where((w) => w.provider == parser.provider)
        .toList();
    if (matchingWallets.isEmpty) {
      log('No wallet registered for provider ${parser.provider}.', name: _tag);
      return null;
    }

    final matchResult = SmsWalletMatcher.resolve(
      wallets: matchingWallets,
      subscriptionId: subscriptionId,
    );

    if (matchResult.needsSubscriptionMapping && subscriptionId != null) {
      _linkSubscriptionId(matchResult.wallet.id, subscriptionId);
    }

    return matchResult.wallet;
  }

  void _linkSubscriptionId(String walletId, int subscriptionId) {
    FirebaseFirestore.instance
        .collection('wallets')
        .doc(walletId)
        .update({'subscriptionId': subscriptionId})
        .then((_) {
          log(
            'Learned subscriptionId $subscriptionId for wallet $walletId',
            name: _tag,
          );
        })
        .catchError((e) {
          log('Failed to learn subscriptionId: $e', name: _tag);
        });
  }

  void _saveTransaction(TransactionEntity transaction) {
    _saveTransactionUseCase(transaction).then((result) {
      result.fold(
        (failure) => log('Failed to save: ${failure.runtimeType}', name: _tag),
        (_) => log('Transaction saved: ${transaction.id}', name: _tag),
      );
    });
  }
}
