import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import '../providers/mood_journal_provider.dart';
import '../services/motivational_engine.dart';

class MoodJournal extends ConsumerWidget {
  const MoodJournal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(moodJournalProvider);
    final today = DateTime.now();
    final todayEntry = entries.firstWhere(
      (e) => e.date.year == today.year && e.date.month == today.month && e.date.day == today.day,
      orElse: () => MoodEntry.empty(),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling today?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MoodLevel.values.map((mood) => _MoodIcon(
              mood: mood,
              selected: todayEntry.mood == mood,
              onTap: () {
                _showMoodDialog(context, ref, mood, todayEntry);
              },
            )).toList(),
          ),
          const SizedBox(height: 28),
          Text('Recent Entries', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text('No mood entries yet.'))
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, i) {
                      final e = entries[entries.length - 1 - i];
                      return Card(
                        color: Colors.blue[50],
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: ListTile(
                          leading: _MoodIcon(mood: e.mood, selected: false),
                          title: Text(_formatDate(e.date)),
                          subtitle: e.note != null && e.note!.isNotEmpty ? Text(e.note!) : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => ref.read(moodJournalProvider.notifier).deleteMood(e.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showMoodDialog(BuildContext context, WidgetRef ref, MoodLevel mood, MoodEntry? existing) {
    final noteController = TextEditingController(text: existing?.note ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Mood'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_moodLabel(mood), style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Add a note (optional)'),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF64B5F6)),
            onPressed: () async {
              final today = DateTime.now();
              final entry = MoodEntry(
                id: existing?.id ?? const Uuid().v4(),
                date: DateTime(today.year, today.month, today.day),
                mood: mood,
                note: noteController.text.trim(),
              );
              if (existing != null) {
                ref.read(moodJournalProvider.notifier).updateMood(entry);
              } else {
                ref.read(moodJournalProvider.notifier).addMood(entry);
              }
              Navigator.pop(context);
              final phrase = await MotivationalEngine.getPhrase(tags: ['mood', 'encouragement']);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(phrase),
                    backgroundColor: const Color(0xFF64B5F6),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _moodLabel(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.verySad:
        return 'Very Sad';
      case MoodLevel.sad:
        return 'Sad';
      case MoodLevel.neutral:
        return 'Neutral';
      case MoodLevel.happy:
        return 'Happy';
      case MoodLevel.veryHappy:
        return 'Very Happy';
    }
  }
}

class _MoodIcon extends StatelessWidget {
  final MoodLevel mood;
  final bool selected;
  final VoidCallback? onTap;
  const _MoodIcon({required this.mood, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (mood) {
      case MoodLevel.verySad:
        icon = Icons.sentiment_very_dissatisfied;
        color = Colors.red[300]!;
        break;
      case MoodLevel.sad:
        icon = Icons.sentiment_dissatisfied;
        color = Colors.orange[300]!;
        break;
      case MoodLevel.neutral:
        icon = Icons.sentiment_neutral;
        color = Colors.amber[400]!;
        break;
      case MoodLevel.happy:
        icon = Icons.sentiment_satisfied;
        color = Colors.lightGreen[400]!;
        break;
      case MoodLevel.veryHappy:
        icon = Icons.sentiment_very_satisfied;
        color = Colors.green[500]!;
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: selected ? 28 : 24,
        backgroundColor: selected ? color.withAlpha((0.3 * 255).toInt()) : Colors.grey[100],
        child: Icon(icon, color: color, size: selected ? 36 : 30),
      ),
    );
  }
}
