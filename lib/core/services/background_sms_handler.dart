import 'dart:developer';
import 'dart:ui';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/transactions/data/datasources/transaction_firestore_support.dart';
import '../../features/transactions/data/datasources/wallet_transaction_remote_data_source.dart';
import '../../firebase_options.dart';
import '../cache/wallet_meta_cache.dart';
import '../data/models/pending_sms_retry_item.dart';
import '../data/models/wallet_dto.dart';
import '../domain/enums/transaction_type.dart';
import '../error/failures.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';
import 'pending_sms_retry_service.dart';

// ── Public helpers ────────────────────────────────────────────────────────────

/// Logs all relevant fields of an incoming SMS for diagnostics.
void logSmsDetails(SmsMessage message, {required bool isBackground}) {
  final tag = isBackground ? 'BackgroundSms' : 'ForegroundSms';
  log('-------', name: tag);
  log('Address: ${message.address}', name: tag);
  log('Body: ${message.body}', name: tag);
  log('Date: ${message.date}', name: tag);
  log('-------', name: tag);
}

// ── Background entry point ────────────────────────────────────────────────────

/// Top-level background handler required by [Telephony.listenIncomingSms].
///
/// Must be a top-level function. The [pragma] annotation prevents the AOT
/// compiler from tree-shaking it in release builds.
///
/// In background mode (app killed), Riverpod is unavailable. We bootstrap
/// only what we need: Firebase, Hive, and the Firestore data source.
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  await _BackgroundDependencies.init();

  logSmsDetails(message, isBackground: true);

  final sender = message.address;
  final body = message.body;
  if (sender == null || body == null) return;

  // Quick guard: reject entirely unknown senders before Firestore access.
  if (SmsParserRegistry.resolve(sender) == null) {
    log('Ignoring: unknown sender "$sender".', name: 'BackgroundSms');
    return;
  }

  final retryBox = Hive.box<String>(_BackgroundDependencies.retryBoxName);
  final processor = _BackgroundSmsProcessor(retryBox: retryBox);

  await processor.process(
    sender: sender,
    body: body,
    smsReceivedAt: message.receivedAt,
  );
}

// ── Background processor ──────────────────────────────────────────────────────

/// Encapsulates background-mode SMS processing.
///
/// Separated from the top-level handler so it can be instantiated with its
/// dependencies explicitly, making it testable without a live Firebase session.
final class _BackgroundSmsProcessor {
  const _BackgroundSmsProcessor({required Box<String> retryBox})
    : _retryBox = retryBox;

  final Box<String> _retryBox;

  static const _tag = 'BackgroundSms';

  /// Full pipeline: parse -> wallet resolution -> saving -> retry sweep.
  Future<void> process({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) async {
    PendingSmsRetryItem? queueItem;
    try {
      final uid = await _resolveUserUid();
      if (uid == null) {
        log(
          'Aborting: user not authenticated and no fallback UID.',
          name: _tag,
        );
        return;
      }

      queueItem = PendingSmsRetryItem.create(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        userUid: uid,
        error: 'Captured in background for durable processing',
      );
      if (queueItem == null) return;

      await _enqueue(queueItem);
      log('Background SMS queued for durable processing.', name: _tag);

      final result = await _runPipeline(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        uid: uid,
      );

      if (result.success) {
        await PendingSmsRetryService(box: _retryBox).remove(queueItem.id);
        return;
      }

      await PendingSmsRetryService(
        box: _retryBox,
      ).markFailure(queueItem.id, result.error);
    } catch (e, st) {
      log(
        'Unhandled background error: $e. Enqueuing for retry.',
        stackTrace: st,
        name: _tag,
      );
      if (queueItem != null) {
        await PendingSmsRetryService(
          box: _retryBox,
        ).markFailure(queueItem.id, e.toString());
      }
    }
  }

  Future<_BackgroundProcessingResult> _runPipeline({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required String uid,
  }) async {
    final parseResult = SmsParsingService.parseRaw(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
    );

    if (parseResult == null) {
      log('SMS did not match any transaction pattern.', name: _tag);
      return const _BackgroundProcessingResult.success();
    }

    final matchResult = await _resolveWallet(
      uid: uid,
      providerName: parseResult.provider.toValue,
      amount: parseResult.amount,
      transactionType: parseResult.type,
      parsedBalance: parseResult.balance,
      counterpartyNumber: parseResult.counterpartyNumber,
      mentionedPhoneNumbers: parseResult.mentionedPhoneNumbers,
    );

    switch (matchResult) {
      case SmsWalletDefiniteMiss():
        log(
          'Definite miss: derived wallet phone matches no registered wallet. '
          'Discarding.',
          name: _tag,
        );
        return const _BackgroundProcessingResult.success();
      case SmsWalletNoCandidate():
        return const _BackgroundProcessingResult.failure('Wallet not found');
      case SmsWalletMatchedResult(:final wallet):
        final transaction = SmsParsingService.buildEntity(
          result: parseResult,
          walletId: wallet.id,
          walletOwnerUid: wallet.ownerUid,
          walletPhoneNumber: wallet.phoneNumber,
          rawMessage: body,
        );

        try {
          await _buildDataSource().saveTransaction(transaction);
          log('Transaction saved: ${transaction.id}', name: _tag);
          return const _BackgroundProcessingResult.success();
        } on ValidationFailure catch (failure) {
          if (failure.code == 'transaction-already-exists') {
            return const _BackgroundProcessingResult.success();
          }
          return _BackgroundProcessingResult.failure(failure.toString());
        } catch (e) {
          return _BackgroundProcessingResult.failure(e.toString());
        }
    }
  }

  Future<SmsWalletMatchResult> _resolveWallet({
    required String uid,
    required String providerName,
    double? amount,
    TransactionType? transactionType,
    double? parsedBalance,
    String? counterpartyNumber,
    List<String> mentionedPhoneNumbers = const <String>[],
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .where('ownerUid', isEqualTo: uid)
        .where('provider', isEqualTo: providerName)
        .get();

    if (snapshot.docs.isEmpty) return const SmsWalletNoCandidate();

    final candidates = snapshot.docs
        .map((document) => WalletDto.fromFirestore(document).toEntity())
        .toList(growable: false);

    return SmsWalletMatcher.resolve(
      wallets: candidates,
      input: SmsWalletMatchInput(
        amount: amount,
        transactionType: transactionType,
        parsedBalance: parsedBalance,
        counterpartyNumber: counterpartyNumber,
        mentionedPhoneNumbers: mentionedPhoneNumbers,
      ),
    );
  }

  Future<void> _enqueue(PendingSmsRetryItem item) {
    return PendingSmsRetryService(box: _retryBox).enqueue(item);
  }

  WalletTransactionRemoteDataSource _buildDataSource() {
    return WalletTransactionRemoteDataSourceImpl(
      support: TransactionFirestoreSupport(
        firestore: FirebaseFirestore.instance,
        metaCache: WalletMetaCache(),
      ),
    );
  }

  Future<String?> _resolveUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_known_user_uid');
  }
}

// ── Bootstrap ─────────────────────────────────────────────────────────────────

final class _BackgroundDependencies {
  _BackgroundDependencies._();

  static const retryBoxName = 'pending_sms_retry_queue';

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await Hive.initFlutter();
    if (!Hive.isBoxOpen(retryBoxName)) {
      await Hive.openBox<String>(retryBoxName);
    }
  }
}

final class _BackgroundProcessingResult {
  const _BackgroundProcessingResult.success() : success = true, error = '';

  const _BackgroundProcessingResult.failure(this.error) : success = false;

  final bool success;
  final String error;
}
