import 'package:flutter/material.dart';
import '../widgets/statistics_dashboard.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4DD0E1),
        title: const Text('Weekly Statistics', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const StatisticsDashboard(),
    );
  }
}
