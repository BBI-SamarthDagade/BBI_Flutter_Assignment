import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';

class CreateUserUseCase {

  final AuthRepository authRepositoryImpl;

  CreateUserUseCase(this.authRepositoryImpl);

  Future<Either<Failure, AuthEntity>> call() {
    return authRepositoryImpl.createUser();
  }
  
}
