import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../widgets/bubble.dart';
import '../widgets/add_task_sheet.dart';
import 'sqlite_demo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use keys to force rebuild of the lists when data changes
    final activeTasksKey = GlobalKey();
    final completedTasksKey = GlobalKey();

    // Watch the task provider to rebuild when tasks change
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = taskProvider.allTasks;

    // Create separate mutable copies of the task lists to avoid issues
    final activeTasks = [...allTasks.where((task) => !task.done)];
    final completedTasks = [...allTasks.where((task) => task.done)];

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // App bar floats on top of the gradient.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.primary,
        title: const Text(
          'WaterDo',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SQLiteDemoScreen()),
              );
            },
            tooltip: 'SQLite Task Demo',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Completed')],
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: colorScheme.primary,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFFAFAFA)],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Active Tasks Tab
            _buildTaskList(context, activeTasks, key: activeTasksKey),

            // Completed Tasks Tab
            _buildTaskList(context, completedTasks, key: completedTasksKey),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () => showAddSheet(context),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> tasks, {Key? key}) {
    return tasks.isEmpty
        ? Center(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/empty.json',
                width: 160,
                repeat: false,
              ),
              const SizedBox(height: 24),
              Text(
                'No tasks here',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _tabController.index == 0
                    ? 'Tap + to add your first bubble'
                    : 'Complete tasks to see them here',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        )
        : SingleChildScrollView(
          key: key,
          padding: const EdgeInsets.fromLTRB(12, 120, 12, 80),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                tasks.map((task) {
                  // Important: Use the task ID as the key to ensure Flutter can identify each bubble correctly
                  return KeyedSubtree(
                    key: ValueKey(task.id),
                    child: Bubble(task),
                  );
                }).toList(),
          ),
        );
  }
}
