import 'package:flutter/material.dart';

class TaskCreationDialog extends StatelessWidget {
  final dynamic initialTask;
  const TaskCreationDialog({super.key, this.initialTask});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Créer/Éditer une tâche'),
      content: Text('Contenu du dialogue de création/édition de tâche.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Fermer'),
        ),
      ],
    );
  }
}
