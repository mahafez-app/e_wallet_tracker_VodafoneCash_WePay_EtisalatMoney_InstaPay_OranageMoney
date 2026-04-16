import 'dart:developer';
import 'dart:ui';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/transactions/data/datasources/transaction_firestore_support.dart';
import '../../features/transactions/data/datasources/wallet_transaction_remote_data_source.dart';
import '../../firebase_options.dart';
import '../cache/wallet_meta_cache.dart';
import '../data/models/pending_sms_retry_item.dart';
import '../data/models/wallet_dto.dart';
import '../domain/entities/wallet_entity.dart';
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
  log('SubscriptionId: ${message.subscriptionId}', name: tag);
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
  logSmsDetails(message, isBackground: true);

  final sender = message.address;
  final body = message.body;
  if (sender == null || body == null) return;

  final parser = SmsParserRegistry.resolve(sender);
  if (parser == null) {
    log('Ignoring: unknown sender.', name: 'BackgroundSms');
    return;
  }

  await _BackgroundDependencies.init();

  final retryBox = Hive.box<String>(_BackgroundDependencies.retryBoxName);
  final processor = _BackgroundSmsProcessor(retryBox: retryBox);

  await processor.process(
    sender: sender,
    body: body,
    smsReceivedAt: message.receivedAt,
    providerName: parser.provider.toValue,
    subscriptionId: message.subscriptionId,
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

  /// Full pipeline: wallet resolution → parsing → saving → retry sweep.
  ///
  /// Returns `true` if the item was handled (saved or intentionally ignored).
  Future<void> process({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required String providerName,
    required int? subscriptionId,
  }) async {
    try {
      final success = await _runPipeline(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        providerName: providerName,
        subscriptionId: subscriptionId,
      );

      if (success) await _sweepRetryQueue();
    } catch (e, st) {
      log('Unhandled background error: $e. Enqueuing for retry.',
          stackTrace: st, name: _tag);
      _enqueue(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        subscriptionId: subscriptionId,
        providerName: providerName,
        error: e.toString(),
      );
    }
  }

  // ── Pipeline steps ──────────────────────────────────────────────────────

  Future<bool> _runPipeline({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    required String providerName,
    required int? subscriptionId,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      log('Ignoring: user not logged in.', name: _tag);
      return true; // Nothing we can do — treat as handled.
    }

    final wallet = await _resolveWallet(
      uid: currentUser.uid,
      providerName: providerName,
      subscriptionId: subscriptionId,
    );

    if (wallet == null) {
      log('No matching wallet for provider $providerName. Enqueuing.',
          name: _tag);
      _enqueue(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        subscriptionId: subscriptionId,
        providerName: providerName,
        error: 'Wallet not found',
      );
      return false;
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
      log('SMS did not match any transaction pattern.', name: _tag);
      return true; // Pattern miss — ignore silently.
    }

    try {
      await _buildDataSource().saveTransaction(transaction);
      log('Transaction saved: ${transaction.id}', name: _tag);
      return true;
    } catch (e) {
      _enqueue(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
        subscriptionId: subscriptionId,
        walletId: wallet.id,
        providerName: wallet.provider.toValue,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<WalletEntity?> _resolveWallet({
    required String uid,
    required String providerName,
    required int? subscriptionId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: uid)
        .where('provider', isEqualTo: providerName)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final candidates =
        snapshot.docs.map((d) => WalletDto.fromFirestore(d).toEntity()).toList();

    final matchResult = SmsWalletMatcher.resolve(
      wallets: candidates,
      subscriptionId: subscriptionId,
    );

    if (matchResult.needsSubscriptionMapping && subscriptionId != null) {
      // Best-effort: don't let a Firestore write block the main pipeline.
      firestore
          .collection('wallets')
          .doc(matchResult.wallet.id)
          .update({'subscriptionId': subscriptionId})
          .then((_) => log(
                'Learned subscriptionId $subscriptionId for wallet ${matchResult.wallet.id}',
                name: _tag,
              ))
          .catchError(
            (Object e) => log('Failed to link subscriptionId: $e', name: _tag),
          );
    }

    return matchResult.wallet;
  }

  // ── Retry queue ─────────────────────────────────────────────────────────

  Future<void> _sweepRetryQueue() async {
    if (_retryBox.isEmpty) return;

    final retryService = PendingSmsRetryService(box: _retryBox);
    await retryService.retryPending(
      processItem: (item) async {
        try {
          final providerName = _resolveProviderName(item);
          if (providerName == null) return true; // Unrecognised — discard.

          return _runPipeline(
            sender: item.sender,
            body: item.body,
            smsReceivedAt: item.smsReceivedAt,
            providerName: providerName,
            subscriptionId: item.subscriptionId,
          );
        } catch (e) {
          log('Retry failed for ${item.id}: $e', name: _tag);
          return false;
        }
      },
    );
  }

  String? _resolveProviderName(PendingSmsRetryItem item) {
    if (item.providerName != null && item.providerName!.isNotEmpty) {
      return item.providerName;
    }
    return SmsParserRegistry.resolve(item.sender)?.provider.toValue;
  }

  // ── Enqueue ─────────────────────────────────────────────────────────────

  void _enqueue({
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
    if (item == null) return; // No logged-in user — nothing to persist against.

    PendingSmsRetryService(box: _retryBox).enqueue(item);
  }

  // ── Data source factory ─────────────────────────────────────────────────

  WalletTransactionRemoteDataSource _buildDataSource() {
    return WalletTransactionRemoteDataSourceImpl(
      support: TransactionFirestoreSupport(
        firestore: FirebaseFirestore.instance,
        metaCache: WalletMetaCache(),
      ),
    );
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
