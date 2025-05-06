// ignore_for_file: file_names
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'reminder.g.dart';

// NOTE: Le warning 'must_be_immutable' est lié à HiveObjectMixin qui contient des champs non-final pour la gestion interne Hive.
// Ce comportement est attendu et ne peut pas être corrigé sans modifier Hive lui-même.
@immutable
@HiveType(typeId: 4)
class Reminder extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final DateTime scheduledAt;
  @HiveField(3)
  final bool recurring;
  @HiveField(4)
  final String? recurrenceRule;

  Reminder({
    required this.id,
    required this.text,
    required this.scheduledAt,
    this.recurring = false,
    this.recurrenceRule,
  });

  @override
  List<Object?> get props => [id, text, scheduledAt, recurring, recurrenceRule];
}
