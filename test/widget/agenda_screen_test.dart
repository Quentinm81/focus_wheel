import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/screens/agenda_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('AgendaScreen renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AgendaScreen())));
    expect(find.text('Mon Agenda'), findsOneWidget);
  });
}
