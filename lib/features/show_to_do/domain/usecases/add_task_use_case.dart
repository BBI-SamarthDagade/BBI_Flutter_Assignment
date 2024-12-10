import 'package:fpdart/fpdart.dart' hide Task;
import 'package:to_do_list_clean_arch/core/error/failure.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/repository/task_repo.dart';

class AddTaskUseCase {
  final TaskRepository taskRepository;

  AddTaskUseCase(this.taskRepository);

  Future<Either<Failure, void>> call(Task task) {
    return taskRepository.addTask(task);
  }
  
}
