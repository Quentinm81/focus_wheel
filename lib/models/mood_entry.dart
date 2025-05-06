// ignore_for_file: file_names
import 'package:hive/hive.dart';
part 'mood_entry.g.dart';

@HiveType(typeId: 3)
enum MoodLevel {
  @HiveField(0)
  verySad,
  @HiveField(1)
  sad,
  @HiveField(2)
  neutral,
  @HiveField(3)
  happy,
  @HiveField(4)
  veryHappy,
}

@HiveType(typeId: 4)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final MoodLevel mood;
  @HiveField(3)
  final String? note;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
  });

  factory MoodEntry.empty() => MoodEntry(
    id: '',
    date: DateTime(1970),
    mood: MoodLevel.neutral,
    note: '',
  );
}
