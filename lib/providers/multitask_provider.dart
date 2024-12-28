import 'package:flutter/material.dart';

class Task {
  String name;
  bool isChecked;

  Task({required this.name, this.isChecked = false});
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String taskName) {
    _tasks.add(Task(name: taskName));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isChecked = !_tasks[index].isChecked;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
