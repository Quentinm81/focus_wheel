import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reminder_provider.dart';
import 'reminder_creation_dialog.dart';

class RemindersList extends ConsumerWidget {
  const RemindersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);
    if (reminders.isEmpty) {
      return const Center(child: Text('No reminders yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: reminders.length,
      itemBuilder: (context, i) {
        final reminder = reminders[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: Colors.orange[50],
          child: ListTile(
            title: Text(reminder.text),
            subtitle: Text(_formatDate(reminder.scheduledAt)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => ref.read(remindersProvider.notifier).deleteReminder(reminder.id),
              tooltip: 'Delete',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ReminderCreationDialog(initialReminder: reminder),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
