import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/localization/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations loads and translates (en)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: [AppLocalizations.delegate],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('it'),
          Locale('pt')
        ],
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Text(l10n.translate('agendaTitle'));
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My Agenda'), findsOneWidget);
  });
}
