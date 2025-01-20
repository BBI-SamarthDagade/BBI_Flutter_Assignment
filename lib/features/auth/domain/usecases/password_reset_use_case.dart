import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class PasswordResetUseCase {
  final AuthRepository authRepository;

  PasswordResetUseCase(this.authRepository);

   Future<Either<Failure, void>> call(String email) async {
     return await authRepository.sendPasswordResetEmail(email);
   }
}