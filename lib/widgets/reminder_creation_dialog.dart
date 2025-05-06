import 'package:flutter/material.dart';

class ReminderCreationDialog extends StatelessWidget {
  final dynamic initialReminder;
  const ReminderCreationDialog({super.key, this.initialReminder});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Créer un rappel'),
      content: Text('Contenu du dialogue de création de rappel.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Fermer'),
        ),
      ],
    );
  }
}
