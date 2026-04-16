import 'dart:convert';
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
import '../cache/wallet_meta_cache.dart';
import '../../firebase_options.dart';
import '../data/models/pending_sms_retry_item.dart';
import '../data/models/wallet_dto.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/entities/wallet_entity.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';
import 'pending_sms_retry_service.dart';


/// Logs all relevant fields of an SMS message.
void logSmsDetails(SmsMessage message, {required bool isBackground}) {
  final prefix = isBackground ? 'BackgroundSms' : 'ForegroundSms';
  log("-------", name: prefix);
  log("Address: ${message.address}", name: prefix);
  log("Body: ${message.body}", name: prefix);
  log("Date: ${message.date}", name: prefix);
  log("SubscriptionId: ${message.subscriptionId}", name: prefix);
  log("-------", name: prefix);
}

/// Top-level background handler — must be a top-level or static function.
/// Required by [Telephony.listenIncomingSms] for background processing.
/// Annotated with [pragma] so the AOT compiler keeps it in release builds.
///
/// In background mode (app killed), Riverpod is unavailable. We manually
/// initialize Firebase, fetch wallets for the current user, parse, and save.
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

  await _initializeDependenciesIfNeeded();

  try {
    final success = await _processCore(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
      providerName: parser.provider.toValue,
      subscriptionId: message.subscriptionId,
    );

    if (success) {
      await _sweepRetryQueue();
    }
  } catch (e, st) {
    log('Background error: $e. Enqueuing for retry.',
        stackTrace: st, name: 'BackgroundSms');
    await _enqueueBackgroundFailure(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
      subscriptionId: message.subscriptionId,
      providerName: parser.provider.toValue,
      error: e.toString(),
    );
  }
}

/// Internal core logic for background processing.
/// Returns true if successfully handled (saved or ignored), false on failure.
Future<bool> _processCore({
  required String sender,
  required String body,
  required DateTime smsReceivedAt,
  required String providerName,
  required int? subscriptionId,
}) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('Ignoring: User not logged in.', name: 'BackgroundSms');
    return true; // "Handled" (nothing we can do)
  }

  final wallet = await _fetchWalletForProvider(
    uid: currentUser.uid,
    providerName: providerName,
    subscriptionId: subscriptionId,
  );

  if (wallet == null) {
    log('Ignoring: No matching wallet for provider. Enqueuing.',
        name: 'BackgroundSms');
    await _enqueueBackgroundFailure(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      subscriptionId: subscriptionId,
      providerName: providerName,
      error: 'Wallet not found',
    );
    return false;
  }

  return await _processAndSaveBackgroundTransaction(
    sender: sender,
    body: body,
    smsReceivedAt: smsReceivedAt,
    wallet: wallet,
    subscriptionId: subscriptionId,
  );
}

Future<void> _initializeDependenciesIfNeeded() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Initialize Hive and open retry box in background isolate
  await Hive.initFlutter();
  if (!Hive.isBoxOpen('pending_sms_retry_queue')) {
    await Hive.openBox<String>('pending_sms_retry_queue');
  }
}

Future<WalletEntity?> _fetchWalletForProvider({
  required String uid,
  required String providerName,
  required int? subscriptionId,
}) async {
  final firestore = FirebaseFirestore.instance;
  final walletsQuery = await firestore
      .collection('wallets')
      .where('ownerUid', isEqualTo: uid)
      .where('provider', isEqualTo: providerName)
      .get();

  if (walletsQuery.docs.isEmpty) return null;

  final matchingWallets = walletsQuery.docs
      .map((doc) => WalletDto.fromFirestore(doc).toEntity())
      .toList();

  final matchResult = SmsWalletMatcher.resolve(
    wallets: matchingWallets,
    subscriptionId: subscriptionId,
  );

  if (matchResult.needsSubscriptionMapping && subscriptionId != null) {
    await firestore.collection('wallets').doc(matchResult.wallet.id).update({
      'subscriptionId': subscriptionId,
    });
  }

  return matchResult.wallet;
}

Future<bool> _processAndSaveBackgroundTransaction({
  required String sender,
  required String body,
  required DateTime smsReceivedAt,
  required WalletEntity wallet,
  required int? subscriptionId,
}) async {
  final transaction = SmsParsingService.parse(
    sender: sender,
    message: body,
    smsReceivedAt: smsReceivedAt,
    walletId: wallet.id,
    walletOwnerUid: wallet.ownerUid,
    walletPhoneNumber: wallet.phoneNumber,
  );

  if (transaction == null) {
    log('Ignoring: failed to parse.', name: 'BackgroundSms');
    return true; // Success (ignored)
  }

  try {
    await _saveBackgroundTransaction(transaction);
    return true;
  } catch (e) {
    await _enqueueBackgroundFailure(
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

Future<void> _saveBackgroundTransaction(TransactionEntity transaction) async {
  final remoteDataSource = WalletTransactionRemoteDataSourceImpl(
    support: TransactionFirestoreSupport(
      firestore: FirebaseFirestore.instance,
      metaCache: WalletMetaCache(),
    ),
  );
  await remoteDataSource.saveTransaction(transaction);
  log('Background successful: ${transaction.id}', name: 'BackgroundSms');
}

Future<void> _sweepRetryQueue() async {
  final box = Hive.box<String>('pending_sms_retry_queue');
  if (box.isEmpty) return;

  final retryService = PendingSmsRetryService(box: box);
  await retryService.retryPending(
    processItem: (item) async {
      try {
        String? providerName = item.providerName;
        if (providerName == null || providerName.isEmpty) {
          final parser = SmsParserRegistry.resolve(item.sender);
          providerName = parser?.provider.toValue;
        }

        if (providerName == null) return true; // Can't process, but ignore (unrecognized)

        return await _processCore(
          sender: item.sender,
          body: item.body,
          smsReceivedAt: item.smsReceivedAt,
          providerName: providerName,
          subscriptionId: item.subscriptionId,
        );
      } catch (e) {
        log('Background retry failed for ${item.id}: $e', name: 'BackgroundSms');
        return false;
      }
    },
  );
}

Future<void> _enqueueBackgroundFailure({
  required String sender,
  required String body,
  required DateTime smsReceivedAt,
  required int? subscriptionId,
  String? walletId,
  String? providerName,
  required String error,
}) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final box = Hive.box<String>('pending_sms_retry_queue');

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
    userUid: currentUser.uid,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    subscriptionId: subscriptionId,
    walletId: walletId,
    providerName: providerName,
    lastError: error,
  );

  // Manual implementation of enqueue logic since we are in background isolate
  // and might not want to instantiate the whole service if not needed,
  // although we could.
  final existingJson = box.get(id);
  if (existingJson != null) {
    try {
      final existingItem = PendingSmsRetryItem.fromJson(
        jsonDecode(existingJson) as Map<String, dynamic>,
      );
      final updatedItem = existingItem.copyWith(
        lastError: error,
        retryCount: existingItem.retryCount + 1,
        updatedAt: DateTime.now(),
      );
      await box.put(id, jsonEncode(updatedItem.toJson()));
      return;
    } catch (_) {}
  }

  await box.put(id, jsonEncode(item.toJson()));
}
