import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_wheel/models/task.dart';
import 'package:focus_wheel/providers/timer_session_provider.dart';
import 'package:focus_wheel/providers/task_provider.dart';
import 'package:focus_wheel/providers/reminder_provider.dart';
import 'package:focus_wheel/providers/mood_journal_provider.dart';

class Suggestion {
  final String text;
  final String type;
  Suggestion(this.text, this.type);
}

final suggestionsProvider = Provider<List<Suggestion>>((ref) {
  final sessions = ref.watch(timerSessionsProvider);
  final tasks = ref.watch(tasksProvider);
  final reminders = ref.watch(remindersProvider);
  final moods = ref.watch(moodJournalProvider);
  final suggestions = <Suggestion>[];

  // Suggest a focus time based on most frequent session
  if (sessions.isNotEmpty) {
    final freq = <int, int>{};
    for (final s in sessions) {
      freq[s.durationMinutes] = (freq[s.durationMinutes] ?? 0) + 1;
    }
    final best = freq.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    suggestions.add(Suggestion('Try a $best min focus session today', 'timer'));
  }

  // Suggest overdue or recurring tasks
  final todoTasks = tasks.where((t) => t.status == TaskStatus.todo).toList();
  if (todoTasks.isNotEmpty) {
    suggestions.add(Suggestion('You have ${todoTasks.length} tasks to start', 'task'));
  }

  // Suggest reminders for today
  final now = DateTime.now();
  final todayReminders = reminders.where((r) => r.scheduledAt.year == now.year && r.scheduledAt.month == now.month && r.scheduledAt.day == now.day).toList();
  if (todayReminders.isNotEmpty) {
    suggestions.add(Suggestion('You have ${todayReminders.length} reminders for today', 'reminder'));
  }

  // Suggest mood check if not logged today
  final todayMood = moods.any((m) => m.date.year == now.year && m.date.month == now.month && m.date.day == now.day);
  if (!todayMood) {
    suggestions.add(Suggestion('Log your mood for today', 'mood'));
  }

  return suggestions;
});
