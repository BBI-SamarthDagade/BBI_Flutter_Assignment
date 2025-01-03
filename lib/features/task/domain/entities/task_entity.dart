import 'package:equatable/equatable.dart';


// Define the Priority enum
enum Priority { low, medium, high }

class TaskEntity extends Equatable {
  String taskId; // Unique identifier for the task
  String title;
  String description;
  DateTime dueDate;
  Priority priority; // Use the Priority enum

  TaskEntity(
      this.taskId, this.title, this.description, this.dueDate, this.priority);

  // Convert TaskEntity to a Map
  Map<String, dynamic> toMap() {
    return {
      //'id': taskId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(), // Store as ISO 8601 string
      'priority': priority.name, // Store enum as its name
    };
  }



  // Convert a Map to a TaskEntity object
  factory TaskEntity.fromMap(Map<dynamic, dynamic> map,String id) {
    return TaskEntity(
      id, 
      map['title'],
      map['description'],
      DateTime.parse(map['dueDate']), 
      Priority.values
          .firstWhere((e) => e.name == map['priority']), // Match enum by name
    );
  }

  @override
  List<Object?> get props => [taskId, title, description, dueDate, priority];
}
