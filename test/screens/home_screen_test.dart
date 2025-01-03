import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/constants/strings.dart';
import 'package:todo_app/core/enums/task_status.dart';
import 'package:todo_app/data/models/task_model.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import '../mocks/mock_secure_storage.dart';

void main() {
  late TaskProvider taskProvider;

  setUp(() {
    taskProvider = TaskProvider(MockSecureStorage());
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
  });

  testWidgets('HomeScreen shows search bar and filter chips',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text(AppStrings.all),
        matching: find.byType(FilterChip),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text(TaskStatus.pending.value),
        matching: find.byType(FilterChip),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text(TaskStatus.completed.value),
        matching: find.byType(FilterChip),
      ),
      findsOneWidget,
    );
  });

  testWidgets('HomeScreen filters tasks correctly',
      (WidgetTester tester) async {
    final task1 = TaskModel(
      id: '1',
      title: AppStrings.pendingTask,
      description: AppStrings.testDescription,
      createdAt: DateTime.now(),
      dueDate: DateTime.now(),
      status: TaskStatus.pending,
    );

    final task2 = TaskModel(
      id: '2',
      title: AppStrings.completedTask,
      description: AppStrings.testDescription,
      createdAt: DateTime.now(),
      dueDate: DateTime.now(),
      status: TaskStatus.completed,
    );

    await taskProvider.addTask(task1);
    await taskProvider.addTask(task2);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    final pendingFilterChip = find.ancestor(
      of: find.text(TaskStatus.pending.value),
      matching: find.byType(FilterChip),
    );
    await tester.tap(pendingFilterChip.first);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.pendingTask), findsOneWidget);
    expect(find.text(AppStrings.completedTask), findsNothing);
  });
}
