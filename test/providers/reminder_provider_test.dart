import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';
import '../helpers/fake_box.dart';

import 'package:focus_wheel/providers/reminder_provider.dart';

import 'package:focus_wheel/models/reminder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('RemindersNotifier', () {
    setUpAll(() => setupTestDependencies());
    late FakeBox<Reminder> box;
    late RemindersNotifier notifier;
    

    setUp(() {
      box = FakeBox<Reminder>();



      notifier = RemindersNotifier(box);
    });

    test('initial state is box.values', () {
      expect(notifier.state, []);
    });

    test('addReminder adds and updates state', () async {
      final reminder = Reminder(
        id: 'id1',
        text: 'Test',
        scheduledAt: DateTime.now(),
        recurring: false,
        recurrenceRule: null,
      );


      notifier.addReminder(reminder);

      expect(notifier.state, [reminder]);
    });

    test('deleteReminder deletes and updates state', () async {



      notifier.deleteReminder('id1');

      expect(notifier.state, []);
    });
  });
}
