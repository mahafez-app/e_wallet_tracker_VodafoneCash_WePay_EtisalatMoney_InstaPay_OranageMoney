import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../data/models/pending_sms_retry_item.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/entities/wallet_entity.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';
import 'background_sms_handler.dart';
import 'pending_sms_retry_service.dart';


/// Wraps [Telephony.instance.listenIncomingSms] and routes every incoming
/// SMS through the parser pipeline. If a transaction is recognized it is
/// persisted via [SaveTransactionUseCase].
///
/// Call [startListening] once per session (typically when wallets load on the
/// home screen). Call [stopListening] (or rely on Riverpod [ref.onDispose])
/// when the provider is disposed.
class SmsTransactionService {
  SmsTransactionService({
    required SaveTransactionUseCase saveTransactionUseCase,
    required PendingSmsRetryService pendingSmsRetryService,
  })  : _saveTransactionUseCase = saveTransactionUseCase,
        _pendingSmsRetryService = pendingSmsRetryService;

  List<WalletEntity> _wallets = const [];
  final SaveTransactionUseCase _saveTransactionUseCase;
  final PendingSmsRetryService _pendingSmsRetryService;
  bool _isListening = false;

  static const _tag = 'SmsTransactionService';

  void updateWallets(List<WalletEntity> wallets) {
    _wallets = wallets;
  }

  void startListening() {
    if (_isListening) {
      return;
    }

    Telephony.instance.listenIncomingSms(
      onNewMessage: _handleForegroundMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    _isListening = true;
    log('SMS listener active (Wallets: ${_wallets.length})', name: _tag);
  }

  void _handleForegroundMessage(SmsMessage message) {
    logSmsDetails(message, isBackground: false);
    final sender = message.address;
    final body = message.body;

    if (sender == null || body == null) return;

    processSms(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
      subscriptionId: message.subscriptionId,
    );
  }

  /// Processes an SMS message. Returns true if successfully saved or ignored as non-transaction.
  /// Returns false if enqueued for retry.
  Future<bool> processSms({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required int? subscriptionId,
  }) async {
    final wallet = _getWalletForSender(sender, subscriptionId);

    // If we can't find a wallet but it's a recognized provider, enqueue for later.
    // Maybe the wallets haven't synced yet.
    if (wallet == null) {
      final parser = SmsParserRegistry.resolve(sender);
      if (parser != null) {
        log(
          'Wallet not found for recognized provider ${parser.provider}. Enqueuing.',
          name: _tag,
        );
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: smsReceivedAt,
          subscriptionId: subscriptionId,
          error: 'Wallet not found',
        );
        return false;
      }
      return true; // Ignored (unrecognized provider)
    }

    final transaction = SmsParsingService.parse(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
      walletId: wallet.id,
      walletOwnerUid: wallet.ownerUid,
      walletPhoneNumber: wallet.phoneNumber,
    );

    if (transaction != null) {
      return _saveTransactionAsync(
        transaction,
        sender: sender,
        body: body,
        subscriptionId: subscriptionId,
      );
    } else {
      log(
        'SMS from $sender did not match any transaction pattern.',
        name: _tag,
      );
      return true; // Success (ignored by pattern)
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

  Future<bool> _saveTransactionAsync(
    TransactionEntity transaction, {
    required String sender,
    required String body,
    required int? subscriptionId,
  }) async {
    final result = await _saveTransactionUseCase(transaction);
    return result.fold(
      (failure) {
        log('Failed to save: ${failure.runtimeType}', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: transaction.createdAt,
          subscriptionId: subscriptionId,
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
    required int? subscriptionId,
    String? walletId,
    String? providerName,
    required String error,
  }) {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    if (userUid == null) return;

    final id = PendingSmsRetryService.generateQueueKey(
      sender: sender,
      body: body,
      receivedAt: smsReceivedAt,
    );

    final item = PendingSmsRetryItem(
      id: id,
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      userUid: userUid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      subscriptionId: subscriptionId,
      walletId: walletId,
      providerName: providerName,
      lastError: error,
    );

    _pendingSmsRetryService.enqueue(item);
  }
}
