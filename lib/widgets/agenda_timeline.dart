import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class AgendaTimeline extends ConsumerWidget {
  const AgendaTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemCount: 24,
      itemBuilder: (context, hour) {
        final timeLabel = '${hour.toString().padLeft(2, '0')}:00';
        final hourEvents = events.where((e) => e.startTime.hour == hour).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        if (hourEvents.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      timeLabel,
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(thickness: 1, color: Color(0xFFE3E3E3)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    timeLabel,
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(thickness: 1, color: Color(0xFFE3E3E3)),
                ),
              ],
            ),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > hourEvents.length) newIndex = hourEvents.length;
                if (oldIndex < newIndex) newIndex--;
                final updated = List<Event>.from(hourEvents);
                final event = updated.removeAt(oldIndex);
                updated.insert(newIndex, event);
                // Update startTime to preserve the new order (optionally add a field for order)
                // For now, just update provider with new order
                ref.read(eventsProvider.notifier).updateEventsOrderForHour(hour, updated);
              },
              children: [
                for (final event in hourEvents)
                  _EventCard(key: ValueKey(event.id), event: event),
              ],
            ),
            const SizedBox(height: 28),
          ],
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return GestureDetector(
        onLongPress: () async {
          final action = await showModalBottomSheet<String>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Color(0xFF6EC1E4)),
                    title: const Text('Edit'),
                    onTap: () => Navigator.pop(context, 'edit'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete'),
                    onTap: () => Navigator.pop(context, 'delete'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
          if (action == 'edit') {
            showDialog(
              context: context,
              builder: (context) => Container(),
            );
          } else if (action == 'delete') {
            ref.read(eventsProvider.notifier).deleteEvent(event.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event deleted'), duration: Duration(seconds: 1)),
            );
          }
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 60),
          color: Color(event.colorHex),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                ),
                Text(
                  '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                if (event.notes != null && event.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(event.notes!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

