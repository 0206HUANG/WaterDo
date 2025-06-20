import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('waterdo_tasks.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0,
        schedule_date TEXT,
        dx REAL,
        dy REAL
      )
    ''');
  }

  // Insert a task
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(String id) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get tasks by completion status
  Future<List<Task>> getTasksByStatus(bool completed) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'done = ?',
      whereArgs: [completed ? 1 : 0],
    );
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  // Get tasks for today
  Future<List<Task>> getTodayTasks() async {
    final db = await database;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final maps = await db.query(
      'tasks',
      where: 'schedule_date = ? OR schedule_date IS NULL',
      whereArgs: [todayStr],
    );
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  // Close database (optional)
  Future close() async {
    final db = await database;
    db.close();
  }
} 