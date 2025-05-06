import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/reminder.dart';

final reminderBoxProvider = Provider<Box<Reminder>>((ref) => Hive.box<Reminder>('reminders'));

final remindersProvider = StateNotifierProvider<RemindersNotifier, List<Reminder>>((ref) {
  final box = ref.watch(reminderBoxProvider);
  return RemindersNotifier(box);
});

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final Box<Reminder> box;
  // NotificationService /* notificationService */;
  RemindersNotifier(this.box) : super(box.values.toList());

  void addReminder(Reminder reminder) {
    box.put(reminder.id, reminder);
    state = box.values.toList();
  }

  void updateReminder(Reminder reminder) {
    box.put(reminder.id, reminder);
    state = box.values.toList();
  }

  void deleteReminder(String id) async {
    final reminder = box.get(id);
    if (reminder != null) {
      // TODO: Implémenter l'annulation de la notification pour le rappel
    }
    box.delete(id);
    state = box.values.toList();
  }
}
