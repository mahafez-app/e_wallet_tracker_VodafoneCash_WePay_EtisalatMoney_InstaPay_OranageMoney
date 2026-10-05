import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/di/app_initializer.dart';
import 'core/error/result.dart';
import 'core/providers/cache_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_providers.dart';
import 'features/splash/presentation/screens/startup_fallback_screen.dart';
import 'generated/l10n.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key, required this.initializationResult});

  final Result<AppBootstrapDependencies> initializationResult;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Result<AppBootstrapDependencies> _initializationResult;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _initializationResult = widget.initializationResult;
  }

  Future<void> _retryInitialization() async {
    if (_isRetrying) return;

    setState(() => _isRetrying = true);

    final initializationResult = await initializeApp();
    if (!mounted) return;

    setState(() {
      _initializationResult = initializationResult;
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_initializationResult) {
      Success<AppBootstrapDependencies>(:final data) => ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(data.sharedPreferences),
          txFirstPageCacheBoxProvider.overrideWithValue(
            data.txFirstPageCacheBox,
          ),
          pendingSmsRetryBoxProvider.overrideWithValue(data.pendingSmsRetryBox),
          deletedTransactionTombstonesBoxProvider.overrideWithValue(
            data.deletedTransactionTombstonesBox,
          ),
        ],
        child: const App(),
      ),
      FailureResult<AppBootstrapDependencies>() => StartupFallbackApp(
        isRetrying: _isRetrying,
        onRetry: _retryInitialization,
      ),
    };
  }
}

class StartupFallbackApp extends StatelessWidget {
  const StartupFallbackApp({
    super.key,
    required this.isRetrying,
    required this.onRetry,
  });

  final bool isRetrying;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: StartupFallbackScreen(isRetrying: isRetrying, onRetry: onRetry),
      ),
    );
  }
}
