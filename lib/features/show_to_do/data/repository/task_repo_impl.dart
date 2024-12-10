import 'package:fpdart/fpdart.dart' hide Task;
import 'package:to_do_list_clean_arch/core/error/failure.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/data/data_source/task_local_data_source.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/repository/task_repo.dart';

class TaskRepositoryImplementation implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImplementation({required this.localDataSource});
 
  
  @override
  Future<Either<Failure, void>> addTask(Task task) async{
     try {
      await localDataSource.saveTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to add task'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int index) async {
    print("this is print of task_repo_impl $index");
    try {
      await localDataSource.deleteTask(index);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to delete task'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getAllTasks() async{
   try {
      final tasks = await localDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left(Failure(message: 'Failed to fetch tasks'));
    }

  }

  @override
  Future<Either<Failure, void>> updateTask(Task task) async{
     try {
      await localDataSource.updateTask(task);
      return const Right(null);
    } catch (e) {
      return Left(Failure(message: 'Failed to update task'));
    }
  }

}