import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';

class AddTaskUseCase {
    final TaskRepository taskRepositoryImpl;

    AddTaskUseCase(this.taskRepositoryImpl);

    Future<Either<Failure, void>> call(TaskEntity task, String userId){
        return taskRepositoryImpl.addTask(task, userId);
    }
}