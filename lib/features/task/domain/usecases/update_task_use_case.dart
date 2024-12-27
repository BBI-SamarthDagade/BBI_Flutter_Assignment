import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';


class UpdateTaskUseCase {
    final TaskRepository taskRepositoryImpl;

    UpdateTaskUseCase(this.taskRepositoryImpl);

    Future<Either<Failure, void>> call(TaskEntity task, String userId){
        return taskRepositoryImpl.updateTask(task, userId);
    }
}