import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

final taskBoxProvider = Provider<Box<Task>>((ref) => Hive.box<Task>('tasks'));

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  final box = ref.watch(taskBoxProvider);
  return TasksNotifier(box);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final Box<Task> box;
  TasksNotifier(this.box) : super(box.values.toList());

  void addTask(Task task) {
    box.put(task.id, task);
    state = box.values.toList();
  }

  void updateTask(Task task) {
    box.put(task.id, task);
    state = box.values.toList();
  }

  void deleteTask(String id) {
    box.delete(id);
    state = box.values.toList();
  }

  void moveTask(Task task, TaskStatus newStatus) {
    final updated = Task(
      id: task.id,
      title: task.title,
      status: newStatus,
      createdAt: task.createdAt,
      completedAt: newStatus == TaskStatus.done ? DateTime.now() : null,
    );
    box.put(updated.id, updated);
    state = box.values.toList();
  }
}
