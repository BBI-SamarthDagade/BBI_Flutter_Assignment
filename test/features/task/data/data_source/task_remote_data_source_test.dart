import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';

// Mock classes
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late TaskRemoteDataSourceImplementation remoteDataSource;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockTaskRef;
  late MockDatabaseReference mockTaskChildRef;
  late MockDataSnapshot mockDataSnapshot;

  const testUserId = 'user_1';
  const testTaskId = '-OFLzZqmd35yPy2kU86i';

  final testTask = TaskEntity(
    testTaskId,
    'Test Task',
     'Test task description',
    DateTime.now(),
    Priority.high,
  );

  setUp(() {
    // Initialize mock instances
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockTaskRef = MockDatabaseReference();
    mockTaskChildRef = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();

    // Mock Firebase methods for task-related operations
    when(() => mockFirebaseDatabase.ref('tasks')).thenReturn(mockTaskRef);

    // Initialize the data source with the mocked Firebase
    remoteDataSource = TaskRemoteDataSourceImplementation(mockFirebaseDatabase);

    // Mock the user-specific task reference for task operations
    when(() => mockTaskRef.child(testUserId)).thenReturn(mockTaskRef);
  });

  group('TaskRemoteDataSourceImpl', () {

    test('should add a task successfully', () async {
      // Arrange
      final taskRefe = MockDatabaseReference();
      when(() => mockTaskRef.push()).thenReturn(taskRefe);
      when(() => taskRefe.set(any())).thenAnswer((_) async => Future.value());

      // Act
      await remoteDataSource.addTask(testUserId, testTask);

      // Assert
      verify(() => taskRefe.set(any())).called(1); // Ensure set was called once
    });

    test('should return failure when adding task fails', () async {
      // Arrange
      final taskRefe = MockDatabaseReference();
      when(() => mockTaskRef.push()).thenReturn(taskRefe);
      when(() => taskRefe.set(any())).thenThrow(Exception("Error adding task for user"));

      // Act & Assert
      expect(() async => await remoteDataSource.addTask(testUserId, testTask),
          throwsException); // Expect exception to be thrown
    });
  

    test('should delete a task successfully', () async {
      // Arrange
      when(() => mockTaskRef.child(testTaskId)).thenReturn(mockTaskChildRef);
      when(() => mockTaskChildRef.remove()).thenAnswer((_) async => Future.value());

      // Act
      await remoteDataSource.deleteTask(testTaskId,testUserId);

      // Assert
      verify(() => mockTaskChildRef.remove()).called(1); // Ensure remove was called once
    });

    test('should return failure when deleting task fails', () async {
      // Arrange
      when(() => mockTaskRef.child(testTaskId)).thenReturn(mockTaskChildRef);
      when(() => mockTaskChildRef.remove()).thenThrow(Exception("Failed to delete task"));

      // Act & Assert
      expect(() async => await remoteDataSource.deleteTask(testTaskId,testUserId),
          throwsException); // Expect exception to be thrown
    });

    test('should edit a task successfully', () async {
      // Arrange
      when(() => mockTaskRef.child(testTaskId)).thenReturn(mockTaskChildRef);
      when(() => mockTaskChildRef.update(any())).thenAnswer((_) async => Future.value());

      // Act
      await remoteDataSource.updateTask(testUserId, testTask);

      // Assert
      verify(() => mockTaskChildRef.update(any())).called(1); // Ensure update was called once
    });

    test('should return failure when editing task fails', () async {
      // Arrange
      when(() => mockTaskRef.child(testTaskId)).thenReturn(mockTaskChildRef);
      when(() => mockTaskChildRef.update(any())).thenThrow(Exception("Failed to update task"));

      // Act & Assert
      expect(() async => await remoteDataSource.updateTask(testUserId, testTask),
          throwsException); // Expect exception to be thrown
    });

    test('should fetch all tasks successfully', () async {
      // Arrange
      final tasksMap = {
        '-OFLzZqmd35yPy2kU86i': {
          'description': 'Test task description',
          'dueDate': DateTime.now().toIso8601String(),
          'priority': 'high',
          'title': 'Test Task'
        },
      };
      when(() => mockTaskRef.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);
      when(() => mockDataSnapshot.value).thenReturn(tasksMap);

      // Act
      final result = await remoteDataSource.getTasks(testUserId);

      // Assert
      expect(result.length, 1);  // Expect one task
      expect(result[0].title, 'Test Task');  // Check the title of the task
    });

    test('should return failure when fetching tasks fails', () async {
      // Arrange
      when(() => mockTaskRef.get()).thenThrow(Exception("Failed to fetch tasks"));

      // Act & Assert
      expect(() async => await remoteDataSource.getTasks(testUserId),
          throwsException); // Expect exception to be thrown
    });
  });
}
