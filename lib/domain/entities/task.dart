import 'package:todo_app/core/enums/task_status.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.status,
  });
}
