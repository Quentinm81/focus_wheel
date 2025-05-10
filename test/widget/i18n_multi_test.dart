import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/localization/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations loads and translates (es)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
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
    expect(find.text('Mi Agenda'), findsOneWidget);
  });

  testWidgets('AppLocalizations loads and translates (it)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
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
    expect(find.text('La mia Agenda'), findsOneWidget);
  });

  testWidgets('AppLocalizations loads and translates (pt)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt'),
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
    expect(find.text('Minha Agenda'), findsOneWidget);
  });
}
