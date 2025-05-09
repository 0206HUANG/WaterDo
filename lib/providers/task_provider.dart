import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _box = Hive.box<Task>('tasks');

  // Cache the tasks list to detect changes
  List<Task>? _cachedTasks;

  List<Task> get allTasks {
    final tasks = _box.values.toList();

    // Sort tasks by schedule date (today first, then future dates)
    tasks.sort((a, b) {
      bool isAToday = _isToday(a.schedule);
      bool isBToday = _isToday(b.schedule);

      // If both are today or both are not today
      if (isAToday && isBToday) {
        return 0; // Both are today, keep original order
      } else if (isAToday) {
        return -1; // a is today, it comes first
      } else if (isBToday) {
        return 1; // b is today, it comes first
      } else if (a.schedule == null && b.schedule == null) {
        return 0; // Both have no date but are not today, keep original order
      } else if (a.schedule == null) {
        return 1; // a has no date and is not today, b comes first
      } else if (b.schedule == null) {
        return -1; // b has no date and is not today, a comes first
      } else {
        return a.schedule!.compareTo(b.schedule!); // Compare future dates
      }
    });

    // Cache the sorted list
    _cachedTasks = List<Task>.from(tasks);

    return _cachedTasks!;
  }

  List<Task> get today =>
      _box.values.where((t) => _isToday(t.schedule)).toList();

  List<Task> get completed =>
      _box.values.where((t) => t.done && _isToday(t.schedule)).toList();

  void add(Task task) {
    _box.add(task);
    notifyListeners();
  }

  // Update a specific task's completed status by its ID
  void toggle(Task task) {
    // Find the task by ID to ensure we're updating the correct one
    try {
      final taskToUpdate = _box.values.firstWhere(
        (t) => t.id == task.id,
        orElse: () => task, // Fallback to the provided task if not found
      );

      // Toggle the done status
      taskToUpdate.done = !taskToUpdate.done;
      taskToUpdate.save();

      // Always notify listeners after modifying data
      notifyListeners();
    } catch (e) {
      debugPrint('Error in toggle task: $e');
    }
  }

  void delete(Task task) {
    try {
      // Find the task by ID to ensure we're deleting the correct one
      final taskToDelete = _box.values.firstWhere(
        (t) => t.id == task.id,
        orElse: () => task, // Fallback to the provided task if not found
      );

      taskToDelete.delete();
      notifyListeners();
    } catch (e) {
      debugPrint('Error in delete task: $e');
    }
  }

  bool _isToday(DateTime? d) {
    if (d == null) return true;
    final now = DateTime.now();
    return now.year == d.year && now.month == d.month && now.day == d.day;
  }
}
