import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';

final eventBoxProvider = Provider<Box<Event>>((ref) => Hive.box<Event>('events'));

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  final box = ref.watch(eventBoxProvider);
  return EventsNotifier(box);
});

class EventsNotifier extends StateNotifier<List<Event>> {
  final Box<Event> box;
  EventsNotifier(this.box) : super(box.values.toList());

  void addEvent(Event event) {
    box.put(event.id, event);
    state = box.values.toList();
  }

  void updateEvent(Event event) {
    box.put(event.id, event);
    state = box.values.toList();
  }

  void deleteEvent(String id) {
    box.delete(id);
    state = box.values.toList();
  }

  /// Update the order of events for a specific hour. Optionally, update a field for order if needed.
  void updateEventsOrderForHour(int hour, List<Event> orderedEvents) {
    // Optionally, add an 'order' field to Event for persistent ordering.
    // For now, just update the state order for this hour.
    final otherEvents = state.where((e) => e.startTime.hour != hour).toList();
    state = [
      ...otherEvents,
      ...orderedEvents,
    ];
    // Optionally persist the new order in Hive (if using a field for order)
  }
}

