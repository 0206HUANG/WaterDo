# SQLite Local Persistence in Flutter

This project demonstrates a complete implementation of SQLite local persistence using the `sqflite` plugin in Flutter. The example manages a "dogs" table and provides full CRUD (Create, Read, Update, Delete) operations.

## 📋 Table of Contents

1. [Dependencies](#dependencies)
2. [Project Structure](#project-structure)
3. [Data Model](#data-model)
4. [Database Helper](#database-helper)
5. [UI Implementation](#ui-implementation)
6. [Usage Examples](#usage-examples)
7. [Testing](#testing)

## 🚀 Dependencies

The following dependencies have been added to `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.4.2  # SQLite plugin for Flutter
  path: ^1.9.1     # Path manipulation utilities
```

### Required Imports

```dart
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
```

## 📁 Project Structure

```
lib/
├── models/
│   └── dog.dart              # Data model for Dog entity
├── db/
│   └── database_helper.dart  # Database operations manager
├── ui/
│   └── screens/
│       └── sqlite_demo_screen.dart  # UI for CRUD operations
└── main.dart                 # App entry point with SQLite demo
```

## 🐕 Data Model

### `lib/models/dog.dart`

```dart
class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({required this.id, required this.name, required this.age});

  // Convert to Map for database storage
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  @override
  String toString() => 'Dog{id: $id, name: $name, age: $age}';

  // Create from Map
  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }
}
```

**Key Features:**
- Immutable data class
- `toMap()` method for database serialization
- `fromMap()` factory constructor for deserialization
- Clear string representation for debugging

## 🗄️ Database Helper

### `lib/db/database_helper.dart`

The `DatabaseHelper` class manages all database operations using the singleton pattern:

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('doggie_database.db');
    return _db!;
  }
  
  // ... CRUD methods
}
```

### Database Schema

```sql
CREATE TABLE dogs(
  id INTEGER PRIMARY KEY,
  name TEXT,
  age INTEGER
)
```

### Available Methods

- **`insertDog(Dog dog)`** - Insert a new dog
- **`getAllDogs()`** - Retrieve all dogs
- **`updateDog(Dog dog)`** - Update existing dog
- **`deleteDog(int id)`** - Delete dog by ID
- **`close()`** - Close database connection

## 🎨 UI Implementation

### SQLite Demo Screen

The `SQLiteDemoScreen` provides a complete user interface for testing all CRUD operations:

**Features:**
- Add new dogs with name and age
- View all dogs in a scrollable list
- Edit existing dogs with dialog
- Delete dogs with confirmation
- Real-time updates

**Navigation:**
- Access via the storage icon in the home screen app bar
- Material Design components with teal theme

## 💡 Usage Examples

### Basic CRUD Operations

```dart
// Get database instance
final db = DatabaseHelper.instance;

// Insert a dog
await db.insertDog(Dog(id: 1, name: 'Buddy', age: 2));

// Get all dogs
final dogs = await db.getAllDogs();
print(dogs); // [Dog{id: 1, name: Buddy, age: 2}]

// Update a dog
await db.updateDog(Dog(id: 1, name: 'Buddy', age: 3));

// Delete a dog
await db.deleteDog(1);
```

### In Widget Context

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Dog> _dogs = [];

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final dogs = await _db.getAllDogs();
    setState(() {
      _dogs = dogs;
    });
  }

  Future<void> _addDog(String name, int age) async {
    final dog = Dog(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      age: age,
    );
    await _db.insertDog(dog);
    _loadDogs(); // Refresh the list
  }
}
```

## 🧪 Testing

### Automated Testing (in main.dart)

The app automatically runs SQLite tests on startup:

```dart
Future<void> _testSQLiteOperations() async {
  print('Starting SQLite Demo...');
  
  final db = DatabaseHelper.instance;

  // 1) Insert
  var fido = const Dog(id: 0, name: 'Fido', age: 3);
  await db.insertDog(fido);
  print('Inserted: $fido');

  // 2) Query and print all dogs
  var dogs = await db.getAllDogs();
  print('All dogs after insert: $dogs');

  // 3) Update
  fido = Dog(id: fido.id, name: fido.name, age: fido.age + 1);
  await db.updateDog(fido);
  dogs = await db.getAllDogs();
  print('All dogs after update: $dogs');

  // 4) Insert another dog
  var buddy = const Dog(id: 1, name: 'Buddy', age: 2);
  await db.insertDog(buddy);
  dogs = await db.getAllDogs();
  print('All dogs after adding Buddy: $dogs');

  // 5) Delete a dog
  await db.deleteDog(fido.id);
  dogs = await db.getAllDogs();
  print('All dogs after deleting Fido: $dogs');

  print('SQLite Demo completed!');
}
```

### Manual Testing

1. Run the app: `flutter run`
2. Check console output for automated test results
3. Tap the storage icon in the app bar to open SQLite Demo
4. Test all CRUD operations through the UI

## 🔧 Best Practices Implemented

1. **Singleton Pattern** - Single database instance throughout the app
2. **Error Handling** - Proper conflict resolution with `ConflictAlgorithm.replace`
3. **Resource Management** - Database connection management
4. **Type Safety** - Strong typing with Dart classes
5. **Separation of Concerns** - Model, Database, and UI layers are separate
6. **Async/Await** - Non-blocking database operations

## 🚀 Running the Demo

1. Navigate to the WaterDo directory
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`
4. Watch console for automated SQLite test output
5. Tap the storage icon to access the interactive SQLite demo

The implementation provides a solid foundation for local data persistence in Flutter applications and can be easily adapted for your own data models and requirements. 