import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/app_initializer.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(SmsMessage message) async {
  // Log the message for debugging purposes even the app is killed
  log("-------");
  log('Received SMS ${message.toString()}');
  log("Message Address: ${message.address}");
  log("Message body: ${message.body}");
  log("Message date: ${message.date}");
  log("Message dateSent: ${message.dateSent}");
  log("Message read: ${message.read}");
  log("Message seen: ${message.seen}");
  log("Message status: ${message.status}");
  log("Message subject: ${message.subject}");
  log("Message subscriptionId: ${message.subscriptionId}");
  log("Message threadId: ${message.threadId}");
  log("Message type: ${message.type}");
  log("Message serviceCenterAddress: ${message.serviceCenterAddress}");
  log("-------");
}

void main() async {
  await initializeApp();
  Telephony.instance.listenIncomingSms(
    onNewMessage: (SmsMessage message) {
      // Handle message
    },
    onBackgroundMessage: backgroundMessageHandler,
  );
  runApp(const ProviderScope(child: App()));
}
