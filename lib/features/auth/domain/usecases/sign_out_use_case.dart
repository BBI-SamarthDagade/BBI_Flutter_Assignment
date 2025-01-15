import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<Either<Failure, void>> call(){
    return authRepository.signOut();
  }
}