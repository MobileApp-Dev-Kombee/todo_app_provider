import '../../domain/entities/task.dart';
import '../../core/enums/task_status.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.dueDate,
    required super.status,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.index,
    };
  }

  // Create from Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: DateTime.parse(map['dueDate']),
      status: TaskStatus.values[map['status']],
    );
  }
}
