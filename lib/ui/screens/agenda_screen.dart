import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final TextEditingController controller = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    void addEventDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Ajouter un événement'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Titre de l\'événement'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        startDate = DateTime(
                          picked.year, picked.month, picked.day, time.hour, time.minute);
                        endDate = startDate!.add(const Duration(hours: 1));
                      }
                    }
                  },
                  child: const Text('Choisir date et heure'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty && startDate != null && endDate != null) {
                    final event = Event(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: controller.text,
                      startTime: startDate!,
                      endTime: endDate!,
                      colorHex: Colors.blue.value,
                    );
                    ref.read(eventsProvider.notifier).addEvent(event);
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
        title: Text('Mon Agenda',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEventDialog,
        child: const Icon(Icons.add),
      ),
      body: events.isEmpty
          ? Center(child: Text('Aucun événement', style: TextStyle(fontSize: size.width * 0.05)))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (ctx, idx) {
                final event = events[idx];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text('${event.startTime} - ${event.endTime}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(eventsProvider.notifier).deleteEvent(event.id);
                    },
                  ),
                );
              },
            ),
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }
}

