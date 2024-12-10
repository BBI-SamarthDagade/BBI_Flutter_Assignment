import 'package:fpdart/fpdart.dart' hide Task;
import 'package:to_do_list_clean_arch/core/error/failure.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';

abstract class TaskRepository {
  // Adds a new task.
  Future<Either<Failure, void>> addTask(Task task);

  // Deletes a task by its ID.
  Future<Either<Failure, void>> deleteTask(int index);

  // Updates an existing task.
  Future<Either<Failure, void>> updateTask(Task task);

  // Retrieves all tasks.
  Future<Either<Failure, List<Task>>> getAllTasks();
}