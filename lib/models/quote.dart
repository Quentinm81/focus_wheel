// ignore_for_file: file_names
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
part 'quote.g.dart';

@HiveType(typeId: 7)
enum QuoteCategory {
  @HiveField(0)
  energetic,
  @HiveField(1)
  gentle,
  @HiveField(2)
  fun,
  @HiveField(3)
  calm,
  @HiveField(4)
  scientific,
  @HiveField(5)
  cinematic,
}


// NOTE: Le warning 'must_be_immutable' est lié à HiveObjectMixin qui contient des champs non-final pour la gestion interne Hive.
// Ce comportement est attendu et ne peut pas être corrigé sans modifier Hive lui-même.
@immutable
@HiveType(typeId: 3)
class MotivationalQuote extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final QuoteCategory category;

  MotivationalQuote({
    required this.id,
    required this.text,
    required this.category,
  });

  @override
  List<Object?> get props => [id, text, category];
}
