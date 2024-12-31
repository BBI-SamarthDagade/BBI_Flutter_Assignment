import 'package:taskapp/features/task/domain/entities/task_entity.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  TaskLoaded(this.tasks);
}

class TaskDeleteSuccess extends TaskState{}

class TaskUpdateSuccess extends TaskState{}

class TaskFailure extends TaskState{
   final String message;

   TaskFailure(this.message);
}

class TaskGetSuccess extends TaskState{
  final List<TaskEntity> tasks;

  TaskGetSuccess(this.tasks);
}