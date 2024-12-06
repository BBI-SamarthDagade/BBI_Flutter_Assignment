import 'package:flutter/material.dart';
import 'package:to_do_list/add_task_screen.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => ToDoListScreenState();
}

class ToDoListScreenState extends State<ToDoListScreen> {
  List<String> tasks = []; // List to store tasks

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _updateTask(int index, String task) {
    setState(() {
      tasks[index] = task;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Removes item from list at specific index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text("No task added Yet! Plan Your Day by Adding tasks."),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(), // Ensures a unique key for each task
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    final deletedTask = tasks[index];
                    _deleteTask(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task "$deletedTask" deleted'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },

                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 223, 222),
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.all(5),

                    child: ListTile(
                      title: Text(tasks[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    initialTask: tasks[index],
                                    onSaveTask: (updatedTask) {
                                      _updateTask(index, updatedTask);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => _deleteTask(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onSaveTask: _addTask,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
