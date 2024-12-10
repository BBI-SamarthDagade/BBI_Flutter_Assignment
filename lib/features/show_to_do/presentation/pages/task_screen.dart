// import 'package:flutter/material.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/delete_task_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/get_all_tasks_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/update_task_use_case.dart';

// class TaskScreen extends StatefulWidget {
//   final GetAllTasksUseCase getAllTasksUseCase;
//   final DeleteTaskUseCase deleteTaskUseCase;
//   final UpdateTaskUseCase updateTaskUseCase;

//   TaskScreen({
//     Key? key,
//     required this.getAllTasksUseCase,
//     required this.deleteTaskUseCase,
//     required this.updateTaskUseCase,
//   }) : super(key: key);

//   @override
//   _TaskScreenState createState() => _TaskScreenState();
// }

// class _TaskScreenState extends State<TaskScreen> {
//   late List<Task> _tasks;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tasks = [];
//     _loadTasks();
//   }

//   void _loadTasks() async {
//     setState(() {
//       _isLoading = true; // Show loading state
//     });

//     final result = await widget.getAllTasksUseCase.call();
//     result.fold(
//       (failure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(failure.message)),
//         );
//       },
//       (tasks) {
//         setState(() {
//           _tasks = tasks;
//         });
//       },
//     );

//     setState(() {
//       _isLoading = false; // Hide loading state
//     });

//     await widget.getAllTasksUseCase.call();
//   }

//   void _deleteTask(int index) async {
//     final result = await widget.deleteTaskUseCase.call(index);
//     result.fold(
//       (failure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(failure.message)),
//         );
//       },
//       (_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Task deleted successfully')),
//         );

//         _loadTasks(); // Refresh task list
//       },
//     );
//   }

//   void _updateTask(Task task) async {
//     final result = await widget.updateTaskUseCase.call(task);
//     result.fold(
//       (failure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(failure.message)),
//         );
//       },
//       (_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Task updated successfully')),
//         );
//         _loadTasks(); // Refresh task list
//       },
//     );
//   }

//   void _editTask(Task task) {
//     final TextEditingController _editController =
//         TextEditingController(text: task.task);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Task'),
//           content: TextField(
//             controller: _editController,
//             decoration: InputDecoration(
//               labelText: 'Task',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Update the task with new text
//                 final updatedTask = Task(
//                   task: _editController.text,
//                   index: task.index, // Preserve the original index
//                 );
//                 _updateTask(updatedTask); // Call the update task method
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task List'),
//       ),
//       body: _isLoading
//           ? Center(child: Text('Loading...')) // Optional loader text
//           : _tasks.isEmpty
//               ? Center(
//                   child: Text(
//                     'To Add Task! Press the + button.',
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: _tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = _tasks[index];
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 239, 223, 222),
//                         border: Border.all(width: 2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       margin: const EdgeInsets.all(5),
//                       child: ListTile(
//                         title: Text(task.task),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               onPressed: () {
//                                 _editTask(task); // Open the edit dialog
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete),
//                               onPressed: () => _deleteTask(index),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add').then((_) {
//             _loadTasks(); // Reload tasks after returning from AddTaskScreen
//           });
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Task',
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_event.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_state.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskGetSuccess) {
            final tasks = state.tasks;
            if (tasks.isEmpty) {
              return Center(child: Text("No tasks available!"));
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5), // Margin for each tile
                  child: ListTile(
                    tileColor:
                        Colors.grey[200], // Light background for the tile
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      side: BorderSide(
                        color: const Color.fromARGB(255, 15, 16, 16),
                        width: 1, // Border style
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.all(20), // Padding inside the tile
                    title: Text(
                      task.task,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87, // Text color
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: const Color.fromARGB(255, 161, 157, 238)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTaskScreen(task: task),
                              ),
                            ).then((_) {
                              context.read<TaskBloc>().add(GetAllTasks());
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(DeleteTask(index: index));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TaskFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Center(child: Text("No Data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          ).then((_) {
            context.read<TaskBloc>().add(GetAllTasks());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
