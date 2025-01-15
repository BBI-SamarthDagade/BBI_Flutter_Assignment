import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class SignUpWithEmailUseCase {
  AuthRepository authRepository;

  SignUpWithEmailUseCase(this.authRepository);

  Future<Either<Failure,User?>> call(AuthEntity authEntity){
    return authRepository.signUpWithEmail(authEntity);
  }
}