// ignore_for_file: file_names
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  todo,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  done,
}


// NOTE: Le warning 'must_be_immutable' est lié à HiveObjectMixin qui contient des champs non-final pour la gestion interne Hive.
// Ce comportement est attendu et ne peut pas être corrigé sans modifier Hive lui-même.
@immutable
@HiveType(typeId: 5)
class Task extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final TaskStatus status;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [id, title, status, createdAt, completedAt];
}
