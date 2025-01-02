import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
class GetAllTasksUseCase {
    final TaskRepository taskRepositoryImpl;

    GetAllTasksUseCase(this.taskRepositoryImpl);

    Future<Either<Failure, List<TaskEntity>>> call(String userId){
        return taskRepositoryImpl.getAllTasks(userId);
    }
}
