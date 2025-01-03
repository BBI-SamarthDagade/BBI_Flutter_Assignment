import 'package:fpdart/fpdart.dart';
import 'package:taskapp/core/error/failures.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> createUser() async {
    try {
      final AuthEntity user = await authRemoteDataSource.createUser();
      return Right(user); // Return the created user
    } catch (e) {
      return Left(Failure( message: "Unable to Add User")); // Return failure in case of error
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginUser(AuthEntity auth) async {
    try {
      final AuthEntity user = await authRemoteDataSource.loginUser(auth);
      return Right(user);
    } catch (e) {
      return Left(Failure(message: "unable to Login User"));
    }
  }
  
  @override
  Future<Either<Failure, AuthEntity>> getUserIdFromLocal() async {
     try {
        final userId = await authLocalDataSource.getUserId();
        if(userId != null){
          return Right(AuthEntity(userId: userId));
        }else{
          return Left(Failure(message: "unable to get UserId"));
        }
     } catch (e) {
        return Left(Failure(message: "Error To get User ID from Local ${e.toString()}"));
     }
  }
  
  @override
  Future<Either<Failure, void>> logoutUser(AuthEntity auth) async{
    print("in logout repo impl ${auth.userId}");
      try {
        await authLocalDataSource.clearUserId();
        return const Right(null);
      } catch (e) {
          return Left(Failure(message: "Error While Log Out User ${e.toString()}"));
      }
  }

  
}
