import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class EventCreationDialog extends ConsumerStatefulWidget {
  final int? initialHour;
  final Event? initialEvent;
  const EventCreationDialog({super.key, required this.initialHour, required this.initialEvent});

  @override
  _EventCreationDialogState createState() => _EventCreationDialogState();
}

class _EventCreationDialogState extends ConsumerState<EventCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  Color _selectedColor = const Color(0xFF6EC1E4);

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      final e = widget.initialEvent!;
      _titleController.text = e.title;
      _notesController.text = e.notes ?? '';
      _startTime = TimeOfDay(hour: e.startTime.hour, minute: e.startTime.minute);
      _endTime = TimeOfDay(hour: e.endTime.hour, minute: e.endTime.minute);
      _selectedColor = Color(e.colorHex);
    } else {
      final now = TimeOfDay.now();
      _startTime = widget.initialHour != null ? TimeOfDay(hour: widget.initialHour!, minute: 0) : now;
      _endTime = TimeOfDay(hour: _startTime.hour, minute: _startTime.minute + 30);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: _startTime);
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: _endTime);
    if (picked != null) setState(() => _endTime = picked);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);
      final end = DateTime(now.year, now.month, now.day, _endTime.hour, _endTime.minute);
      final event = Event(
        id: widget.initialEvent?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        startTime: start,
        endTime: end,
        colorHex: _selectedColor.value,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      if (widget.initialEvent != null) {
        ref.read(eventsProvider.notifier).updateEvent(event);
      } else {
        ref.read(eventsProvider.notifier).addEvent(event);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.initialEvent == null ? 'Add Event' : 'Edit Event', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Enter a title' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickStartTime(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Start'),
                          child: Text(_startTime.format(context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickEndTime(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'End'),
                          child: Text(_endTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Color:'),
                    const SizedBox(width: 8),
                    ...[
                      Color(0xFF6EC1E4),
                      Color(0xFFAED581),
                      Color(0xFFFFB74D),
                      Color(0xFFBA68C8),
                    ].map((color) => GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color ? Colors.black : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  minLines: 1,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6EC1E4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}