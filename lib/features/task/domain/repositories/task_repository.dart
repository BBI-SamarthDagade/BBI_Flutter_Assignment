import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';

abstract class TaskRepository {
  // Adds a new task.
  Future<Either<Failure, void>> addTask(TaskEntity task, String userId);

  // Deletes a task by its ID.
  Future<Either<Failure, void>> deleteTask(String taskId, String userId);

  // Updates an existing task.
  Future<Either<Failure, void>> updateTask(TaskEntity task, String userId);

  // Retrieves all tasks.
  Future<Either<Failure, List<TaskEntity>>> getAllTasks(String userId);
}
