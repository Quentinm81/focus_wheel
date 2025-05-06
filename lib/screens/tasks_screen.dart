import 'package:flutter/material.dart';
import '../widgets/kanban_board.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBA68C8),
        title: const Text('Tasks', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: KanbanBoard(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFBA68C8),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Container(),
          );
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
