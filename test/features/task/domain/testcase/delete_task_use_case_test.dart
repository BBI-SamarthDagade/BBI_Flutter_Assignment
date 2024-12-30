import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
import 'package:taskapp/features/task/domain/usecases/delete_task_use_case.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late DeleteTaskUseCase deleteTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTaskUseCase = DeleteTaskUseCase(mockTaskRepository);
  });

  const String userId = 'user_1';
  const String taskId = 'task_1';

  group('DeleteTaskUseCase', () {
    test('should return void when the task is deleted successfully', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(userId, taskId))
          .thenAnswer((_) async => right(null));

      // Act
      final result = await deleteTaskUseCase.call(userId, taskId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTaskRepository.deleteTask(userId, taskId)).called(1);
    });

    test('should return a Failure when deleting the task fails', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(userId, taskId))
          .thenAnswer((_) async => left(Failure(message: 'Failed to delete task')));

      // Act
      final result = await deleteTaskUseCase.call(userId, taskId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed to delete task');
      verify(() => mockTaskRepository.deleteTask(userId, taskId)).called(1);
    });
  });
}
