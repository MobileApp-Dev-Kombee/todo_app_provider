import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/core/enums/task_status.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import '../mocks/mock_secure_storage.dart';

void main() {
  late MockSecureStorage mockStorage;
  late TaskProvider taskProvider;

  setUp(() {
    mockStorage = MockSecureStorage();
    taskProvider = TaskProvider(mockStorage);
  });

  group('TaskProvider Tests', () {
    test('Initial state should be empty', () {
      expect(taskProvider.tasks, isEmpty);
    });

    test('Add task should update tasks list', () async {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime.now(),
        dueDate: DateTime.now(),
        status: TaskStatus.pending,
      );

      await taskProvider.addTask(task);
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Test Task');
    });

    test('Update task should modify existing task', () async {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime.now(),
        dueDate: DateTime.now(),
        status: TaskStatus.pending,
      );

      await taskProvider.addTask(task);

      final updatedTask = TaskModel(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        createdAt: task.createdAt,
        dueDate: task.dueDate,
        status: TaskStatus.completed,
      );

      await taskProvider.updateTask(updatedTask);
      expect(taskProvider.tasks.first.title, 'Updated Task');
      expect(taskProvider.tasks.first.status, TaskStatus.completed);
    });

    test('Delete task should remove task from list', () async {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime.now(),
        dueDate: DateTime.now(),
        status: TaskStatus.pending,
      );

      await taskProvider.addTask(task);
      expect(taskProvider.tasks.length, 1);

      await taskProvider.deleteTask('1');
      expect(taskProvider.tasks.isEmpty, true);
    });
  });
}
