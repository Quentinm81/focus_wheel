// ignore_for_file: file_names
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
part 'mood.g.dart';

@HiveType(typeId: 4)
enum MoodStatus {
  @HiveField(0)
  happy,
  @HiveField(1)
  neutral,
  @HiveField(2)
  sad,
  @HiveField(3)
  energetic,
  @HiveField(4)
  anxious,
  @HiveField(5)
  calm,
}


// NOTE: Le warning 'must_be_immutable' est lié à HiveObjectMixin qui contient des champs non-final pour la gestion interne Hive.
// Ce comportement est attendu et ne peut pas être corrigé sans modifier Hive lui-même.
@immutable
@HiveType(typeId: 1)
class MoodEntry extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final MoodStatus status;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String? note;

  MoodEntry({
    required this.id,
    required this.status,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, status, date, note];
}
