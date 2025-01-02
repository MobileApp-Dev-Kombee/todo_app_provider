import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Text('Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)}'),
          ],
        ),
        trailing: Chip(
          label: Text(task.status.value),
        ),
      ),
    );
  }
}
