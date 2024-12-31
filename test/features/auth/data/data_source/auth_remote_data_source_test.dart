import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
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
    when(() => mockFirebaseDatabase.ref('Users')).thenReturn(mockUserRef);
    when(() => mockFirebaseDatabase.ref('Usercount')).thenReturn(mockUserCountRef);

    dataSource = AuthRemoteDataSourceImplementation(mockAuthLocalDataSource);
  });

  group('createUser', () {


test('should create user successfully and save user ID locally', () async {
  // Arrange
  // Mock the user count reference to return a value of 1
  when(() => mockUserCountRef.get()).thenAnswer((_) async => DataSnapshotMock(value: 1));
  
  // Mock the set call for user count increment
  when(() => mockUserCountRef.set(any())).thenAnswer((_) async => Future.value());
  
  // Mock the usersRef.child call to return a mock DatabaseReference
  final mockDatabaseReference = MockDatabaseReference();
  
  when(() => mockUserRef.child('user_2')).thenReturn(mockDatabaseReference);
  
  // Mock the set method on the DatabaseReference to return a Future<void>
  when(() => mockDatabaseReference.set(any())).thenAnswer((_) async => Future.value());
  
  // Mock saving the user ID locally
  when(() => mockAuthLocalDataSource.saveUserId(any())).thenAnswer((_) async => Future.value());

  // Act
  final result = await dataSource.createUser();

  // Assert
  // result.fold(
  //   (failure) {
  //     print(failure.message);
  //     fail('Expected a user model, but got a failure');
  //   },
  //   (userModel) {
  //     expect(userModel.userId, 'user_2');  // The expected user ID after the first user is created
  //     verify(() => mockAuthLocalDataSource.saveUserId('user_2')).called(1);  // Verify saving user ID
  //   },
  // );
});

   

    test('should return Failure when there is an error', () async {
      // Arrange
      when(() => mockUserCountRef.get()).thenThrow(Exception('Database error'));

      // Act
      final result = await dataSource.createUser();

      // Assert
      // expect(result.isLeft(), true);
      // result.fold(
      //   (failure) => expect(failure.message, 'Failed to create user: Exception: Database error'),
      //   (userModel) => fail('Expected failure but got success'),
      // );

    });
  });


  group('loginUser', () {
    test('should login user successfully and save user ID locally', () async {
      // Arrange
      final user = AuthEntity(userId: 'user_1');
      // Mock child method to return a mock `DatabaseReference`
      when(() => mockUserRef.child(user.userId)).thenReturn(mockUserRef);
      // Mock the get method on `DatabaseReference` to return a valid DataSnapshot
      when(() => mockUserRef.get()).thenAnswer((_) async => DataSnapshotMock(value: {'user_1': {}}));
      when(() => mockAuthLocalDataSource.saveUserId(user.userId)).thenAnswer((_) async => Future.value());

      // Act
      final result = await dataSource.loginUser(user);

      // Assert
      // expect(result.isRight(), true);
      // result.fold(
      //   (failure) => fail('Expected success but got failure: $failure'),
      //   (userModel) {
      //     expect(userModel.userId, 'user_1');
      //     verify(() => mockAuthLocalDataSource.saveUserId('user_1')).called(1);
      //   },
      //);
    });

    test('should return Failure if user does not exist', () async {
      // Arrange
      final user = AuthEntity(userId: 'user_1');
      when(() => mockUserRef.child(user.userId)).thenReturn(mockUserRef);
      when(() => mockUserRef.get()).thenAnswer((_) async => DataSnapshotMock(value: null));

      // Act
      final result = await dataSource.loginUser(user);

      // Assert
      // expect(result.isLeft(), true);
      // result.fold(
      //   (failure) => expect(failure.message, 'User not registered'),
      //   (userModel) => fail('Expected failure but got success'),
      // );
    });

    test('should return Failure when there is an error', () async {
      // Arrange
      final user = AuthEntity(userId: 'user_1');
      when(() => mockUserRef.child(user.userId)).thenReturn(mockUserRef);
      when(() => mockUserRef.get()).thenThrow(Exception('Database error'));

      // Act
      final result = await dataSource.loginUser(user);

      // Assert
      // expect(result.isLeft(), true);
      // result.fold(
      //   (failure) => expect(failure.message, 'Failed to login: Exception: Database error'),
      //   (userModel) => fail('Expected failure but got success'),
      // );
    });
  });
}

// Mock class to simulate DataSnapshot behavior
class DataSnapshotMock extends Mock implements DataSnapshot {
  final dynamic _mockValue;  // Renaming the field to avoid conflict

  DataSnapshotMock({required dynamic value}) : _mockValue = value;

  @override
  dynamic get value => _mockValue;

  @override
  bool get exists => _mockValue != null;
}

