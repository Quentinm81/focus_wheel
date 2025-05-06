import 'package:flutter/material.dart';
import '../widgets/reminders_list.dart';
import '../widgets/reminder_creation_dialog.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFB74D),
        title: const Text('Reminders', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RemindersList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFFB74D),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ReminderCreationDialog(),
          );
        },
        tooltip: 'Add Reminder',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
