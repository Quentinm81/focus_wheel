import 'package:flutter/material.dart';

class FooterNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const FooterNav({super.key, required this.selectedIndex, required this.onItemTapped});

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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Tâches'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Rappels'),
        BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Humeur'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
      ],
    );
  }
}
