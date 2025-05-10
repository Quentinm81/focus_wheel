import 'package:flutter/material.dart';
import 'package:focus_wheel/ui/localization/app_localizations.dart';

class FooterNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const FooterNav(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<FooterNav> createState() => _FooterNavState();
}

class _FooterNavState extends State<FooterNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.translate('agendaTitle')),
        BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: AppLocalizations.of(context)!.translate('tasksTitle')),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: AppLocalizations.of(context)!.translate('remindersTitle')),
        BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: AppLocalizations.of(context)!.translate('moodJournalTitle')),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.translate('statisticsTitle')),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppLocalizations.of(context)!.translate('settingsTitle')),
      ],
    );
  }
}
