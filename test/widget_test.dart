// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/core/constants/strings.dart';
import 'package:todo_app/core/enums/task_status.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'package:todo_app/presentation/widgets/task_card.dart';

// Mock FlutterSecureStorage
class MockSecureStorage extends FlutterSecureStorage {
  Map<String, String> storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    storage[key] = value ?? '';
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return storage[key];
  }
}

void main() {
  late MockSecureStorage mockStorage;
  late TaskProvider taskProvider;

  setUp(() {
    mockStorage = MockSecureStorage();
    taskProvider = TaskProvider(mockStorage);
  });

  testWidgets('HomeScreen shows empty state when no tasks',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text(AppStrings.noTasks), findsOneWidget);
    expect(find.byType(TaskCard), findsNothing);
  });

  testWidgets('HomeScreen shows tasks when available',
      (WidgetTester tester) async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.pending,
    );

    await taskProvider.addTask(task);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text(TaskStatus.pending.value), findsOneWidget);
  });

  test('TaskProvider can add task', () async {
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

  test('TaskProvider can update task', () async {
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

  test('TaskProvider can delete task', () async {
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
}
