import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/timer_session.dart';

final timerSessionBoxProvider = Provider<Box<TimerSession>>((ref) => Hive.box<TimerSession>('timer_sessions'));

final timerSessionsProvider = StateNotifierProvider<TimerSessionsNotifier, List<TimerSession>>((ref) {
  final box = ref.watch(timerSessionBoxProvider);
  return TimerSessionsNotifier(box);
});

class TimerSessionsNotifier extends StateNotifier<List<TimerSession>> {
  final Box<TimerSession> box;
  TimerSessionsNotifier(this.box) : super(box.values.toList());

  void addSession(TimerSession session) {
    box.put(session.id, session);
    state = box.values.toList();
  }

  int get totalSessions => state.length;
  int get totalMinutes => state.fold(0, (sum, s) => sum + s.durationMinutes);
}
