import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_creation_dialog.dart';
import '../services/motivational_engine.dart';

class KanbanBoard extends ConsumerWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final todo = tasks.where((t) => t.status == TaskStatus.todo).toList();
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final done = tasks.where((t) => t.status == TaskStatus.done).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          _KanbanColumn(title: 'To Do', color: const Color(0xFF6EC1E4), tasks: todo, status: TaskStatus.todo),
          _KanbanColumn(title: 'In Progress', color: const Color(0xFFAED581), tasks: inProgress, status: TaskStatus.inProgress),
          _KanbanColumn(title: 'Done', color: const Color(0xFFBA68C8), tasks: done, status: TaskStatus.done),
        ],
      ),
    );
  }
}

class _KanbanColumn extends ConsumerWidget {
  final String title;
  final Color color;
  final List<Task> tasks;
  final TaskStatus status;
  const _KanbanColumn({required this.title, required this.color, required this.tasks, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withAlpha((0.07 * 255).toInt()),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            ),
            Expanded(
              child: DragTarget<Task>(
                onWillAcceptWithDetails: (details) => details.data.status != status,
                onAcceptWithDetails: (details) {
                  final task = details.data;
                  ref.read(tasksProvider.notifier).moveTask(task, status);
                },
                builder: (context, candidateData, rejectedData) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: tasks.length > 7 ? 7 : tasks.length,
                  itemBuilder: (context, i) {
                    final task = tasks[i];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: LongPressDraggable<Task>(
                        data: task,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Card(
                            color: color.withAlpha((0.5 * 255).toInt()),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(task.title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(opacity: 0.4, child: _buildTaskTile(context, ref, task, color, status)),
                        child: _buildTaskTile(context, ref, task, color, status),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Ajout du message "Scroll for more..." à la fin de la colonne SI plus de 7 tâches
            if (tasks.length > 7)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text('Scroll for more...', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }

  // Place ces méthodes en dehors de build pour éviter toute confusion
  Widget _buildTaskTile(BuildContext context, WidgetRef ref, Task task, Color color, TaskStatus status) {
    return Card(
      color: color.withAlpha((0.22 * 255).toInt()),
      child: ListTile(
        title: Text(task.title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: PopupMenuButton<TaskStatus>(
          icon: const Icon(Icons.more_vert),
          onSelected: (newStatus) async {
            ref.read(tasksProvider.notifier).moveTask(task, newStatus);
            if (newStatus == TaskStatus.done) {
              final phrase = await MotivationalEngine.getPhrase(tags: ['task', 'achievement']);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(phrase),
                    backgroundColor: color.withAlpha((0.95 * 255).toInt()),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          itemBuilder: (context) => TaskStatus.values
              .where((s) => s != status)
              .map((s) => PopupMenuItem(
                    value: s,
                    child: Text(_statusLabel(s)),
                  ))
              .toList(),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TaskCreationDialog(initialTask: task),
          );
        },
      ),
    );
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

