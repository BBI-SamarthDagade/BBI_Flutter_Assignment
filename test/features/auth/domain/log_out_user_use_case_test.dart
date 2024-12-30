import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/log_out_user_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogOutUserUseCase logOutUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logOutUserUseCase = LogOutUserUseCase(mockAuthRepository);
  });

  group('LogOutUserUseCase', () {
    test('should return void on successful logout', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_1');
      when(() => mockAuthRepository.logoutUser(authEntity))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await logOutUserUseCase.call(authEntity);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.logoutUser(authEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure on logout failure', () async {
      // Arrange
      final authEntity = AuthEntity(userId: 'user_1');
      final failure = Failure(message: "Failed to Log Out");
      when(() => mockAuthRepository.logoutUser(authEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await logOutUserUseCase.call(authEntity);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.logoutUser(authEntity)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
