import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mood_entry.dart';
import '../../providers/mood_journal_provider.dart';

class MoodJournalScreen extends ConsumerWidget {
  const MoodJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodJournalProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    MoodLevel selectedMood = MoodLevel.neutral;
    final TextEditingController controller = TextEditingController();
    DateTime? selectedDate;

    void addMoodDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Ajouter une entrée d\'humeur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<MoodLevel>(
                  value: selectedMood,
                  items: MoodLevel.values
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.toString().split('.').last),
                          ))
                      .toList(),
                  onChanged: (m) {
                    if (m != null) selectedMood = m;
                  },
                ),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Note'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      selectedDate = picked;
                    }
                  },
                  child: const Text('Choisir la date'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDate != null) {
                    final moodEntry = MoodEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: selectedDate!,
                      mood: selectedMood,
                      note: controller.text,
                    );
                    ref.read(moodJournalProvider.notifier).addMood(moodEntry);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Journal d’humeur',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMoodDialog,
        child: const Icon(Icons.add),
      ),
      body: moods.isEmpty
          ? Center(child: Text('Aucune entrée', style: TextStyle(fontSize: size.width * 0.05)))
          : ListView.builder(
              itemCount: moods.length,
              itemBuilder: (ctx, idx) {
                final mood = moods[idx];
                return ListTile(
                  title: Text(mood.mood.toString().split('.').last),
                  subtitle: Text('${mood.date} - ${mood.note ?? ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(moodJournalProvider.notifier).deleteMood(mood.id);
                    },
                  ),
                );
              },
            ),
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }
}

