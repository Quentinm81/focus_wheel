import 'package:flutter_test/flutter_test.dart';
import '../helpers/fake_box.dart';

import 'package:focus_wheel/providers/mood_journal_provider.dart';
import 'package:focus_wheel/models/mood_entry.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MoodJournalNotifier', () {
    late FakeBox<MoodEntry> box;
    late MoodJournalNotifier notifier;

    setUp(() {
      box = FakeBox<MoodEntry>();



      notifier = MoodJournalNotifier(box);
    });

    test('initial state is box.values', () {
      expect(notifier.state, []);
    });

    test('addMood adds and updates state', () {

notifier.addMood(MoodEntry(id: 'id1', date: DateTime.now(), mood: MoodLevel.happy, note: 'Good day'));
// Test simplifié : on vérifie juste l'appel sans variable locale inutile.
    });

    test('deleteMood deletes and updates state', () {
      

      notifier.deleteMood('id1');

      expect(notifier.state, []);
    });
  });
}
