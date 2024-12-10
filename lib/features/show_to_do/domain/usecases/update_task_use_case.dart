import 'package:fpdart/fpdart.dart' hide Task;
import 'package:to_do_list_clean_arch/core/error/failure.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/repository/task_repo.dart';

class UpdateTaskUseCase {
  final TaskRepository taskRepository;

  UpdateTaskUseCase(this.taskRepository);

  Future<Either<Failure, void>> call(Task task) {
    return taskRepository.updateTask(task);
  }
}
