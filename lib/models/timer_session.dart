import 'package:hive/hive.dart';
part 'timer_session.g.dart';

@HiveType(typeId: 6)
class TimerSession extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int durationMinutes;
  @HiveField(2)
  final DateTime startedAt;
  @HiveField(3)
  final DateTime? completedAt;

  TimerSession({
    required this.id,
    required this.durationMinutes,
    required this.startedAt,
    this.completedAt,
  });


}
