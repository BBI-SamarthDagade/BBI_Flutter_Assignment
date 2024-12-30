 import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/create_user_use_case.dart';

// Mock implementation of AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CreateUserUseCase createUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    createUserUseCase = CreateUserUseCase(mockAuthRepository);
  });

  group('CreateUserUseCase', () {
    test('should return AuthEntity on successful creation of a user', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_1'); // Example AuthEntity
      
      when(() => mockAuthRepository.createUser())
          .thenAnswer((_) async => Right(authEntity));

      // Act
      final result = await createUserUseCase.call();

      // Assert
      expect(result, Right(authEntity));
      verify(() => mockAuthRepository.createUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return a Failure when the creation fails', () async {
      // Arrange
      final failure = Failure(message:  "Failed to Send Message"); // Example Failure
      when(() => mockAuthRepository.createUser())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await createUserUseCase.call();

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.createUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
