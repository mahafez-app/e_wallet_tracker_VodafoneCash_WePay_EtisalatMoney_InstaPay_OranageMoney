// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_tracker/core/widgets/app.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();

    // Verify that splash branding is shown
    expect(find.text('محافظ'), findsOneWidget);
    expect(find.text('MAHAFEZ'), findsOneWidget);

    // Verify that splash transitions to home screen
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump();
    expect(find.text('Home Screen - To be implemented'), findsOneWidget);
  });
}
