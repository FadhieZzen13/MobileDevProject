// Smoke test: the app builds and the splash screen shows the app title.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fsktm_nav/main.dart';
import 'package:fsktm_nav/theme/theme_provider.dart';

void main() {
  testWidgets('Splash screen shows the app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const FsktmNavApp(),
      ),
    );

    // The splash screen renders the app title immediately.
    expect(find.textContaining('FSKTM Navigation'), findsOneWidget);

    // Drain the splash auto-navigate timer so the test tears down cleanly.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
