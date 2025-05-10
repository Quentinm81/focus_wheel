import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';

final reminderBoxProvider =
    Provider<Box<Reminder>>((ref) => Hive.box<Reminder>('reminders'));

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>((ref) {
  final box = ref.watch(reminderBoxProvider);
  return RemindersNotifier(box);
});

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  final Box<Reminder> box;
  final NotificationService notificationService = NotificationService();
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
    await notificationService.cancelReminder(id.hashCode);
    box.delete(id);
    state = box.values.toList();
  }
}
