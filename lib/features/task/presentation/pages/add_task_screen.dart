// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

// class AddTaskScreen extends StatefulWidget {
//   final String userId;
//   final TaskEntity? task; // Add this parameter for editing

//   AddTaskScreen(this.userId, {this.task});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? _title;
//   String? _description;
//   DateTime? _dueDate;
//   Priority _priority = Priority.low;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       _title = widget.task!.title;
//       _description = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isEditing = widget.task != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Task' : 'Add Task'),

//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: _title,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
//                 onSaved: (value) => _title = value,
//               ),
//               TextFormField(
//                 initialValue: _description,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
//                 onSaved: (value) => _description = value,
//               ),
//               TextFormField(
//                 controller: TextEditingController(
//                   text: _dueDate != null ? _dueDate!.toIso8601String().split('T')[0] : '',
//                 ),
//                 decoration: InputDecoration(
//                   labelText: 'Due Date',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_today),
//                     onPressed: () async {
//                       final pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: _dueDate ?? DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2100),
//                       );

//                       if (pickedDate != null) {
//                         setState(() {
//                           _dueDate = pickedDate;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 validator: (value) {
//                   if (_dueDate == null) {
//                     return 'Due date is required';
//                   }
//                   return null;
//                 },
//               ),
//               DropdownButtonFormField<Priority>(
//                 value: _priority,
//                 decoration: InputDecoration(labelText: 'Priority'),
//                 items: Priority.values.map((priority) {
//                   return DropdownMenuItem(
//                     value: priority,
//                     child: Text(priority.name.capitalize()),
//                   );
//                 }).toList(),
//                 onChanged: (value) => _priority = value!,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     _formKey.currentState?.save();
//                     final newTask = TaskEntity(
//                       widget.task?.taskId ?? UniqueKey().toString(),
//                       _title!,
//                       _description!,
//                       _dueDate!,
//                       _priority,
//                     );

//                     if (isEditing) {
//                       BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(newTask, widget.userId));
//                     } else {
//                       BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask, widget.userId));
//                     }

//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text(isEditing ? 'Update Task' : 'Create Task'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() => this[0].toUpperCase() + substring(1);
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;
  final TaskEntity? task; // Add this parameter for editing

  AddTaskScreen(this.userId, {this.task});

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
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        //backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEditing ? 'Update Task' : 'Create Task',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Title',
                  initialValue: _title,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                  onSaved: (value) => _title = value,
                ),
                _buildTextField(
                  label: 'Description',
                  initialValue: _description,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Description is required'
                      : null,
                  onSaved: (value) => _description = value,
                ),
                _buildDueDateField(),
                _buildPriorityDropdown(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                  
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24), // Padding for a better touch target
                    elevation: 5, // Add elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                  ),
                  child: Text(
                    
                    isEditing ? 'Update Task' : 'Create Task',
                    style: TextStyle(
                      fontSize: 16, // Increased font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDueDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: TextEditingController(
          text:
              _dueDate != null ? _dueDate!.toIso8601String().split('T')[0] : '',
        ),
        decoration: InputDecoration(
          labelText: 'Due Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                setState(() {
                  _dueDate = pickedDate;
                });
              }
            },
          ),
        ),
        validator: (value) {
          if (_dueDate == null) {
            return 'Due date is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Priority>(
        value: _priority,
        decoration: InputDecoration(
          labelText: 'Priority',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
        items: Priority.values.map((priority) {
          return DropdownMenuItem(
            value: priority,
            child: Text(priority.name.capitalize()),
          );
        }).toList(),
        onChanged: (value) => _priority = value!,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newTask = TaskEntity(
        widget.task?.taskId ?? UniqueKey().toString(),
        _title!,
        _description!,
        _dueDate!,
        _priority,
      );

      if (widget.task != null) {
        BlocProvider.of<TaskBloc>(context)
            .add(UpdateTaskEvent(newTask, widget.userId));
      } else {
        BlocProvider.of<TaskBloc>(context)
            .add(AddTaskEvent(newTask, widget.userId));
      }

      Navigator.pop(context);
    }
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
