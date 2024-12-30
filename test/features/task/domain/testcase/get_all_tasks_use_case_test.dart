import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
import 'package:taskapp/features/task/domain/usecases/get_all_tasks_use_case.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late GetAllTasksUseCase getAllTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getAllTasksUseCase = GetAllTasksUseCase(mockTaskRepository);
  });

  const String userId = 'user_1';
  final List<TaskEntity> mockTasks = [
    TaskEntity(
      'task_1',
      'Task 1',
      'This is task 1',
      DateTime.now(),
      Priority.medium,
    ),
    TaskEntity(
      'task_2',
      'Task 2',
      'This is task 2',
      DateTime.now(),
      Priority.high,
    ),
  ];

  group('GetAllTasksUseCase', () {
    test(
        'should return a list of TaskEntity when tasks are retrieved successfully',
        () async {
      // Arrange
      when(() => mockTaskRepository.getAllTasks(userId))
          .thenAnswer((_) async => right(mockTasks));

      // Act
      final result = await getAllTasksUseCase.call(userId);

      // Assert
      expect(result, isA<Right<Failure, List<TaskEntity>>>());
      verify(() => mockTaskRepository.getAllTasks(userId)).called(1);
    });

    test('should return a Failure when retrieving tasks fails', () async {
      // Arrange
      when(() => mockTaskRepository.getAllTasks(userId)).thenAnswer(
          (_) async => left(Failure(message: 'Failed to get tasks')));

      // Act
      final result = await getAllTasksUseCase.call(userId);

      // Assert
      expect(result, isA<Left<Failure, List<TaskEntity>>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed to get tasks');
      verify(() => mockTaskRepository.getAllTasks(userId)).called(1);
    });
  });
}
