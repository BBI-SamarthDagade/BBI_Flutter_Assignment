import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    authRepository = AuthRepositoryImpl(mockAuthRemoteDataSource, mockAuthLocalDataSource);
  });

  group('AuthRepositoryImpl', () {
    const testUserId = 'user_1';
    final testAuthEntity = AuthEntity(userId: testUserId);
    
    test('createUser should return an AuthEntity when successful', () async {
      // Arrange : when() mocking the beha createUser
      when(() => mockAuthRemoteDataSource.createUser()).thenAnswer((_) async => testAuthEntity);

      // Act
      final result = await authRepository.createUser();

      // Assert
      expect(result, isA<Right<Failure, AuthEntity>>());
      verify(() => mockAuthRemoteDataSource.createUser()).called(1);
    });

    test('createUser should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.createUser()).thenThrow(Exception('Error creating user'));

      // Act
      final result = await authRepository.createUser();

      // Assert
      expect(result, isA<Left<Failure, AuthEntity>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Unable to Add User');
      verify(() => mockAuthRemoteDataSource.createUser()).called(1);

    });

    test('loginUser should return an AuthEntity when successful', () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.loginUser(testAuthEntity)).thenAnswer((_) async => testAuthEntity);

      // Act
      final result = await authRepository.loginUser(testAuthEntity);

      // Assert
      expect(result, isA<Right<Failure, AuthEntity>>());
      //expect(result.getOrElse((failure) => null), testAuthEntity);
      verify(() => mockAuthRemoteDataSource.loginUser(testAuthEntity)).called(1);
    });

    test('loginUser should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockAuthRemoteDataSource.loginUser(testAuthEntity)).thenThrow(Exception('Error logging in'));

      // Act
      final result = await authRepository.loginUser(testAuthEntity);

      // Assert
      expect(result, isA<Left<Failure, AuthEntity>>());
      expect(result.fold((l) => l.message, (r) => ''), 'unable to Login User');
      verify(() => mockAuthRemoteDataSource.loginUser(testAuthEntity)).called(1);
    });

    test('getUserIdFromLocal should return an AuthEntity when userId is found', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.getUserId()).thenAnswer((_) async => testUserId);

      // Act
      final result = await authRepository.getUserIdFromLocal();

      // Assert
      expect(result, isA<Right<Failure, AuthEntity>>());
      //expect(result.getOrElse((failure) => null)?.userId, testUserId);
      verify(() => mockAuthLocalDataSource.getUserId()).called(1);
    });

    test('getUserIdFromLocal should return a Failure when no userId is found', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.getUserId()).thenAnswer((_) async => null);

      // Act
      final result = await authRepository.getUserIdFromLocal();

      // Assert
      expect(result, isA<Left<Failure, AuthEntity>>());
      expect(result.fold((l) => l.message, (r) => ''), 'unable to get UserId');
      verify(() => mockAuthLocalDataSource.getUserId()).called(1);
    });

    test('getUserIdFromLocal should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.getUserId()).thenThrow(Exception('Error getting userId'));

      // Act
      final result = await authRepository.getUserIdFromLocal();

      // Assert
      expect(result, isA<Left<Failure, AuthEntity>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Error To get User ID from Local Exception: Error getting userId');
      verify(() => mockAuthLocalDataSource.getUserId()).called(1);
    });

    // Test Cases for logout success and failure
    test('logoutUser should return void when successful', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.clearUserId()).thenAnswer((_) async => {});

      // Act
      final result = await authRepository.logoutUser(testAuthEntity);

      // Assert
      expect(result, isA<Right<Failure, void>>());
      verify(() => mockAuthLocalDataSource.clearUserId()).called(1);
    });

    test('logoutUser should return a Failure when an error occurs', () async {
      // Arrange
      when(() => mockAuthLocalDataSource.clearUserId()).thenThrow(Exception('Error clearing userId'));

      // Act
      final result = await authRepository.logoutUser(testAuthEntity);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      expect(result.fold((l) => l.message, (r) => ''), 'Error While Log Out User Exception: Error clearing userId');
      verify(() => mockAuthLocalDataSource.clearUserId()).called(1);
    });
  });
}
