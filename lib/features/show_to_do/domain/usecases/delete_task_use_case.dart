import 'package:fpdart/fpdart.dart'hide Task;
import 'package:to_do_list_clean_arch/core/error/failure.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/repository/task_repo.dart';


class DeleteTaskUseCase {
  final TaskRepository taskRepository;

  DeleteTaskUseCase(this.taskRepository);

  Future<Either<Failure, void>> call({required int index}) {
    return taskRepository.deleteTask(index);
  }
}
