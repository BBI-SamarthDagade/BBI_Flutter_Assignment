 import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/get_user_id_user_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUserIdUseCase getUserIdUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(
    (){
      mockAuthRepository = MockAuthRepository();
      getUserIdUseCase = GetUserIdUseCase(mockAuthRepository);
    }
  );

  group("GetUserIdUseCase", (){

    test("Should return AuthEntity on successful creation of user", 
     () async {
         final authEntity = AuthEntity(userId: 'user_2');
         when(() => mockAuthRepository.getUserIdFromLocal()).thenAnswer((_) async => Right(authEntity));
     
        final result = await getUserIdUseCase.call();

        expect(result, Right(authEntity));
        verify(()=> mockAuthRepository.getUserIdFromLocal()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
     });


     test('should return a Failure when unable to get user ID',
        () async {
           final failure = Failure(message: "Failed to Get User ID");

           when(() => mockAuthRepository.getUserIdFromLocal()).
                    thenAnswer((_) async => Left(failure));

          final result = await getUserIdUseCase.call();

          expect(result, Left(failure));
          verify(() => mockAuthRepository.getUserIdFromLocal()).called(1);
          verifyNoMoreInteractions(mockAuthRepository);
        }
     );
  });
}