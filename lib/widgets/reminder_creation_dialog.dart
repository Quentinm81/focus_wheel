import 'package:flutter/material.dart';

class ReminderCreationDialog extends StatefulWidget {
  final dynamic initialReminder;
  const ReminderCreationDialog({super.key, this.initialReminder});

  @override
  State<ReminderCreationDialog> createState() => _ReminderCreationDialogState();
}

class _ReminderCreationDialogState extends State<ReminderCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  DateTime? _scheduledAt;
  bool _recurring = false;
  String? _recurrenceRule;

  @override
  void initState() {
    super.initState();
    if (widget.initialReminder != null) {
      _textController.text = widget.initialReminder.text;
      _scheduledAt = widget.initialReminder.scheduledAt;
      _recurring = widget.initialReminder.recurring;
      _recurrenceRule = widget.initialReminder.recurrenceRule;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _scheduledAt = DateTime(
              picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid && _scheduledAt != null) {
      Navigator.of(context).pop({
        'text': _textController.text.trim(),
        'scheduledAt': _scheduledAt,
        'recurring': _recurring,
        'recurrenceRule': _recurrenceRule,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialReminder == null
          ? 'Créer un rappel'
          : 'Modifier le rappel'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Texte du rappel'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Saisir un texte' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(_scheduledAt == null
                      ? 'Aucune date'
                      : '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year} ${_scheduledAt!.hour.toString().padLeft(2, '0')}:${_scheduledAt!.minute.toString().padLeft(2, '0')}'),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Choisir date/heure'),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _recurring,
                  onChanged: (v) => setState(() => _recurring = v ?? false),
                ),
                const Text('Récurrent'),
              ],
            ),
            if (_recurring)
              TextFormField(
                initialValue: _recurrenceRule,
                decoration: const InputDecoration(
                    labelText: 'Règle de récurrence (ex: daily, weekly)'),
                onChanged: (v) => _recurrenceRule = v.trim(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.initialReminder == null ? 'Créer' : 'Enregistrer'),
        ),
      ],
    );
  }
}
