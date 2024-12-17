import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(int index);
  Future<void> updateTask(Task task);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  static const String _taskKey = 'tasks';
  static const String _taskIdCounterKey = 'taskIdCounter';

  /// Helper: Retrieve all tasks from SharedPreferences
  List<Task> _getTasksFromPrefs() {
    final String? tasksJson = sharedPreferences.getString(_taskKey);

    if (tasksJson != null) {
      List<dynamic> jsonList = json.decode(
          tasksJson); //[{index: 74, task: asdfsdfsdf}, {index: 75, task: asdfsadfsdf}]  List<Map<String, dynamic>>
      return jsonList
          .map((jsonItem) => Task.fromMap(jsonItem))
          .toList(); //[Task(index : 74, task: asdfsdfsdf), Task(task: 75, index: asdfsadfsdf)]
    }
    return [];
  }

  /// Helper: Save all tasks to SharedPreferences
  Future<void> _saveTasksToPrefs(List<Task> tasks) async {
    // Convert tasks to JSON without filtering
    final List<Map<String, dynamic>> jsonList =
        tasks.map((task) => task.toMap()).toList();
        
    final String tasksJson = json.encode(jsonList);

    // Save to shared preferences
    await sharedPreferences.setString(_taskKey, tasksJson);
    print("Task Saved Successfully");
  }


  /// Helper: Get current task ID counter
  int _getCurrentIdCounter() {
    return sharedPreferences.getInt(_taskIdCounterKey) ?? 0;
  }

  /// Helper: Increment task ID counter
  Future<void> _incrementIdCounter() async {
    final currentId = _getCurrentIdCounter();
    await sharedPreferences.setInt(_taskIdCounterKey, currentId + 1);
  }

  @override
  Future<List<Task>> getTasks() async {
    return _getTasksFromPrefs();
  }

  @override
  Future<void> saveTask(Task task) async {
    List<Task> tasks = _getTasksFromPrefs();

    // Assign a unique ID to the task
    final newId = _getCurrentIdCounter();
    final newTask = Task(
      task: task.task,
      index: newId,
    );

    // Add the new task to the list
    tasks.add(newTask);

    // Save tasks and increment the ID counter
    await _saveTasksToPrefs(tasks);
    await _incrementIdCounter();
  }

  @override
  Future<void> deleteTask(int index) async {
    print("this is local $index");
    List<Task> tasks = _getTasksFromPrefs();
    print("before remove $tasks $index");

    if (index >= 0 && index < tasks.length) {
      // Remove the task at the specified index
      tasks.removeAt(index);
      // Save the updated list back to SharedPreferences
      await _saveTasksToPrefs(tasks);
      print("after remove $tasks $index");

      print("Task Removed Sucessfully");
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    List<Task> tasks = _getTasksFromPrefs();

    // Find the index of the task with the matching ID
    final taskIndex = tasks.indexWhere((t) => t.index == task.index);

    if (taskIndex != -1) {
      // Update the task at the found index
      tasks[taskIndex] = task;

      // Save the updated list back to SharedPreferences
      await _saveTasksToPrefs(tasks);
      print("Task Updated Successfully");
    } else {
      throw Exception('Task not found');
    }
  }
}
