import 'package:taskapp/features/task/domain/entities/task_entity.dart';

abstract class TaskEvent {

}

class LoadTasksEvent extends TaskEvent {
  final String userId;

  LoadTasksEvent(this.userId);
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;

  AddTaskEvent(this.task, this.userId);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;

  UpdateTaskEvent(this.task, this.userId);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String userId;

  DeleteTaskEvent(this.taskId, this.userId);
}
