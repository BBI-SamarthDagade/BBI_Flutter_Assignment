import 'package:flutter/material.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_event.dart';
import 'package:to_do_list_clean_arch/service_locator.dart';

class AddTaskScreen extends StatelessWidget {
  final Task? task;

  AddTaskScreen({this.task});

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      _titleController.text = task!.task;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? "Add Task" : "Update Task"),
      ),

      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Add a label for the field
            Text(
              "Task",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            
            ),
            SizedBox(height: 10),

            // Enhanced TextField
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  hintText: "Enter your task title",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),

            // Action button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;

                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Title cannot be empty!")),
                    );
                    return;
                  }

                  if (task == null) {
                    serviceLocator<TaskBloc>().add(TaskAdd(title: title));
                  } else {
                    final newTask = Task(task: title, index: task!.index);
                    serviceLocator<TaskBloc>().add(UpdateTask(task: newTask));
                  }

                  Navigator.pop(context);
                },
                child: Text(task == null ? "Add Task" : "Update Task"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
