import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';

class LogOutUserUseCase {
  AuthRepository authRepositoryImpl;

  LogOutUserUseCase(this.authRepositoryImpl);

   Future<Either<Failure, void>> call(AuthEntity auth) {
    return authRepositoryImpl.logoutUser(auth);
  }
  
}