import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/strings.dart';
import '../../core/enums/task_status.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DateTime _dueDate = DateTime.now();
  final TaskStatus _status = TaskStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createTask),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration:
                  const InputDecoration(labelText: AppStrings.taskTitle),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: AppStrings.taskDescription),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final task = TaskModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        status: _status,
      );

      context.read<TaskProvider>().addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
