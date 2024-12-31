import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  DateTime? _dueDate;
  Priority _priority = Priority.low;

  @override
  Widget build(BuildContext context) {
    final TaskEntity? task = ModalRoute.of(context)?.settings.arguments as TaskEntity?;
    final bool isEditing = task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: task?.title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                initialValue: task?.description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                initialValue: task?.dueDate.toIso8601String(),
                decoration: InputDecoration(labelText: 'Due Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Due date is required';
                  }
                  final date = DateTime.tryParse(value);
                  if (date == null || date.isBefore(DateTime.now())) {
                    return 'Enter a valid future date';
                  }
                  return null;
                },
                onSaved: (value) => _dueDate = DateTime.parse(value!),
              ),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.name.capitalize()),
                  );
                }).toList(),
                onChanged: (value) => _priority = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final newTask = TaskEntity(
                      task?.taskId ?? UniqueKey().toString(),
                      _title!,
                      _description!,
                      _dueDate!,
                      _priority,
                    );

                    if (isEditing) {
                      BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(newTask, 'userId'));
                    } else {
                      BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask, 'userId'));
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? 'Update Task' : 'Add Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
