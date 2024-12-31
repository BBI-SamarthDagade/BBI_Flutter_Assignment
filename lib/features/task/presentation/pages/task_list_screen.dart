import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/task/data/datasources/task_local_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/task_page.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _sortByDueDate = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent('userId'));
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
        title: Text('Task Manager'),
        actions: [
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
          )
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            List<TaskEntity> tasks = state.tasks;

            if (!_sortByDueDate) {
              tasks
                  .sort((a, b) => a.priority.index.compareTo(b.priority.index));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.taskId),
                  onDismissed: (_) {
                    BlocProvider.of<TaskBloc>(context)
                        .add(DeleteTaskEvent(task.taskId, 'userId'));
                  },
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                        'Due: ${task.dueDate} | Priority: ${task.priority.name}'),
                    onTap: () {
                      // Navigator.pushNamed(context, '/addTask', arguments: task);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTaskScreen()),
                      );
                    },
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
          //Navigator.pushNamed(context, '/addTask');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
