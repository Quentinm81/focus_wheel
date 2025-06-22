import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class MotivationalPhrase {
  final String text;
  final List<String> tags;

  MotivationalPhrase({required this.text, required this.tags});

  factory MotivationalPhrase.fromJson(Map<String, dynamic> json) {
    return MotivationalPhrase(
      text: json['text'] as String? ?? 'Unknown', // Gestion des valeurs nulles
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class MotivationalEngine {
  static List<MotivationalPhrase> _phrases = [];
  static bool _loaded = false;

  static Future<void> loadPhrases() async {
    if (_loaded) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/json/motivational_phrases.json');
      final List<dynamic> jsonList = json.decode(jsonStr);
      _phrases = jsonList.map((e) => MotivationalPhrase.fromJson(e)).toList();
      _loaded = true;
    } catch (e) {
      // TODO: remove or handle debug output instead of print ('Error loading phrases: $e');
      _phrases = [];
    }
  }

  static Future<String> getPhrase({List<String>? tags}) async {
    await loadPhrases();
    if (_phrases.isEmpty) return 'No phrases available';
    final filtered = tags == null || tags.isEmpty
        ? _phrases
        : _phrases.where((p) => p.tags.any((t) => tags.contains(t))).toList();
    if (filtered.isEmpty) {
      // Si aucun élément ne correspond, retourne une phrase aléatoire
      return _phrases[Random().nextInt(_phrases.length)].text;
    }
    return filtered[Random().nextInt(filtered.length)].text;
  }
}