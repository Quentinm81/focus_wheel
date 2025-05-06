import 'package:flutter/material.dart';
import '../widgets/footer_nav.dart';
import '../ui/screens/agenda_screen.dart';
import '../ui/screens/tasks_screen.dart';
import '../ui/screens/reminders_screen.dart';
import '../ui/screens/mood_journal_screen.dart';
import '../ui/screens/stats_screen.dart';
import '../ui/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const AgendaScreen(),
    const TasksScreen(),
    const RemindersScreen(),
    const MoodJournalScreen(),
    const StatsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: FooterNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
