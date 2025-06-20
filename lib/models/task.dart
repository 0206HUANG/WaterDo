import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool done;

  @HiveField(2)
  DateTime? schedule;

  @HiveField(3)
  double? dx;

  @HiveField(4)
  double? dy;

  @HiveField(5)
  final String id;

  Task(
    this.title, {
    this.done = false,
    this.schedule,
    this.dx,
    this.dy,
    String? id,
  }) : id = id ?? const Uuid().v4();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Convert Task to Map for SQLite storage
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
      'schedule_date': schedule?.toIso8601String(),
      'dx': dx,
      'dy': dy,
    };
  }

  // Create Task from Map (for SQLite)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      map['title'] as String,
      id: map['id'] as String,
      done: (map['done'] as int) == 1,
      schedule: map['schedule_date'] != null 
          ? DateTime.parse(map['schedule_date'] as String)
          : null,
      dx: map['dx'] as double?,
      dy: map['dy'] as double?,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, done: $done, schedule: $schedule}';
  }
}
