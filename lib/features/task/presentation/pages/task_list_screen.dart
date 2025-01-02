// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
// import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
// import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
// import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';

// class TaskListScreen extends StatefulWidget {
//   final String userId;

//   TaskListScreen(this.userId);

//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   bool _sortByDueDate = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//     BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
//   }

//   void _loadPreferences() async {
//     _sortByDueDate = await SharedPreferencesHelper.getSortByDueDate();
//     setState(() {});
//   }

//   void _savePreferences() async {
//     await SharedPreferencesHelper.setSortByDueDate(_sortByDueDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${widget.userId}"),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.red),
//             onPressed: () {
//               context
//                   .read<AuthBloc>()
//                   .add(LogoutEvent(AuthEntity(userId: widget.userId)));

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AuthScreen()),
//               );
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               setState(() {
//                 _sortByDueDate = value == 'Due Date';
//                 _savePreferences();
//               });
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'Due Date',
//                 child: Text('Sort by Due Date'),
//               ),
//               PopupMenuItem(
//                 value: 'Priority',
//                 child: Text('Sort by Priority'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: BlocBuilder<TaskBloc, TaskState>(
//         builder: (context, state) {
//           if (state is TaskLoading) {
//             return AlertDialog(
//               contentPadding: EdgeInsets.all(20),
//               title: Center(
//                 child: Text(
//                   "Loading Tasks.....",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               content: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(width: 20),
//                   Text("Please wait..."),
//                 ],
//               ),
//             );
//           } else if (state is TaskLoaded) {
//             List<TaskEntity> tasks = state.tasks;

//             if (!_sortByDueDate) {
//               tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
//             }

//             if (tasks.isEmpty) {
//               return Center(
//                 child: Text("No tasks added", style: TextStyle(fontSize: 18)),
//               );
//             }

//             return ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return Dismissible(
//                   key: Key(task.taskId),
//                   onDismissed: (_) {
//                     BlocProvider.of<TaskBloc>(context)
//                         .add(DeleteTaskEvent(task.taskId, widget.userId));
//                   },
//                   child: Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     child: ExpansionTile(
//                       title: Text(
//                         task.title,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text('Due: ${task.dueDate}'),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildDetailRow(
//                                 icon: Icons.description,
//                                 title: 'Description',
//                                 value: task.description,
//                               ),
//                               SizedBox(height: 16), // Space between sections
//                               _buildDetailRow(
//                                 icon: Icons.priority_high_rounded,
//                                 title: 'Priority',
//                                 value: task.priority.name,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AddTaskScreen(
//                                     widget.userId,
//                                     task: task,
//                                   ),
//                                 ),
//                               ).then((_) {
//                                 BlocProvider.of<TaskBloc>(context)
//                                     .add(LoadTasksEvent(widget.userId));
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               context.read<TaskBloc>().add(
//                                   DeleteTaskEvent(task.taskId, widget.userId));
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is TaskFailure) {
//             return Center(child: Text(state.message));
//           }
//           return Container();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddTaskScreen(widget.userId),
//             ),
//           ).then((_) {
//             BlocProvider.of<TaskBloc>(context)
//                 .add(LoadTasksEvent(widget.userId));
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildDetailRow({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.blue),
//         SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               Text(value),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';


class TaskListScreen extends StatefulWidget {
  final String userId;

  TaskListScreen(this.userId);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _sortByDueDate = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
  }

  void _loadPreferences() async {
    _sortByDueDate = await SharedPreferencesHelper.getSortByDueDate();
    setState(() {});
  }

  void _savePreferences() async {
    await SharedPreferencesHelper.setSortByDueDate(_sortByDueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userId}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(LogoutEvent(AuthEntity(userId: widget.userId)));

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortByDueDate = value == 'Due Date';
                _savePreferences();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Due Date',
                child: Text('Sort by Due Date'),
              ),
              PopupMenuItem(
                value: 'Priority',
                child: Text('Sort by Priority'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(20),
              title: Center(
                child: Text(
                  "Loading Tasks.....",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Please wait..."),
                ],
              ),
            );
          } else if (state is TaskLoaded) {
            List<TaskEntity> tasks = state.tasks;

            // Sorting logic
            if (_sortByDueDate) {
              tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
            } else {
              tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
            }

            if (tasks.isEmpty) {
              return Center(
                child: Text("No tasks added", style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.taskId),
                  onDismissed: (_) {
                    BlocProvider.of<TaskBloc>(context)
                        .add(DeleteTaskEvent(task.taskId, widget.userId));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ExpansionTile(
                      title: Text(
                        task.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Due: ${task.dueDate}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                icon: Icons.description,
                                title: 'Description',
                                value: task.description,
                              ),
                              SizedBox(height: 16), // Space between sections
                              _buildDetailRow(
                                icon: Icons.priority_high_rounded,
                                title: 'Priority',
                                value: task.priority.name,
                              ),
                            ],
                          ),
                        ),
                      ],
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    widget.userId,
                                    task: task,
                                  ),
                                ),
                              ).then((_) {
                                BlocProvider.of<TaskBloc>(context)
                                    .add(LoadTasksEvent(widget.userId));
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<TaskBloc>().add(
                                  DeleteTaskEvent(task.taskId, widget.userId));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TaskFailure) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(widget.userId),
            ),
          ).then((_) {
            BlocProvider.of<TaskBloc>(context)
                .add(LoadTasksEvent(widget.userId));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
