import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
abstract class AuthRepository {
  // Add new user
  Future<Either<Failure, AuthEntity>> createUser();

  // Login to user
  Future<Either<Failure, AuthEntity>> loginUser(AuthEntity auth);

  // Get user ID form Local Data Source
  Future<Either<Failure, AuthEntity>>  getUserIdFromLocal();

  //Log Out user
  Future<Either<Failure, void>> logoutUser(AuthEntity auth);
  
}