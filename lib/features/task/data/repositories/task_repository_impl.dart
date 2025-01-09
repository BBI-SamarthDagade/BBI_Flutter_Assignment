import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImplmentation implements TaskRepository {
  TaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImplmentation(this.taskRemoteDataSource); //assigning instance of TaskRemoteDataSourceImplementation to TaskRemoteDataSource referance which called child class methods

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task, String userId) async{
     try {
       await taskRemoteDataSource.addTask(userId, task);
       return right(null);
     } catch (e) {
        return left(Failure(message: "Failed To Add Task"));
     }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId, String userId) async {
     try {
       await taskRemoteDataSource.deleteTask(taskId, userId);
       return right(null);
     } catch (e) {
        return left(Failure(message: "Failed To delete Task"));
     }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks(String userId) async {
      try {
       final tasks = await taskRemoteDataSource.getTasks(userId);
       return right(tasks);
     } catch (e) {
        return left(Failure(message: "Failed To get Tasks"));
     }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task, String userId) async {
       try {
       await taskRemoteDataSource.updateTask(userId, task);
       return right(null);
     } catch (e) {
        return left(Failure(message: "Failed To Update Task"));
     }
  }
}