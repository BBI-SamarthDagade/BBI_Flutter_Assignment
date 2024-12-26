import 'package:fpdart/src/either.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImplmentation implements TaskRepository {
  TaskRemoteDataSource taskRemoteDataSourceimpl;

  TaskRepositoryImplmentation(this.taskRemoteDataSourceimpl);

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task, String userId) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId, String userId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks(String userId) {
    // TODO: implement getAllTasks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task, String userId) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
