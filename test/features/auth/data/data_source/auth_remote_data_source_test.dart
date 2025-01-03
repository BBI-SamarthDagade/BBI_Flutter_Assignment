import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

// Mock classes
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRemoteDataSource dataSource;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockUserRef;
  late MockDatabaseReference mockUserCountRef;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();      
    mockUserRef = MockDatabaseReference();
    mockUserCountRef = MockDatabaseReference();
    mockAuthLocalDataSource = MockAuthLocalDataSource();

    // Mocking the `ref` method to return mock `DatabaseReference`
    when(() => mockFirebaseDatabase.ref('user_count')).thenReturn(mockUserCountRef);
    when(() => mockFirebaseDatabase.ref('users')).thenReturn(mockUserRef);

    dataSource = AuthRemoteDataSourceImplementation(mockAuthLocalDataSource, mockFirebaseDatabase);
  });

  group('createUser', () {
    test('should create user successfully and save user ID locally', () async {
      // Arrange
     when(() => mockUserCountRef.get()).thenAnswer((_) async => DataSnapshotMock(value : 1));
     
      when(() => mockUserCountRef.set(any())).thenAnswer((_) async => Future.value());
  
      
      final mockDatabaseReference = MockDatabaseReference();

      when(() => mockUserRef.child('user_2')).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.set(any())).thenAnswer((_) async => Future.value());
      
      when(() => mockAuthLocalDataSource.saveUserId(any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await dataSource.createUser();

      // Assert
    expect(result.userId, 'user_2'); // The expected user ID after the first user is created
      verify(() => mockAuthLocalDataSource.saveUserId('user_2')).called(1); // Verify saving user ID
    });

    test('should throw an exception when unable to create user', () async {
      // Arrange
      when(() => mockUserCountRef.get()).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => dataSource.createUser(), throwsA(isA<Exception>()));
    });
  });

  group('loginUser', () {
    test('should login user successfully and save user ID locally', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_1');
      when(() => mockUserRef.child(authEntity.userId)).thenReturn(mockUserRef);
      when(() => mockUserRef.get()).thenAnswer((_) async => DataSnapshotMock(value: {'user_1': {}}));
       when(() => mockAuthLocalDataSource.saveUserId(authEntity.userId)).thenAnswer((_) async => Future.value());
      // Act
      final result = await dataSource.loginUser(authEntity);

      // Assert
      expect(result.userId, 'user_1'); // Expected logged in user ID
      verify(() => mockAuthLocalDataSource.saveUserId(authEntity.userId)).called(1); // Verify saving user ID
    });

    test('should throw an exception when user is not registered', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_not_exist');
      when(() => mockUserRef.child(authEntity.userId)).thenReturn(mockUserRef);
   //   when(() => mockUserRef.get()).thenAnswer((_) async => DataSnapshotMock()..setExists(false));

      // Act & Assert
      expect(() => dataSource.loginUser(authEntity), throwsA(isA<Exception>()));
    });

    test('should throw an exception when login fails', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_1');
      when(() => mockUserRef.child(authEntity.userId)).thenReturn(mockUserRef);
      when(() => mockUserRef.get()).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => dataSource.loginUser(authEntity), throwsA(isA<Exception>()));
    });
  });
}

class DataSnapshotMock extends Mock implements DataSnapshot {
  final dynamic _mockValue;  // Renaming the field to avoid conflict

  DataSnapshotMock({required dynamic value}) : _mockValue = value;

  @override
  dynamic get value => _mockValue;

  @override
  bool get exists => _mockValue != null;
}