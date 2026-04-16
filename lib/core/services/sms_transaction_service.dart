import 'dart:developer';

import 'package:another_telephony/telephony.dart';

import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../../features/wallets/domain/usecases/link_subscription_id_usecase.dart';
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
/// SMS through the parser pipeline. If a transaction is recognised it is
/// persisted via [SaveTransactionUseCase].
///
/// Call [startListening] once per session (typically when wallets load).
/// Riverpod's [ref.onDispose] handles teardown automatically.
final class SmsTransactionService {
  SmsTransactionService({
    required SaveTransactionUseCase saveTransactionUseCase,
    required PendingSmsRetryService pendingSmsRetryService,
    required LinkSubscriptionIdUseCase linkSubscriptionIdUseCase,
  })  : _saveTransactionUseCase = saveTransactionUseCase,
        _pendingSmsRetryService = pendingSmsRetryService,
        _linkSubscriptionIdUseCase = linkSubscriptionIdUseCase;

  final SaveTransactionUseCase _saveTransactionUseCase;
  final PendingSmsRetryService _pendingSmsRetryService;
  final LinkSubscriptionIdUseCase _linkSubscriptionIdUseCase;

  List<WalletEntity> _wallets = const [];
  bool _isListening = false;

  static const _tag = 'SmsTransactionService';

  void updateWallets(List<WalletEntity> wallets) {
    _wallets = wallets;
  }

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

  // ── Entry points ─────────────────────────────────────────────────────────

  /// Processes a foreground SMS and triggers a passive retry sweep on success.
  Future<void> handleIncomingSms({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required int? subscriptionId,
  }) async {
    final success = await _processCore(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      subscriptionId: subscriptionId,
    );

    if (success) await sweepRetryQueue();
  }

  /// Triggers a passive sweep of the pending-retry queue.
  ///
  /// Called after every successful transaction and on app start so that
  /// "stuck" items eventually clear themselves.
  Future<void> sweepRetryQueue() async {
    await _pendingSmsRetryService.retryPending(
      processItem: (item) => _processCore(
        sender: item.sender,
        body: item.body,
        smsReceivedAt: item.smsReceivedAt,
        subscriptionId: item.subscriptionId,
      ),
    );
  }

  // ── Internal pipeline ────────────────────────────────────────────────────

  void _handleForegroundMessage(SmsMessage message) {
    logSmsDetails(message, isBackground: false);

    final sender = message.address;
    final body = message.body;
    if (sender == null || body == null) return;

    handleIncomingSms(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
      subscriptionId: message.subscriptionId,
    );
  }

  /// Core pipeline: wallet resolution → parsing → saving.
  ///
  /// Returns `true` if the SMS was handled (saved or intentionally ignored),
  /// `false` if a recoverable failure occurred and the item was enqueued.
  Future<bool> _processCore({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required int? subscriptionId,
  }) async {
    final wallet = _resolveWallet(sender, subscriptionId);

    if (wallet == null) {
      // Recognized provider but no matching wallet yet — enqueue for retry.
      if (SmsParserRegistry.resolve(sender) != null) {
        log('Wallet not found for recognized provider. Enqueuing.', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: smsReceivedAt,
          subscriptionId: subscriptionId,
          error: 'Wallet not found',
        );
        return false;
      }
      return true; // Unknown provider — ignore silently.
    }

    final transaction = SmsParsingService.parse(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
      walletId: wallet.id,
      walletOwnerUid: wallet.ownerUid,
      walletPhoneNumber: wallet.phoneNumber,
    );

    if (transaction == null) {
      log('SMS from $sender did not match any transaction pattern.', name: _tag);
      return true; // Pattern miss — ignore silently.
    }

    return _save(
      transaction,
      sender: sender,
      body: body,
      subscriptionId: subscriptionId,
    );
  }

  WalletEntity? _resolveWallet(String sender, int? subscriptionId) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return null;

    final candidates =
        _wallets.where((w) => w.provider == parser.provider).toList();
    if (candidates.isEmpty) {
      log('No wallet registered for provider ${parser.provider}.', name: _tag);
      return null;
    }

    final matchResult = SmsWalletMatcher.resolve(
      wallets: candidates,
      subscriptionId: subscriptionId,
    );

    if (matchResult.needsSubscriptionMapping && subscriptionId != null) {
      _persistSubscriptionLink(matchResult.wallet.id, subscriptionId);
    }

    return matchResult.wallet;
  }

  void _persistSubscriptionLink(String walletId, int subscriptionId) {
    _linkSubscriptionIdUseCase(
      LinkSubscriptionIdParams(
        walletId: walletId,
        subscriptionId: subscriptionId,
      ),
    ).then((result) {
      result.fold(
        (failure) => log(
          'Failed to link subscriptionId $subscriptionId: $failure',
          name: _tag,
        ),
        (_) => log(
          'Learned subscriptionId $subscriptionId for wallet $walletId',
          name: _tag,
        ),
      );
    });
  }

  Future<bool> _save(
    TransactionEntity transaction, {
    required String sender,
    required String body,
    required int? subscriptionId,
  }) async {
    final result = await _saveTransactionUseCase(transaction);
    return result.fold(
      (failure) {
        log('Failed to save transaction: ${failure.runtimeType}', name: _tag);
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
    final item = PendingSmsRetryItem.create(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      subscriptionId: subscriptionId,
      walletId: walletId,
      providerName: providerName,
      error: error,
    );
    if (item != null) _pendingSmsRetryService.enqueue(item);
  }
}
