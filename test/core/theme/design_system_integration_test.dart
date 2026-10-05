import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

void main() {
  group('Design System Integration Tests in Wallet Tracker', () {
    testWidgets('MahafezTheme applies Cairo typography in light and dark mode', (tester) async {
      final lightTheme = MahafezTheme.light();
      final darkTheme = MahafezTheme.dark();

      expect(lightTheme.textTheme.bodyMedium?.fontFamily, 'Cairo');
      expect(darkTheme.textTheme.bodyMedium?.fontFamily, 'Cairo');
      expect(lightTheme.colorScheme.primary, MahafezColors.primary);
      expect(darkTheme.colorScheme.primary, MahafezColors.primaryFixedDim);
    });

    testWidgets('MahafezButton renders properly within ScreenUtilInit', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: MahafezTheme.light(),
            home: Scaffold(
              body: MahafezButton(
                label: 'حفظ المعاملة',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('حفظ المعاملة'), findsOneWidget);
      await tester.tap(find.text('حفظ المعاملة'));
      expect(pressed, isTrue);
    });

    testWidgets('MahafezTextField renders input field properly', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            theme: MahafezTheme.light(),
            home: Scaffold(
              body: MahafezTextField(
                label: 'اسم المحفظة',
                hintText: 'ادخل الاسم',
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(find.text('اسم المحفظة'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'محفظتي');
      expect(controller.text, 'محفظتي');
    });
  });
}
