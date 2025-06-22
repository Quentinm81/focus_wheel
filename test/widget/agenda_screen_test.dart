import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/screens/agenda_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('AgendaScreen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AgendaScreen(),
        ),
      ),
    );
    expect(find.text('Mon Agenda'), findsOneWidget);
  });
}
