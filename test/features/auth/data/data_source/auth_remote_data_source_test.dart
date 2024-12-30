import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/auth/presentation/pages/login_screen.dart';
// Mock class for DataSnapshot
class MockDataSnapshot extends Mock implements DataSnapshot {}

// Mock Firebase app initialization
class MockFirebaseApp extends Mock implements FirebaseApp {}

void main() {
  late AuthRemoteDataSourceImplementation authRemoteDataSource;
  late MockDatabaseReference mockUserCounterRef;
  late MockDatabaseReference mockUsersRef;
  late MockDataSnapshot mockUserCountSnapshot;
  late MockDataSnapshot mockUserSnapshot;

  setUpAll(() async {
    // Mock Firebase initialization
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  setUp(() {
    mockUserCounterRef = MockDatabaseReference();
    mockUsersRef = MockDatabaseReference();
    authRemoteDataSource = AuthRemoteDataSourceImplementation();

    // Create mock snapshots
    mockUserCountSnapshot = MockDataSnapshot();
    mockUserSnapshot = MockDataSnapshot();
  });

  group('AuthRemoteDataSourceImplementation', () {
    final testUserId = 'user_1';
    final testAuthEntity = AuthEntity(userId: testUserId);

    test('createUser should create a new user successfully', () async {
      // Arrange
      when(() => mockUserCounterRef.get()).thenAnswer((_) async => mockUserCountSnapshot);
      when(() => mockUserCountSnapshot.exists).thenReturn(true);
      when(() => mockUserCountSnapshot.value).thenReturn(1);

      when(() => mockUserCounterRef.set(any())).thenAnswer((_) async => {});
      when(() => mockUsersRef.child(testUserId).set(any())).thenAnswer((_) async => {});

      // Act
      final result = await authRemoteDataSource.createUser();

      // Assert
      expect(result, isA<AuthEntity>());
      expect(result.userId, testUserId);
      verify(() => mockUserCounterRef.get()).called(1);
      verify(() => mockUserCounterRef.set(2)).called(1);
      verify(() => mockUsersRef.child(testUserId).set(any())).called(1);
    });

    test('createUser should throw an exception on failure', () async {
      // Arrange
      when(() => mockUserCounterRef.get()).thenThrow(Exception('Failed to get user count'));

      // Act & Assert
      expect(() async => await authRemoteDataSource.createUser(),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to create user'))));
    });

    test('loginUser should return user on successful login', () async {
      // Arrange
      when(() => mockUsersRef.child(testAuthEntity.userId).get()).thenAnswer((_) async => mockUserSnapshot);
      when(() => mockUserSnapshot.exists).thenReturn(true);
      when(() => mockUserSnapshot.value).thenReturn({'userId': testAuthEntity.userId});

      // Act
      final result = await authRemoteDataSource.loginUser(testAuthEntity);

      // Assert
      expect(result, isA<AuthEntity>());
      expect(result.userId, testUserId);
      verify(() => mockUsersRef.child(testAuthEntity.userId).get()).called(1);
    });

    test('loginUser should throw an exception if user does not exist', () async {
      // Arrange
      when(() => mockUsersRef.child(testAuthEntity.userId).get()).thenAnswer((_) async => mockUserSnapshot);
      when(() => mockUserSnapshot.exists).thenReturn(false);

      // Act & Assert
      expect(() async => await authRemoteDataSource.loginUser(testAuthEntity),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('User not registered'))));
    });

    test('loginUser should throw an exception on failure', () async {
      // Arrange
      when(() => mockUsersRef.child(testAuthEntity.userId).get()).thenThrow(Exception('Failed to login'));

      // Act & Assert
      expect(() async => await authRemoteDataSource.loginUser(testAuthEntity),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to login'))));
    });
  });
}