// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
// import 'package:taskapp/features/task/presentation/widgets/task_list_view.dart';
// import 'package:taskapp/features/task/presentation/widgets/user_menu_widget.dart';

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
//         title: Text(
//           "${greeting()}, ${widget.userId}!",
//           style: TextStyle(
//             fontSize: 20, // Increase font size for prominence
//             fontWeight: FontWeight.bold, // Make it bold
//             color: Colors.indigoAccent, // Use a premium color
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(
//                 _sortByDueDate ? Icons.calendar_today : Icons.sort_by_alpha),
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
//           UserMenu(userId: widget.userId),
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
//               return Center(
//                   child:
//                       Text("No tasks added", style: TextStyle(fontSize: 18)));
//             }

//             return TaskListView(tasks: tasks, userId: widget.userId);
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
//             BlocProvider.of<TaskBloc>(context)
//                 .add(LoadTasksEvent(widget.userId));
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   String greeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return "Good Morning";
//     if (hour < 18) return "Good Afternoon";
//     return "Good Evening";
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/core/utils/constants.dart';
import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/widgets/task_list_view.dart';
import 'package:taskapp/features/task/presentation/widgets/user_menu_widget.dart';

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
        title: Text(
          "${greeting()}, ${widget.userId}!",
          style: TextStyle(
            fontSize: AppConstants.appBarTitleFontSize,
            fontWeight: AppConstants.appBarTitleFontWeight,
            color: AppConstants.appBarTitleColor,
          ),
        ),
       
        automaticallyImplyLeading: false,
        
        actions: [
          
          IconButton(
            icon: Icon(
                _sortByDueDate ? Icons.calendar_today : Icons.sort_by_alpha),
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

          //to show popup menu
          UserMenu(userId: widget.userId),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading Tasks...."),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ));
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
              return Center(
                  child: Text(AppConstants.noTasksMessage,
                      style: TextStyle(fontSize: 18)));
            }

            return TaskListView(tasks: tasks, userId: widget.userId);

          } else if (state is TaskFailure) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
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

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppConstants.greetingMorning;
    if (hour < 18) return AppConstants.greetingAfternoon;
    return AppConstants.greetingEvening;
  }
}
