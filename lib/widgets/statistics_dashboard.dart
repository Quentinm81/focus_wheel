import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_session_provider.dart';
import '../providers/task_provider.dart';
import '../providers/reminder_provider.dart';
import '../providers/mood_journal_provider.dart';
import 'package:focus_wheel/ui/localization/app_localizations.dart';

class StatisticsDashboard extends ConsumerWidget {
  const StatisticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSessions = ref.watch(timerSessionsProvider);
    final tasks = ref.watch(tasksProvider);
    final reminders = ref.watch(remindersProvider);
    final moods = ref.watch(moodJournalProvider);
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));

    // Filter for last 7 days
    final sessionsWeek = timerSessions
        .where((s) => s.completedAt != null && s.completedAt!.isAfter(weekAgo))
        .toList();
    final tasksWeek = tasks.where((t) => t.createdAt.isAfter(weekAgo)).toList();
    final remindersWeek =
        reminders.where((r) => r.scheduledAt.isAfter(weekAgo)).toList();
    final moodsWeek = moods.where((m) => m.date.isAfter(weekAgo)).toList();

    final totalFocusMin =
        sessionsWeek.fold(0, (sum, s) => sum + s.durationMinutes);
    final tasksDone =
        tasksWeek.where((t) => t.status == TaskStatus.done).length;
    final remindersSet = remindersWeek.length;
    final avgMood = moodsWeek.isEmpty
        ? null
        : moodsWeek.map((m) => m.mood.index).reduce((a, b) => a + b) /
            moodsWeek.length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _StatCard(
          title: AppLocalizations.of(context)!.translate('totalTime'),
          value: '$totalFocusMin min',
          icon: Icons.timer,
          color: const Color(0xFF4DD0E1),
        ),
        _StatCard(
          title: AppLocalizations.of(context)!.translate('tasksCompleted'),
          value: '$tasksDone',
          icon: Icons.check_circle_outline,
          color: const Color(0xFFBA68C8),
        ),
        _StatCard(
          title: AppLocalizations.of(context)!.translate('remindersSet'),
          value: '$remindersSet',
          icon: Icons.alarm,
          color: const Color(0xFFFFB74D),
        ),
        _StatCard(
          title: AppLocalizations.of(context)!.translate('averageMood'),
          value: avgMood == null
              ? 'N/A'
              : AppLocalizations.of(context)!.translate(_moodLabel(avgMood)),
          icon: Icons.sentiment_satisfied_alt,
          color: const Color(0xFF64B5F6),
        ),
        const SizedBox(height: 24),
        Center(
            child: Text(
                AppLocalizations.of(context)!.translate('chartsComingSoon'),
                style: TextStyle(color: Colors.grey[600]))),
      ],
    );
  }

  String _moodLabel(double avgMood) {
    if (avgMood < 0.5) return 'verySad';
    if (avgMood < 1.5) return 'sad';
    if (avgMood < 2.5) return 'neutral';
    if (avgMood < 3.5) return 'happy';
    return 'veryHappy';
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withAlpha((0.12 * 255).toInt()),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha((0.28 * 255).toInt()),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: color)),
      ),
    );
  }
}
