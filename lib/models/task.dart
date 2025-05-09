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
}
