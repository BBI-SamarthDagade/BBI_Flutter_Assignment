import 'package:equatable/equatable.dart';  //equatable will compare the objects of the class

class Task extends Equatable{
  int index;
  String task;

    Task({required this.task,  required this.index});

  @override   //  props define properties of class which cosidered while compairing the objects or instances of class
  List < Object ? > get props {   //List<Object ?> is return type of props and object ? allows values in props to be null
    return [
       index,
        task,
        
    ];

  }
// props check both instances have same referance if they are not same referance they check values if all the values are same the instances are considered as equal
 
 
 // Convert Task object to a Map
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'task': task,
    };
  }

  // Convert a Map to a Task object
  //factory constructor of Class Task create and instace of Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      index: map['index'],
      task: map['task'],
     
    );
  }

}