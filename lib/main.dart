import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'providers/auth_provider.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 初始化 Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  final taskBox = await Hive.openBox<Task>('tasks');

  // Ensure all tasks have an ID
  // This is a migration for existing tasks that don't have an ID yet
  final uuid = Uuid();
  for (var i = 0; i < taskBox.length; i++) {
    final task = taskBox.getAt(i);
    if (task != null) {
      try {
        // Check if the ID exists by accessing it
        // If it throws an error, it means the field doesn't exist
        task.id;
      } catch (e) {
        // This is an old task without an ID field, we need to recreate it
        final newTask = Task(
          task.title,
          done: task.done,
          schedule: task.schedule,
          dx: task.dx,
          dy: task.dy,
          id: uuid.v4(),
        );

        taskBox.putAt(i, newTask);
      }
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const WaterDoApp(),
    ),
  );
}

class WaterDoApp extends StatelessWidget {
  const WaterDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterDo',
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
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
