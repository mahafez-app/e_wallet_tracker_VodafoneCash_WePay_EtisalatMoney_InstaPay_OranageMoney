import 'dart:developer';
import 'dart:ui';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../../features/transactions/data/datasources/transaction_firestore_support.dart';
import '../../features/transactions/data/datasources/wallet_transaction_remote_data_source.dart';
import '../cache/wallet_meta_cache.dart';
import '../../firebase_options.dart';
import '../data/models/wallet_dto.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/entities/wallet_entity.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_message_extension.dart';
import '../utils/sms/sms_parsing_service.dart';
import '../utils/sms/sms_wallet_matcher.dart';

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

  await _initializeFirebaseIfNeeded();

  await _handleBackgroundSmsForUser(
    sender: sender,
    body: body,
    smsReceivedAt: message.receivedAt,
    providerName: parser.provider.toValue,
    subscriptionId: message.subscriptionId,
  );
}

Future<void> _handleBackgroundSmsForUser({
  required String sender,
  required String body,
  required DateTime smsReceivedAt,
  required String providerName,
  required int? subscriptionId,
}) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('Ignoring: User not logged in.', name: 'BackgroundSms');
    return;
  }

  final wallet = await _fetchWalletForProvider(
    uid: currentUser.uid,
    providerName: providerName,
    subscriptionId: subscriptionId,
  );

  if (wallet == null) {
    log('Ignoring: No matching wallet for provider.', name: 'BackgroundSms');
    return;
  }

  await _processAndSaveBackgroundTransaction(
    sender: sender,
    body: body,
    smsReceivedAt: smsReceivedAt,
    wallet: wallet,
  );
}

Future<void> _initializeFirebaseIfNeeded() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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

Future<void> _processAndSaveBackgroundTransaction({
  required String sender,
  required String body,
  required DateTime smsReceivedAt,
  required WalletEntity wallet,
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
    return;
  }

  await _saveBackgroundTransaction(transaction);
}

Future<void> _saveBackgroundTransaction(TransactionEntity transaction) async {
  final remoteDataSource = WalletTransactionRemoteDataSourceImpl(
    support: TransactionFirestoreSupport(
      firestore: FirebaseFirestore.instance,
      metaCache: WalletMetaCache(),
    ),
  );
  try {
    await remoteDataSource.saveTransaction(transaction);
    log('Background successful: ${transaction.id}', name: 'BackgroundSms');
  } catch (e, st) {
    log('Background failure: $e', stackTrace: st, name: 'BackgroundSms');
  }
}
