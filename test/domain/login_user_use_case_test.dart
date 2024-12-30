import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/login_user_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUserUseCase loginUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUserUseCase = LoginUserUseCase(mockAuthRepository);
  });

  group('LoginUserUseCase', () {
   
    test('should return AuthEntity on successful login', () async {
      // Arrange
      final authEntity = AuthEntity(userId: "user_1");
      when(() => mockAuthRepository.loginUser(authEntity))
          .thenAnswer((_) async => Right(authEntity));

      // Act
      final result = await loginUserUseCase.call(authEntity);

      // Assert
      expect(result, Right(authEntity));
      verify(() => mockAuthRepository.loginUser(authEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure on login failure', () async {
      // Arrange
      final authEntity = AuthEntity(userId: "user_1");
      final failure = Failure(message: "Failed To Login");
      when(() => mockAuthRepository.loginUser(authEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await loginUserUseCase.call(authEntity);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.loginUser(authEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
