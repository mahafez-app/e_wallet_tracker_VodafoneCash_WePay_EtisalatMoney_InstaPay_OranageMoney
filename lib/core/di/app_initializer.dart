import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import '../utils/execute_and_handle_errors.dart';
import '../utils/extensions/failure_extension.dart';
import '../utils/extensions/localization_extension.dart';
import '../../firebase_options.dart';

/// Dependencies resolved during app startup and passed down via ProviderScope
/// overrides. Keeps initialization testable — no singletons accessed at
/// call-site.
final class AppBootstrapDependencies {
  const AppBootstrapDependencies({
    required this.sharedPreferences,
    required this.txFirstPageCacheBox,
    required this.pendingSmsRetryBox,
    required this.deletedTransactionTombstonesBox,
  });

  final SharedPreferences sharedPreferences;

  /// Opened Hive box used by [TransactionCacheLocalDataSourceImpl].
  /// Typed as [Box<String>] — raw JSON strings, no code generation required.
  final Box<String> txFirstPageCacheBox;

  /// Opened Hive box for pending SMS retry items.
  /// Typed as [Box<String>] — raw JSON strings of [PendingSmsRetryItem].
  final Box<String> pendingSmsRetryBox;

  /// Opened Hive box for local deleted-transaction tombstones.
  /// Typed as [Box<String>] — raw JSON strings keyed by transaction id.
  final Box<String> deletedTransactionTombstonesBox;
}

Future<Result<AppBootstrapDependencies>> initializeApp() {
  return executeAndHandleErrors(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      MahafezErrorView.errorHandler = (context, error) =>
          error is Failure
              ? error.toLocalizedString(context)
              : context.l10n.errorUnknown;
      MahafezErrorView.retryLabelHandler =
          (context) => context.l10n.startupFallbackRetryAction;
      MahafezSnackbar.failureHandler = (context, failure, duration) {
        final message = failure is Failure
            ? failure.toLocalizedString(context)
            : failure.toString();
        MahafezSnackbar.show(
          context,
          message: message,
          type: .error,
          duration: duration,
        );
      };

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Phase 1 — enable Firestore disk persistence before any read/write.
      // All .snapshots() calls now emit a cached document instantly before the
      // server response arrives. No-op if persistence was already enabled from
      // a previous run.
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Phase 4 — open the Hive box for the tx first-page cache.
      await Hive.initFlutter();
      final txFirstPageCacheBox = await Hive.openBox<String>(
        'tx_first_page_cache',
      );

      final pendingSmsRetryBox = await Hive.openBox<String>(
        'pending_sms_retry_queue',
      );
      final deletedTransactionTombstonesBox = await Hive.openBox<String>(
        'deleted_transaction_tombstones',
      );

      final sharedPreferences = await SharedPreferences.getInstance();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await sharedPreferences.setString(
          'last_known_user_uid',
          currentUser.uid,
        );
      }

      return AppBootstrapDependencies(
        sharedPreferences: sharedPreferences,
        txFirstPageCacheBox: txFirstPageCacheBox,
        pendingSmsRetryBox: pendingSmsRetryBox,
        deletedTransactionTombstonesBox: deletedTransactionTombstonesBox,
      );
    },
    tag: 'initializeApp',
    logName: 'Bootstrap',
  );
}
