import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'models/task.dart';
import 'db/database_helper.dart';
import 'ui/screens/sqlite_demo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only test SQLite operations on non-web platforms
  if (!kIsWeb) {
    await _testSQLiteOperations();
  }

  runApp(const SQLiteTestApp());
}

class SQLiteTestApp extends StatelessWidget {
  const SQLiteTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SQLiteTestHome(),
    );
  }
}

class SQLiteTestHome extends StatelessWidget {
  const SQLiteTestHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Testing App'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFFAFAFA)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.storage,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 24),
                const Text(
                  'SQLite Database Testing',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  kIsWeb 
                      ? 'SQLite is not available on Web platform'
                      : 'Test SQLite CRUD operations with tasks',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!kIsWeb) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SQLiteDemoScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start SQLite Demo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    '💡 This app is designed for desktop and mobile platforms',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Test SQLite CRUD operations with Tasks
Future<void> _testSQLiteOperations() async {
  print('🚀 Starting SQLite Task Demo...');
  
  try {
    final db = DatabaseHelper.instance;

    // 1) Insert
    var firstTask = Task('Complete project documentation');
    await db.insertTask(firstTask);
    print('✅ Inserted: $firstTask');

    // 2) Query and print all tasks
    var tasks = await db.getAllTasks();
    print('📋 All tasks after insert: $tasks');

    // 3) Update
    var updatedTask = Task(
      'Complete project documentation and testing',
      id: firstTask.id,
      done: false,
      schedule: firstTask.schedule,
      dx: firstTask.dx,
      dy: firstTask.dy,
    );
    await db.updateTask(updatedTask);
    tasks = await db.getAllTasks();
    print('📝 All tasks after update: $tasks');

    // 4) Insert another task
    var secondTask = Task('Review code', schedule: DateTime.now().add(const Duration(days: 1)));
    await db.insertTask(secondTask);
    tasks = await db.getAllTasks();
    print('➕ All tasks after adding second task: $tasks');

    // 5) Mark first task as completed
    var completedTask = Task(
      updatedTask.title,
      id: updatedTask.id,
      done: true,
      schedule: updatedTask.schedule,
      dx: updatedTask.dx,
      dy: updatedTask.dy,
    );
    await db.updateTask(completedTask);
    tasks = await db.getAllTasks();
    print('✅ All tasks after marking first as completed: $tasks');

    // 6) Delete the second task
    await db.deleteTask(secondTask.id);
    tasks = await db.getAllTasks();
    print('🗑️ All tasks after deleting second task: $tasks');

    print('🎉 SQLite Task Demo completed successfully!');
  } catch (e) {
    print('❌ SQLite operations failed: $e');
  }
} 