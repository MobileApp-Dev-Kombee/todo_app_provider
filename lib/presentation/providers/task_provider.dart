import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../data/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FlutterSecureStorage _storage;
  List<TaskModel> _tasks = [];

  TaskProvider(this._storage) {
    _loadTasks();
  }

  List<TaskModel> get tasks => _tasks;

  Future<void> _loadTasks() async {
    final tasksString = await _storage.read(key: 'tasks');
    if (tasksString != null) {
      final tasksList = jsonDecode(tasksString) as List;
      _tasks = tasksList.map((e) => TaskModel.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final tasksString = jsonEncode(_tasks.map((e) => e.toMap()).toList());
    await _storage.write(key: 'tasks', value: tasksString);
  }
}
