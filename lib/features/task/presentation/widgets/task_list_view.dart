// import 'package:flutter/material.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

// class TaskListView extends StatelessWidget {
//   final List<TaskEntity> tasks;
//   final String userId;

//   const TaskListView({
//     Key? key,
//     required this.tasks,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: tasks.length,
//       itemBuilder: (context, index) {
//         final task = tasks[index];
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           child: ExpansionTile(
//             title:
//                 Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Due: ${task.dueDate}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () async {
//                     final result = await Navigator.pushNamed(
//                       context,
//                       '/addTask',
//                       arguments: {
//                         'userId': userId,
//                         'task': task,
//                       },
//                     );
//                     if (result == true) {
//                       // Reload tasks if edited
//                       BlocProvider.of<TaskBloc>(context)
//                           .add(LoadTasksEvent(userId));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Task updated successfully')));
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     final confirmDelete = await showDialog<bool>(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Delete Task"),
//                         content:
//                             Text("Are you sure you want to delete this task?"),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.of(context).pop(false),
//                             child: Text("Cancel"),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.of(context).pop(true),
//                             child: Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirmDelete == true) {
//                       BlocProvider.of<TaskBloc>(context)
//                           .add(DeleteTaskEvent(task.taskId, userId));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Task deleted successfully')));
//                     }
//                   },
//                 ),
//               ],
//             ),
//             children: [
//               ListTile(
//                 leading: Icon(Icons.description, color: Colors.grey),
//                 title: Text("Description:",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(task.description),
//               ),
//               ListTile(
//                 leading: Icon(Icons.priority_high, color: Colors.orange),
//                 title: Text("Priority:",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(
//                   "${task.priority.name}",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

//without date modification
// import 'package:flutter/material.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

// class TaskListView extends StatelessWidget {
//   final List<TaskEntity> tasks;
//   final String userId;

//   const TaskListView({
//     Key? key,
//     required this.tasks,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: tasks.length,
//       itemBuilder: (context, index) {
//         final task = tasks[index];
//         return Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//           child: ExpansionTile(
//             tilePadding: EdgeInsets.all(16),
//             title: Text(
//               task.title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black87,
//               ),
//             ),
//             subtitle: Text(
//               'Due: ${task.dueDate}',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () async {
//                     final result = await Navigator.pushNamed(
//                       context,
//                       '/addTask',
//                       arguments: {
//                         'userId': userId,
//                         'task': task,
//                       },
//                     );
//                     if (result == true) {
//                       // Reload tasks if edited
//                       BlocProvider.of<TaskBloc>(context)
//                           .add(LoadTasksEvent(userId));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Task updated successfully')),
//                       );
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     final confirmDelete = await showDialog<bool>(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Delete Task"),
//                         content:
//                             Text("Are you sure you want to delete this task?"),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.of(context).pop(false),
//                             child: Text("Cancel"),
//                           ),
//                           TextButton(
//                             onPressed: () => Navigator.of(context).pop(true),
//                             child: Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );

//                     if (confirmDelete == true) {
//                       BlocProvider.of<TaskBloc>(context)
//                           .add(DeleteTaskEvent(task.taskId, userId));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Task deleted successfully')),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//             children: [
//               ListTile(
//                 leading: Icon(Icons.description, color: Colors.grey),
//                 title: Text(
//                   "Description:",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(task.description),
//               ),
//               ListTile(
//                 leading: Icon(Icons.priority_high, color: Colors.orange),
//                 title: Text(
//                   "Priority:",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   "${task.priority.name}",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

class TaskListView extends StatelessWidget {
  final List<TaskEntity> tasks;
  final String userId;

  const TaskListView({
    Key? key,
    required this.tasks,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        // Format due date to show only the date
        final formattedDueDate =
            DateFormat('EEE, MMM d, y').format(task.dueDate);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(16),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              'Due Date : $formattedDueDate', // Use formatted due date
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/addTask',
                      arguments: {
                        'userId': userId,
                        'task': task,
                      },
                    );
                    if (result == true) {
                      // Reload tasks if edited
                      BlocProvider.of<TaskBloc>(context)
                          .add(LoadTasksEvent(userId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task updated successfully')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Task"),
                        content:
                            Text("Are you sure you want to delete this task?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirmDelete == true) {
                      BlocProvider.of<TaskBloc>(context)
                          .add(DeleteTaskEvent(task.taskId, userId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                              'Task deleted successfully',
                              style: TextStyle(fontSize: 15),
                            ),
                            backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
              ],
            ),
            children: [
              ListTile(
                leading: Icon(Icons.description, color: Colors.grey),
                title: Text(
                  "Description:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(task.description),
              ),
              // ListTile(
              //   leading: Icon(Icons.priority_high, color: Colors.orange),
              //   title: Text.rich(
              //     TextSpan(
              //       children: [
              //         TextSpan(
              //           text: "Priority: ",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         TextSpan(
              //           text: task.priority.name,
              //           style: TextStyle(fontWeight: FontWeight.normal),
              //         ),
              //       ],
              //     ),
              //   ),

              // ),

              ListTile(
                leading: Icon(
                  task.priority == Priority.high
                      ? Icons.error_outline // High priority icon
                      : task.priority == Priority.medium
                          ? Icons.warning // Medium priority icon
                          : Icons.check_circle, // Low priority icon
                  color: task.priority == Priority.high
                      ? Colors.red
                      : task.priority == Priority.medium
                          ? Colors.orange
                          : Colors.green,
                  size: 28,
                ),
                title: Text(
                  "Priority: ${task.priority.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              
              )
            ],
          ),
        );
      },
    );
  }
}
