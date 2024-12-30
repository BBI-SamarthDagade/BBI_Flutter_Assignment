import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';

// Mock classes
class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late TaskRemoteDataSourceImplementation taskRemoteDataSource;
  late MockDatabaseReference mockDatabaseReference;
  late MockDataSnapshot mockDataSnapshot;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();

    // Mock the instance of FirebaseDatabase to return the mocked DatabaseReference
    when(() => FirebaseDatabase.instance).thenReturn(MockFirebaseDatabase());
    when(() => FirebaseDatabase.instance.ref('tasks')).thenReturn(mockDatabaseReference);

    taskRemoteDataSource = TaskRemoteDataSourceImplementation();
  });

  group('TaskRemoteDataSourceImplementation', () {
    const userId = 'user_1';
    const taskId = 'task_1';
    final taskEntity = TaskEntity( taskId, 'Test Task',  'Test Description',DateTime(2024, 1, 7), Priority.high);

    test('addTask should add a task to the database', () async {
      // Arrange
      final taskRef = mockDatabaseReference.child(userId).child(taskEntity.taskId);
      when(() => taskRef.push()).thenReturn(taskRef);
      when(() => taskRef.set(any())).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.addTask(userId, taskEntity);

      // Assert
      verify(() => taskRef.set(taskEntity.toMap())).called(1);
    });

    test('deleteTask should remove a task from the database', () async {
      // Arrange
      final userTaskRef = mockDatabaseReference.child(userId).child(taskId);
      when(() => userTaskRef.remove()).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.deleteTask(taskId, userId);

      // Assert
      verify(() => userTaskRef.remove()).called(1);
    });

    test('updateTask should update a task in the database', () async {
      // Arrange
      final taskRef = mockDatabaseReference.child(userId).child(taskEntity.taskId);
      when(() => taskRef.update(any())).thenAnswer((_) async {});

      // Act
      await taskRemoteDataSource.updateTask(userId, taskEntity);

      // Assert
      verify(() => taskRef.update(taskEntity.toMap())).called(1);
    });

    test('getTasks should return a list of tasks', () async {
      // Arrange
      when(() => mockDatabaseReference.child(userId)).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);
      when(() => mockDataSnapshot.value).thenReturn({
        'task_1': {'title': 'Task 1', 'description': 'Description 1'},
        'task_2': {'title': 'Task 2', 'description': 'Description 2'},
      });

      // Act
      final result = await taskRemoteDataSource.getTasks(userId);

      // Assert
      expect(result, isA<List<TaskEntity>>());
      expect(result.length, 2);
      expect(result[0].title, 'Task 1');
      expect(result[1].title, 'Task 2');
    });

    test('getTasks should return an empty list if no tasks exist', () async {
      // Arrange
      when(() => mockDatabaseReference.child(userId)).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false);

      // Act
      final result = await taskRemoteDataSource.getTasks(userId);

      // Assert
      expect(result, []);
    });

    test('getTasks should return an empty list on error', () async {
      // Arrange
      when(() => mockDatabaseReference.child(userId)).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenThrow(Exception('Error fetching tasks'));

      // Act
      final result = await taskRemoteDataSource.getTasks(userId);

      // Assert
      expect(result, []);
    });
  });
}
