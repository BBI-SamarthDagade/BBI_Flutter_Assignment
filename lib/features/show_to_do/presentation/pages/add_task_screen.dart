// import 'package:flutter/material.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/add_task_use_case.dart';


// class AddTaskScreen extends StatefulWidget {
//   final AddTaskUseCase addTaskUseCase;

//   AddTaskScreen({Key? key, required this.addTaskUseCase}) : super(key: key);

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final TextEditingController _taskController = TextEditingController();

//   void _addTask() {
   
//      if (_taskController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Task cannot be empty!')),
//     );
//     return; // Exit the method if empty
//   }


//     final task = Task(task: _taskController.text, index: DateTime.now().millisecondsSinceEpoch);
     
//     widget.addTaskUseCase(task).then((result) {
//       result.fold(
//         (failure) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
//         },
//         (_) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added successfully')));
//           Navigator.pop(context);
//         },
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Task')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _taskController,
//               decoration: const InputDecoration(
//                 labelText: 'Task',
//                 border: OutlineInputBorder(),
//               ),

//             ),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _addTask,
//               child: Text('Add Task'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
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
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            
            SizedBox(height: 20),

            ElevatedButton(
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
            ),

          ],
        ),
      ),
    );
  }
}
