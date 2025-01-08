// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/constants/strings.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'mocks/mock_secure_storage.dart';

void main() {
  late MockSecureStorage mockStorage;
  late TaskProvider taskProvider;

  setUp(() {
    mockStorage = MockSecureStorage();
    taskProvider = TaskProvider(mockStorage);
  });

  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: taskProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text(AppStrings.tasks), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
