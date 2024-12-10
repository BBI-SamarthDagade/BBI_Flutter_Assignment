
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';

abstract class TaskEvent {}


class TaskAdd extends TaskEvent{
  final String title; 
   
  TaskAdd({
    required this.title
  });

}

  class GetAllTasks extends TaskEvent{}

  class UpdateTask extends TaskEvent{
     final Task task;
     
     UpdateTask({required this.task});
  }

  class DeleteTask extends TaskEvent{
    final int index;

    DeleteTask({required this.index});
  }