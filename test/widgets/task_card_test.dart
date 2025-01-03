import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/enums/task_status.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/widgets/task_card.dart';
import '../mocks/mock_secure_storage.dart';

void main() {
  late TaskProvider taskProvider;

  setUp(() {
    taskProvider = TaskProvider(MockSecureStorage());
  });

  testWidgets('TaskCard displays task information correctly',
      (WidgetTester tester) async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.pending,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: Material(child: TaskCard(task: task)),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text(TaskStatus.pending.value), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('TaskCard checkbox toggles task status',
      (WidgetTester tester) async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      createdAt: DateTime.now(),
      dueDate: DateTime.now(),
      status: TaskStatus.pending,
    );

    await taskProvider.addTask(task);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: Material(child: TaskCard(task: task)),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(taskProvider.tasks.first.status, TaskStatus.completed);
  });
}
