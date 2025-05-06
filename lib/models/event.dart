// ignore_for_file: file_names
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'event.g.dart';

// NOTE: Le warning 'must_be_immutable' est lié à HiveObjectMixin qui contient des champs non-final pour la gestion interne Hive.
// Ce comportement est attendu et ne peut pas être corrigé sans modifier Hive lui-même.
@immutable
@HiveType(typeId: 0)
class Event extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;
  @HiveField(4)
  final int colorHex;
  @HiveField(5)
  final String? notes;

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.colorHex,
    this.notes,
  });

  @override
  List<Object?> get props => [id, title, startTime, endTime, colorHex, notes];
}
