import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sms_providers.dart';

/// Provides a stream of connectivity status changes.
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Listener that triggers SMS retry when connectivity is restored.
final connectivityRetryProvider = Provider<void>((ref) {
  final connectivity = ref.watch(connectivityProvider).value;
  if (connectivity == null) return;

  final isConnected = connectivity.any((result) =>
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet);

  if (isConnected) {
    final retryService = ref.read(pendingSmsRetryServiceProvider);
    final smsService = ref.read(smsTransactionServiceProvider);

    retryService.retryPending(
      processItem: (item) async {
        return await smsService.processSms(
          sender: item.sender,
          body: item.body,
          smsReceivedAt: item.smsReceivedAt,
          subscriptionId: item.subscriptionId,
        );
      },
    );
  }
});
