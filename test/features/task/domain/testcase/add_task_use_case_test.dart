import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
import 'package:taskapp/features/task/domain/usecases/add_task_use_case.dart';

// Mock class for TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late AddTaskUseCase addTaskUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    addTaskUseCase = AddTaskUseCase(mockTaskRepository);
  });

  const String userId = 'user_1';
  final taskEntity = TaskEntity(
    'task_1',
    'Test Task',
    'This is a test task',
    DateTime.now(),
    Priority.high,
  );

  group('AddTaskUseCase', () {
    test('should return void when the task is added successfully', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(taskEntity, userId))
          .thenAnswer((_) async => right(null));

      // Act
      final result = await addTaskUseCase.call(taskEntity, userId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTaskRepository.addTask(taskEntity, userId)).called(1);
    });

    test('should return a Failure when adding the task fails', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(taskEntity, userId)).thenAnswer(
          (_) async => left(Failure(message: 'Failed to add task')));

      // Act
      final result = await addTaskUseCase.call(taskEntity, userId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed to add task');
      verify(() => mockTaskRepository.addTask(taskEntity, userId)).called(1);
    });
  });
}
