import 'package:flutter_test/flutter_test.dart';
import '../helpers/fake_box.dart';

import 'package:focus_wheel/providers/task_provider.dart';
import 'package:focus_wheel/models/task.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TasksNotifier', () {
    late FakeBox<Task> box;
    late TasksNotifier notifier;

    setUp(() {
      box = FakeBox<Task>();



      notifier = TasksNotifier(box);
    });

    test('initial state is box.values', () {
      expect(notifier.state, []);
    });

    test('addTask adds and updates state', () {
      final task = Task(
        id: 'id1',
        title: 'Test',
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
        completedAt: null,
      );

      notifier.addTask(task);

      expect(notifier.state, [task]);
    });

    test('moveTask updates status', () {
      final task = Task(
        id: 'id1',
        title: 'Test',
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
        completedAt: null,
      );


      notifier.moveTask(task, TaskStatus.done);

      expect(notifier.state.first.status, TaskStatus.done);
    });
  });
}
