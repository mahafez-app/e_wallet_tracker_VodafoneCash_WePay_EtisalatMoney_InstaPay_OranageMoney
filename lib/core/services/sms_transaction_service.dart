import 'dart:developer';
import 'dart:ui';

import 'package:another_telephony/telephony.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_tracker/core/domain/entities/transaction_entity.dart';
import 'package:wallet_tracker/firebase_options.dart';

import '../../features/transactions/data/datasources/transaction_remote_data_source.dart';
import '../../features/transactions/domain/usecases/save_transaction_usecase.dart';
import '../data/models/wallet_dto.dart';
import '../domain/entities/wallet_entity.dart';
import '../utils/sms/registry/sms_parser_registry.dart';
import '../utils/sms/sms_parsing_service.dart';

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
    // We register the listener even if wallets are empty to ensure background
    // handles are set with the native side. This prevents NullPointerExceptions
    // in another_telephony when an SMS arrives while the app is killed.
    Telephony.instance.listenIncomingSms(
      onNewMessage: _handleForegroundMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    log('SMS listener active (Wallets: ${_wallets.length})', name: _tag);
  }

  void stopListening() {
    // another_telephony does not expose an explicit unsubscribe API.
    // Riverpod disposes this service instance; the next startListening call
    // on a rebuilt provider re-registers with fresh wallet data.
    log('SMS listener disposed.', name: _tag);
  }

  void _handleForegroundMessage(SmsMessage message) {
    _logSmsDetails(message, isBackground: false);

    final sender = message.address;
    final body = message.body;

    if (sender == null || body == null) return;

    final smsReceivedAt = message.date != null
        ? DateTime.fromMillisecondsSinceEpoch(message.date!)
        : DateTime.now();

    _processMessage(sender: sender, body: body, smsReceivedAt: smsReceivedAt);
  }

  void _processMessage({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) {
    final wallet = _getWalletForSender(sender);
    if (wallet == null) return;

    final transaction = SmsParsingService.parse(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
      walletId: wallet.id,
      walletPhoneNumber: wallet.phoneNumber,
    );

    if (transaction == null) {
      log(
        'SMS from $sender did not match any transaction pattern.',
        name: _tag,
      );
      return;
    }

    _saveTransaction(transaction);
  }

  WalletEntity? _getWalletForSender(String sender) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return null;

    final matchingWallets = _wallets.where(
      (w) => w.provider == parser.provider,
    );
    if (matchingWallets.isEmpty) {
      log('No wallet registered for provider ${parser.provider}.', name: _tag);
      return null;
    }
    return matchingWallets.first;
  }

  void _saveTransaction(TransactionEntity transaction) {
    _saveTransactionUseCase(transaction).then((result) {
      result.fold(
        (failure) => log(
          'Failed to save transaction: ${failure.runtimeType}',
          name: _tag,
        ),
        (_) => log(
          'Transaction saved: ${transaction.id} (${transaction.type.name} '
          '${transaction.amount} EGP)',
          name: _tag,
        ),
      );
    });
  }
}

/// Top-level background handler — must be a top-level or static function.
/// Required by [Telephony.listenIncomingSms] for background processing.
/// Annotated with [pragma] so the AOT compiler keeps it in release builds.
///
/// In background mode (app killed), Riverpod is unavailable. We manually
/// initialize Firebase, fetch wallets for the current user, parse, and save.
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  _logSmsDetails(message, isBackground: true);

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
    dateValue: message.date,
    providerName: parser.provider.toValue,
  );
}

Future<void> _handleBackgroundSmsForUser({
  required String sender,
  required String body,
  required int? dateValue,
  required String providerName,
}) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    log('Ignoring: User not logged in.', name: 'BackgroundSms');
    return;
  }

  final wallet = await _fetchWalletForProvider(
    uid: currentUser.uid,
    providerName: providerName,
  );

  if (wallet == null) {
    log('Ignoring: No matching wallet for provider.', name: 'BackgroundSms');
    return;
  }

  await _processAndSaveBackgroundTransaction(
    sender: sender,
    body: body,
    dateValue: dateValue,
    wallet: wallet,
  );
}

Future<void> _initializeFirebaseIfNeeded() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure plugins are registered in the background isolate.
  // This is critical for background processing to find registered plugins.
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
}) async {
  final firestore = FirebaseFirestore.instance;
  final walletsQuery = await firestore
      .collection('wallets')
      .where('ownerUid', isEqualTo: uid)
      .where('provider', isEqualTo: providerName)
      .limit(1)
      .get();

  if (walletsQuery.docs.isEmpty) return null;

  return WalletDto.fromFirestore(walletsQuery.docs.first).toEntity();
}

Future<void> _processAndSaveBackgroundTransaction({
  required String sender,
  required String body,
  required int? dateValue,
  required WalletEntity wallet,
}) async {
  final transaction = SmsParsingService.parse(
    sender: sender,
    message: body,
    smsReceivedAt: _parseDate(dateValue),
    walletId: wallet.id,
    walletPhoneNumber: wallet.phoneNumber,
  );

  if (transaction == null) {
    log('Ignoring: failed to parse.', name: 'BackgroundSms');
    return;
  }

  await _saveBackgroundTransaction(transaction);
}

DateTime _parseDate(int? dateValue) {
  return dateValue != null
      ? DateTime.fromMillisecondsSinceEpoch(dateValue)
      : DateTime.now();
}

Future<void> _saveBackgroundTransaction(TransactionEntity transaction) async {
  final remoteDataSource = TransactionRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
  try {
    await remoteDataSource.saveTransaction(transaction);
    log('Background successful: ${transaction.id}', name: 'BackgroundSms');
  } catch (e, st) {
    log('Background failure: $e', stackTrace: st, name: 'BackgroundSms');
  }
}

void _logSmsDetails(SmsMessage message, {required bool isBackground}) {
  final prefix = isBackground ? 'BackgroundSms' : 'ForegroundSms';
  log("-------", name: prefix);
  log("Message Address: ${message.address}", name: prefix);
  log("Message body: ${message.body}", name: prefix);
  log("Message date: ${message.date}", name: prefix);
  log("Message dateSent: ${message.dateSent}", name: prefix);
  log("Message read: ${message.read}", name: prefix);
  log("Message seen: ${message.seen}", name: prefix);
  log("Message status: ${message.status}", name: prefix);
  log("Message subject: ${message.subject}", name: prefix);
  log("Message subscriptionId: ${message.subscriptionId}", name: prefix);
  log("Message threadId: ${message.threadId}", name: prefix);
  log("Message type: ${message.type}", name: prefix);
  log(
    "Message serviceCenterAddress: ${message.serviceCenterAddress}",
    name: prefix,
  );
  log("-------", name: prefix);
}
