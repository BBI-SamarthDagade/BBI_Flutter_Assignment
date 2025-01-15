import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class ContinueWithGoogleUseCase {
  final AuthRepository authRepository;

  ContinueWithGoogleUseCase(this.authRepository);

   Future<Either<Failure, User?>> call(){
     return authRepository.continueWithGoogle();
   }
}