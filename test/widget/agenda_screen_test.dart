import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/screens/agenda_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await setupTestHive();
    setupTestSecureStorage();
  });

  tearDownAll(() async {
    await cleanupTestHive();
  });

  testWidgets('AgendaScreen renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AgendaScreen()),
      ),
    );
    // As the title is now fetched from AppLocalizations, we test for a generic widget presence
    // instead of a hardcoded string.
    expect(find.byType(AppBar), findsOneWidget);
  });
}
