import 'package:flutter_test/flutter_test.dart';

import 'fake_box.dart';
import 'package:focus_wheel/providers/timer_session_provider.dart';
import 'package:focus_wheel/models/timer_session.dart';



void main() {
  group('TimerSessionsNotifier', () {
    test('initial state is box.values', () {
      final box = FakeBox<TimerSession>([]);
      final notifier = TimerSessionsNotifier(box);
      expect(notifier.state, []);
    });

    test('addSession adds a session and updates state', () {
      final session = TimerSession(
        id: 'id1',
        durationMinutes: 25,
        startedAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      final box = FakeBox<TimerSession>();
      final notifier = TimerSessionsNotifier(box);
      notifier.addSession(session);
      expect(notifier.state, [session]);
    });

    test('totalSessions returns correct count', () {
      final session = TimerSession(
        id: 'id1',
        durationMinutes: 25,
        startedAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      final box2 = FakeBox<TimerSession>([session]);
      final notifier2 = TimerSessionsNotifier(box2);
      expect(notifier2.totalSessions, 1);
    });

    test('totalMinutes returns correct sum', () {
      final session1 = TimerSession(
        id: 'id1',
        durationMinutes: 25,
        startedAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      final session2 = TimerSession(
        id: 'id2',
        durationMinutes: 10,
        startedAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
      final box3 = FakeBox<TimerSession>([session1, session2]);
      final notifier3 = TimerSessionsNotifier(box3);
      expect(notifier3.totalMinutes, 35);
    });
  });
}
