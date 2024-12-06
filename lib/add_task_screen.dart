import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(String) onSaveTask; // Callback for both add and update
  final String? initialTask; // Optional initial task text for updates

  const AddTaskScreen({super.key, required this.onSaveTask, this.initialTask});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _taskController.text = widget.initialTask!; // Pre-fill text for updates
    }
  }

  @override
  void dispose() {
    _taskController.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: const Color(0xFFEEEEE9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  widget.onSaveTask(_taskController.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(widget.initialTask == null ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
