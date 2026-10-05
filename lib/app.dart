import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_product/wallet_product.dart';
import 'package:mahafez_app/generated/l10n.dart';

import 'core/providers/sms_providers.dart';
import 'core/router/app_router.dart';
import 'features/settings/presentation/providers/app_preferences_controller.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep SMS listeners and background sync services alive
    ref.watch(smsTransactionListenerProvider);

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final fontScale = ref.watch(appTextScaleProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        theme: MahafezTheme.light(),
        darkTheme: MahafezTheme.dark(),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(fontScale)),
            child: child ?? const SizedBox.shrink(),
          );
        },
        localizationsDelegates: const [
          S.delegate,
          ...WalletLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
        onGenerateTitle: (context) => S.of(context).appName,
      ),
    );
  }
}
