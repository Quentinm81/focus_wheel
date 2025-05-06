import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/mood_journal_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodJournalProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Simple bar chart des humeurs par jour
    final moodCounts = <String, int>{};
    for (final mood in moods) {
      final key = mood.mood.toString().split('.').last;
      moodCounts[key] = (moodCounts[key] ?? 0) + 1;
    }
    final spots = moodCounts.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: moods.isEmpty
          ? Center(child: Text('Aucune donnée', style: TextStyle(fontSize: size.width * 0.05)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (spots.map((e) => e.value).fold<int>(0, (p, v) => v > p ? v : p)).toDouble() + 1,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() < 0 || value.toInt() >= spots.length) return const SizedBox();
                          return Text(spots[value.toInt()].key);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(spots.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: spots[i].value.toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }
}

