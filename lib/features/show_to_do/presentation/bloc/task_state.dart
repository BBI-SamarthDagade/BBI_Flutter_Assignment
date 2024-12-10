
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';

abstract class TaskState{}

class TaskInitial extends TaskState{}

class TaskLoading extends TaskState{}

class TaskAddSuccess extends TaskState{
  final List<Task> tasks;

  TaskAddSuccess(this.tasks);
}

class TaskGetSuccess extends TaskState{
  final List<Task> tasks;

  TaskGetSuccess(this.tasks);
}

class TaskDeleteSuccess extends TaskState{}

class TaskUpdateSuccess extends TaskState{}

class TaskFailure extends TaskState{
   final String message;

   TaskFailure(this.message);
}

