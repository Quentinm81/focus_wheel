import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/reminder.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/notification_provider.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);
    final notificationService = ref.read(notificationServiceProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final TextEditingController controller = TextEditingController();
    DateTime? selectedDate;

    void addReminderDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Ajouter un rappel'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Texte du rappel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        selectedDate = DateTime(
                          picked.year, picked.month, picked.day, time.hour, time.minute);
                      }
                    }
                  },
                  child: const Text('Choisir date et heure'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty && selectedDate != null) {
                    final reminder = Reminder(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      text: controller.text,
                      scheduledAt: selectedDate!,
                    );
                    ref.read(remindersProvider.notifier).addReminder(reminder);
                    await notificationService.scheduleReminder(
                      id: reminder.id.hashCode,
                      title: 'Rappel',
                      body: reminder.text,
                      scheduledAt: reminder.scheduledAt,
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Rappels',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addReminderDialog,
        child: const Icon(Icons.add),
      ),
      body: reminders.isEmpty
          ? Center(child: Text('Aucun rappel', style: TextStyle(fontSize: size.width * 0.05)))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (ctx, idx) {
                final reminder = reminders[idx];
                return ListTile(
                  title: Text(reminder.text),
                  subtitle: Text(reminder.scheduledAt.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      ref.read(remindersProvider.notifier).deleteReminder(reminder.id);
                      await notificationService.cancelReminder(reminder.id.hashCode);
                    },
                  ),
                );
              },
            ),
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }
}

