import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/enums/task_status.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          context.read<TaskProvider>().deleteTask(task.id);
        },
        child: ListTile(
          leading: Checkbox(
            value: task.status == TaskStatus.completed,
            onChanged: (bool? value) {
              final updatedTask = TaskModel(
                id: task.id,
                title: task.title,
                description: task.description,
                createdAt: task.createdAt,
                dueDate: task.dueDate,
                status: value! ? TaskStatus.completed : TaskStatus.pending,
              );
              context.read<TaskProvider>().updateTask(updatedTask);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.status == TaskStatus.completed
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(task.dueDate),
                    style: TextStyle(
                      color: task.dueDate.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Chip(
            label: Text(task.status.value),
            backgroundColor: _getStatusColor(task.status),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green.shade100;
      case TaskStatus.pending:
        return Colors.orange.shade100;
    }
  }
}
