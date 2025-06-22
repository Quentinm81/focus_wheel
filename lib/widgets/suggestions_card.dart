import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_wheel/generated/app_localizations.dart';
import '../providers/suggestions_provider.dart';

class SuggestionsCard extends ConsumerWidget {
  const SuggestionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(suggestionsProvider);
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      color: Colors.teal[50],
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.smartSuggestions,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal)),
            const SizedBox(height: 8),
            ...suggestions.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(_iconForType(s.type), color: Colors.teal, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(s.text,
                              style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'timer':
        return Icons.timer;
      case 'task':
        return Icons.check_box_outlined;
      case 'reminder':
        return Icons.alarm;
      case 'mood':
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.lightbulb_outline;
    }
  }
}
