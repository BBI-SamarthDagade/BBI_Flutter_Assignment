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

//               Navigator.pushReplacement(
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

//             // Sorting logic
//             if (_sortByDueDate) {
//               tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
//             } else {
//               tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
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
//                   background:  Container(
//                      color: Colors.red,
//                      child: Icon(Icons.delete, color: Colors.white),
//                   ),
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


//named route code
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
// import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';

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
                   
//                    Navigator.pushReplacementNamed(context, '/auth');

//                 // Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
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
//               PopupMenuItem(value: 'Due Date', child: Text('Sort by Due Date')),
//               PopupMenuItem(value: 'Priority', child: Text('Sort by Priority')),
//             ],
//           ),
//         ],
//       ),
//       body: BlocBuilder<TaskBloc, TaskState>(
//         builder: (context, state) {
//           if (state is TaskLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is TaskLoaded) {
//             List<TaskEntity> tasks = state.tasks;

//             // Sorting logic
//             if (_sortByDueDate) {
//               tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
//             } else {
//               tasks
//                   .sort((a, b) => b.priority.index.compareTo(a.priority.index));
//             }

//             if (tasks.isEmpty) {
//               return Center(
//                   child:
//                       Text("No tasks added", style: TextStyle(fontSize: 18)));
//             }

//             return ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return Dismissible(
//                   background: Container(
//                       color: Colors.red,
//                       child: Icon(Icons.delete, color: Colors.white)),
//                   key: Key(task.taskId),
//                   onDismissed: (_) {
//                     BlocProvider.of<TaskBloc>(context)
//                         .add(DeleteTaskEvent(task.taskId, widget.userId));
//                   },
//                   child: Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     child: ExpansionTile(
//                       title: Text(task.title,
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text('Due: ${task.dueDate}'),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildDetailRow(
//                                   icon: Icons.description,
//                                   title: 'Description',
//                                   value: task.description),
//                               SizedBox(height: 16),
//                               _buildDetailRow(
//                                   icon: Icons.priority_high_rounded,
//                                   title: 'Priority',
//                                   value: task.priority.name),
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
//                               Navigator.pushNamed(
//                                 context,
//                                 '/addTask',
//                                 // arguments: {widget.userId, task},
//                                 arguments: {
//                                   'userId': widget.userId,
//                                   'task': task, // pass the task if needed
//                                 },
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
//           Navigator.pushNamed(
//             context,
//             '/addTask',
//             arguments: {
//               'userId': widget.userId,
//               'task': null, // pass the task if needed
//             },
//           ).then((_) {
//             BlocProvider.of<TaskBloc>(context)
//                 .add(LoadTasksEvent(widget.userId));
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//       {required IconData icon, required String title, required String value}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: Colors.blue),
//         SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 4),
//               Text(value),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// working code with all functionality
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
// import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';

// class TaskListScreen extends StatefulWidget {
//   final String userId;

//   TaskListScreen(this.userId);

//   @override
//   _TaskListScreenState createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   bool _sortByDueDate = false;
//   bool _ascendingOrder = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//     BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
//   }

//   void _loadPreferences() async {
//     _sortByDueDate = await SharedPreferencesHelper.getSortByDueDate();
//     _ascendingOrder = await SharedPreferencesHelper.getSortOrder();
//     setState(() {});
//   }

//   void _savePreferences() async {
//     await SharedPreferencesHelper.setSortByDueDate(_sortByDueDate);
//     await SharedPreferencesHelper.setSortOrder(_ascendingOrder);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${widget.userId}"),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(_sortByDueDate ? Icons.calendar_today : Icons.sort_by_alpha),
//             tooltip: 'Sort by ${_sortByDueDate ? "Priority" : "Due Date"}',
//             onPressed: () {
//               setState(() {
//                 _sortByDueDate = !_sortByDueDate; // Toggle sort type
//                 _savePreferences();
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               _ascendingOrder ? Icons.arrow_upward : Icons.arrow_downward,
//             ),
//             tooltip: 'Sort ${_ascendingOrder ? "Descending" : "Ascending"}',
//             onPressed: () {
//               setState(() {
//                 _ascendingOrder = !_ascendingOrder; // Toggle sort order
//                 _savePreferences();
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.red),
//             onPressed: () {
//               context.read<AuthBloc>().add(LogoutEvent(AuthEntity(userId: widget.userId)));
//               Navigator.pushReplacementNamed(context, '/auth');
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<TaskBloc, TaskState>(
//         builder: (context, state) {
//           if (state is TaskLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is TaskLoaded) {
//             List<TaskEntity> tasks = state.tasks;

//             // Sorting logic
//             if (_sortByDueDate) {
//               tasks.sort((a, b) => _ascendingOrder
//                   ? a.dueDate.compareTo(b.dueDate)
//                   : b.dueDate.compareTo(a.dueDate));
//             } else {
//               tasks.sort((a, b) => _ascendingOrder
//                   ? a.priority.index.compareTo(b.priority.index)
//                   : b.priority.index.compareTo(a.priority.index));
//             }

//             if (tasks.isEmpty) {
//               return Center(child: Text("No tasks added", style: TextStyle(fontSize: 18)));
//             }

//             return ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                   child: ExpansionTile(
//                     //leading: Icon(Icons.task, color: Colors.blue),
//                     title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Text('Due: ${task.dueDate}'),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () async {
//                             final result = await Navigator.pushNamed(
//                               context,
//                               '/addTask',
//                               arguments: {
//                                 'userId': widget.userId,
//                                 'task': task,
//                               },
//                             );
//                             if (result == true) {
//                               // Reload tasks if edited
//                               BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated successfully')));
//                             }
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () async {
//                             final confirmDelete = await showDialog<bool>(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: Text("Delete Task"),
//                                 content: Text("Are you sure you want to delete this task?"),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.of(context).pop(false),
//                                     child: Text("Cancel"),
//                                   ),
//                                   TextButton(
//                                     onPressed: () => Navigator.of(context).pop(true),
//                                     child: Text("Delete"),
//                                   ),
//                                 ],
//                               ),
//                             );

//                             if (confirmDelete == true) {
//                               BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(task.taskId, widget.userId));
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task deleted successfully')));
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.description, color: Colors.grey),
//                         title: Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
//                         subtitle: Text(task.description),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.priority_high, color: Colors.orange),
//                         title: Text("Priority: ${task.priority.name}", style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                     ],
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
//           Navigator.pushNamed(
//             context,
//             '/addTask',
//             arguments: {
//               'userId': widget.userId,
//               'task': null,
//             },
//           ).then((_) {
//             // Reload tasks after adding
//             BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';

class TaskListScreen extends StatefulWidget {
  final String userId;

  TaskListScreen(this.userId);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _sortByDueDate = false;
  bool _ascendingOrder = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
  }

  void _loadPreferences() async {
    _sortByDueDate = await SharedPreferencesHelper.getSortByDueDate();
    _ascendingOrder = await SharedPreferencesHelper.getSortOrder();
    setState(() {});
  }

  void _savePreferences() async {
    await SharedPreferencesHelper.setSortByDueDate(_sortByDueDate);
    await SharedPreferencesHelper.setSortOrder(_ascendingOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userId}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_sortByDueDate ? Icons.calendar_today : Icons.sort_by_alpha),
            tooltip: 'Sort by ${_sortByDueDate ? "Priority" : "Due Date"}',
            onPressed: () {
              setState(() {
                _sortByDueDate = !_sortByDueDate; // Toggle sort type
                _savePreferences();
              });
            },
          ),
          IconButton(
            icon: Icon(
              _ascendingOrder ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: 'Sort ${_ascendingOrder ? "Descending" : "Ascending"}',
            onPressed: () {
              setState(() {
                _ascendingOrder = !_ascendingOrder; // Toggle sort order
                _savePreferences();
              });
            },
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              child: Text(widget.userId[0].toUpperCase()), // First letter of the username
            ),
            onSelected: (value) {
              if (value == 'sign_out') {
                context.read<AuthBloc>().add(LogoutEvent(AuthEntity(userId: widget.userId)));
                Navigator.pushReplacementNamed(context, '/auth');
              } else if (value == 'profile') {
                Navigator.pushNamed(context, '/profile', arguments: widget.userId);
              } else if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              } else if (value == 'help') {
                Navigator.pushNamed(context, '/help');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'user_name',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(widget.userId), // Display user's name
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'help',
                  child: Row(
                    children: [
                      Icon(Icons.help, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text('Help'),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'sign_out',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            List<TaskEntity> tasks = state.tasks;

            // Sorting logic
            if (_sortByDueDate) {
              tasks.sort((a, b) => _ascendingOrder
                  ? a.dueDate.compareTo(b.dueDate)
                  : b.dueDate.compareTo(a.dueDate));
            } else {
              tasks.sort((a, b) => _ascendingOrder
                  ? a.priority.index.compareTo(b.priority.index)
                  : b.priority.index.compareTo(a.priority.index));
            }

            if (tasks.isEmpty) {
              return Center(child: Text("No tasks added", style: TextStyle(fontSize: 18)));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ExpansionTile(
                    title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Due: ${task.dueDate}'),
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
                                'userId': widget.userId,
                                'task': task,
                              },
                            );
                            if (result == true) {
                              // Reload tasks if edited
                              BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated successfully')));
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
                                content: Text("Are you sure you want to delete this task?"),
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
                              BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(task.taskId, widget.userId));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task deleted successfully')));
                            }
                          },
                        ),
                      ],
                    ),
                    children: [
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.grey),
                        title: Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(task.description),
                      ),
                      ListTile(
                        leading: Icon(Icons.priority_high, color: Colors.orange),
                        title: Text("Priority: ${task.priority.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
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
          Navigator.pushNamed(
            context,
            '/addTask',
            arguments: {
              'userId': widget.userId,
              'task': null,
            },
          ).then((_) {
            // Reload tasks after adding
            BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
