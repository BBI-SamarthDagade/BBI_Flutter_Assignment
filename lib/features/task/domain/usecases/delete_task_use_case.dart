import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
class DeleteTaskUseCase {
    final TaskRepository taskRepositoryImpl;

    DeleteTaskUseCase(this.taskRepositoryImpl);

    Future<Either<Failure, void>> call(String userId, String taskId){
        return taskRepositoryImpl.deleteTask(userId, taskId);
    }
}
