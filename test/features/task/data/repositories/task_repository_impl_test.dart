import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/data/repositories/task_repository_impl.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';



// Mock class for TaskRemoteDataSource
class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

void main() {
  late TaskRepositoryImplmentation taskRepository;
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;

  setUp(() {
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    taskRepository = TaskRepositoryImplmentation(mockTaskRemoteDataSource);
  });

  const String userId = 'user_1';
  const String taskId = 'task_1';
  final taskEntity = TaskEntity(
    taskId,
    'Test Task',
    'This is a test task',
     DateTime(2024, 1, 7),
     Priority.high,
  );

  group('TaskRepositoryImplmentation', () {
    test('addTask should return void when successful', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.addTask(userId, taskEntity))
          .thenAnswer((_) async => {});

      // Act
      final result = await taskRepository.addTask(taskEntity, userId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTaskRemoteDataSource.addTask(userId, taskEntity)).called(1);
    });

    test('addTask should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.addTask(userId, taskEntity))
          .thenThrow(Exception('Error adding task'));

      // Act
      final result = await taskRepository.addTask(taskEntity, userId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed To Add Task');
      verify(() => mockTaskRemoteDataSource.addTask(userId, taskEntity)).called(1);
    });

    test('deleteTask should return void when successful', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.deleteTask(taskId, userId))
          .thenAnswer((_) async => {});

      // Act
      final result = await taskRepository.deleteTask(taskId, userId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTaskRemoteDataSource.deleteTask(taskId, userId)).called(1);
    });

    test('deleteTask should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.deleteTask(taskId, userId))
          .thenThrow(Exception('Error deleting task'));

      // Act
      final result = await taskRepository.deleteTask(taskId, userId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed To delete Task');
      verify(() => mockTaskRemoteDataSource.deleteTask(taskId, userId)).called(1);
    });

    test('getAllTasks should return a list of TaskEntity when successful', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.getTasks(userId))
          .thenAnswer((_) async => [taskEntity]);

      // Act
      final result = await taskRepository.getAllTasks(userId);

      // Assert
      expect(result, isA<Right<Failure, List<TaskEntity>>>());
      expect(result.getOrElse((failure) => []), [taskEntity]);
      verify(() => mockTaskRemoteDataSource.getTasks(userId)).called(1);
    });

    test('getAllTasks should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.getTasks(userId))
          .thenThrow(Exception('Error getting tasks'));

      // Act
      final result = await taskRepository.getAllTasks(userId);

      // Assert
      expect(result, isA<Left<Failure, List<TaskEntity>>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed To get Tasks');
      verify(() => mockTaskRemoteDataSource.getTasks(userId)).called(1);
    });

    test('updateTask should return void when successful', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.updateTask(userId, taskEntity))
          .thenAnswer((_) async => {});

      // Act
      final result = await taskRepository.updateTask(taskEntity, userId);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockTaskRemoteDataSource.updateTask(userId, taskEntity)).called(1);
    });

    test('updateTask should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockTaskRemoteDataSource.updateTask(userId, taskEntity))
          .thenThrow(Exception('Error updating task'));

      // Act
      final result = await taskRepository.updateTask(taskEntity, userId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Failed To Update Task');
      verify(() => mockTaskRemoteDataSource.updateTask(userId, taskEntity)).called(1);
    });
  });
}
