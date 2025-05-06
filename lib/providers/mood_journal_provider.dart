import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/mood_entry.dart';

final moodBoxProvider = Provider<Box<MoodEntry>>((ref) => Hive.box<MoodEntry>('mood_entries'));

final moodJournalProvider = StateNotifierProvider<MoodJournalNotifier, List<MoodEntry>>((ref) {
  final box = ref.watch(moodBoxProvider);
  return MoodJournalNotifier(box);
});

class MoodJournalNotifier extends StateNotifier<List<MoodEntry>> {
  final Box<MoodEntry> box;
  MoodJournalNotifier(this.box) : super(box.values.toList());

  void addMood(MoodEntry entry) {
    box.put(entry.id, entry);
    state = box.values.toList();
  }

  void updateMood(MoodEntry entry) {
    box.put(entry.id, entry);
    state = box.values.toList();
  }

  void deleteMood(String id) {
    box.delete(id);
    state = box.values.toList();
  }
}
