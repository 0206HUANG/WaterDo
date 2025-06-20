import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../db/database_helper.dart';

class SQLiteDemoScreen extends StatefulWidget {
  const SQLiteDemoScreen({super.key});

  @override
  State<SQLiteDemoScreen> createState() => _SQLiteDemoScreenState();
}

class _SQLiteDemoScreenState extends State<SQLiteDemoScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Task> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_titleController.text.isNotEmpty) {
      final task = Task(
        _titleController.text,
        schedule: _selectedDate,
      );
      
      await _dbHelper.insertTask(task);
      _titleController.clear();
      _selectedDate = null;
      _loadTasks();
    }
  }

  Future<void> _updateTask(Task task, String newTitle, DateTime? newDate) async {
    final updatedTask = Task(
      newTitle,
      id: task.id,
      done: task.done,
      schedule: newDate,
      dx: task.dx,
      dy: task.dy,
    );
    await _dbHelper.updateTask(updatedTask);
    _loadTasks();
  }

  Future<void> _toggleTask(Task task) async {
    final updatedTask = Task(
      task.title,
      id: task.id,
      done: !task.done,
      schedule: task.schedule,
      dx: task.dx,
      dy: task.dy,
    );
    await _dbHelper.updateTask(updatedTask);
    _loadTasks();
  }

  Future<void> _deleteTask(String id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks();
  }

  void _showEditDialog(Task task) {
    final titleController = TextEditingController(text: task.title);
    DateTime? editSelectedDate = task.schedule;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(editSelectedDate == null 
                      ? 'No date selected' 
                      : 'Date: ${editSelectedDate!.year}/${editSelectedDate!.month}/${editSelectedDate!.day}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: editSelectedDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          editSelectedDate = date;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTask(task, titleController.text, editSelectedDate);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if running on web platform
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SQLite Task Demo'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.web,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 24),
                Text(
                  'SQLite Not Available on Web',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'SQLite database is only supported on mobile and desktop platforms.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please run this app on Android, iOS, Windows, macOS, or Linux to test SQLite functionality.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  '💡 Use the main app instead - it uses Hive database which works perfectly on Web!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Task Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Add Task Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null 
                            ? 'No date selected (defaults to today)' 
                            : 'Scheduled: ${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectDate,
                      child: const Text('Select Date'),
                    ),
                    if (_selectedDate != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                        child: const Text('Clear'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Tasks List
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks found.\nAdd a task using the form above.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.done,
                            onChanged: (value) => _toggleTask(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.done ? TextDecoration.lineThrough : null,
                              color: task.done ? Colors.grey : null,
                            ),
                          ),
                          subtitle: Text(
                            task.schedule == null
                                ? 'Today'
                                : 'Scheduled: ${task.schedule!.year}/${task.schedule!.month}/${task.schedule!.day}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
} 