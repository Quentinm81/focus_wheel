import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/reminder.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/reminder_creation_dialog.dart';
import '../../widgets/reminders_list.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB74D),
        title: const Text('Reminders', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const RemindersList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB74D),
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => const ReminderCreationDialog(),
          );
          if (result != null &&
              result['text'] != null &&
              result['scheduledAt'] != null) {
            final reminder = Reminder(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: result['text'],
              scheduledAt: result['scheduledAt'],
              recurring: result['recurring'] ?? false,
              recurrenceRule: result['recurrenceRule'],
            );
            ref.read(remindersProvider.notifier).addReminder(reminder);
            await ref.read(notificationServiceProvider).scheduleReminder(
                  id: reminder.id.hashCode,
                  title: 'Rappel',
                  body: reminder.text,
                  scheduledAt: reminder.scheduledAt,
                  recurring: reminder.recurring,
                  recurrenceRule: reminder.recurrenceRule,
                );
          }
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
