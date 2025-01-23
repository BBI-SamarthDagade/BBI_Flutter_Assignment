import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthLocalDataSource authLocalDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, User?>> continueWithGoogle() async {
    try {
      final user = await authRemoteDataSource.continueWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(
        Failure(message: "Unable to Log in By user : ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithEmail(AuthEntity authEntity) async{
    try {
      final user = await authRemoteDataSource.signInWithEmail(authEntity);
      return Right(user);
    } catch (e) {
       return Left(Failure(message: "Unable to Sign in With Email : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async{
    try {
      await authRemoteDataSource.signOut();
      return Right(null);
    } catch (e) {
      return Left(Failure(message: "Failed to Sign Out : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User?>> signUpWithEmail(AuthEntity authEntity) async{
    try {
      final user = await authRemoteDataSource.signUpWithEmail(authEntity);
      return Right(user);
    } catch (e) {
      return Left(Failure(message: "Failed to sign up with Email : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Failure, String?>> getUserIdFromLocal() async {
     
    try {
      final user = await authLocalDataSource.getUserId();
      return Right(user);
    } catch (e) {
      return Left(Failure(message: "Failed to sign up with Email : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async{
     try {
       await authRemoteDataSource.sendPasswordResetEmail(email);
       return Right(null);
     } catch (e) {
       return Left(Failure(message: "Failed to Send password Reset Email : ${e.toString()}"));
     }
  }
 
 
 
}



// import 'package:ecommerce/core/error/failures.dart';
// import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:ecommerce/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
// import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fpdart/fpdart.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   AuthRemoteDataSource authRemoteDataSource;
//   AuthLocalDataSource authLocalDataSource;

//   AuthRepositoryImpl(this.authLocalDataSource, this.authRemoteDataSource);

//   @override
//   Future<Either<Failure, User?>> continueWithGoogle() async {
//     try {
//       final user = await authRemoteDataSource.continueWithGoogle();
//       if (user != null) {
//         await authLocalDataSource.saveUserId(FirebaseAuth.instance.currentUser!.uid);
//         return Right(user);
//       } else {
//         return Left(Failure(message: 'Google sign-in was canceled.'));
//       }
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, User?>> signInWithEmail(AuthEntity authEntity) async {
//     try {
//       final user = await authRemoteDataSource.signInWithEmail(authEntity);
//       if (user != null) {
//         await authLocalDataSource.saveUserId(FirebaseAuth.instance.currentUser!.uid);
//         return Right(user);
//       } else {
//         return Left(Failure(message: 'Failed to sign in with email.'));
//       }
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await authRemoteDataSource.signOut();
//       await authLocalDataSource.clearUserId();
//       return Right(null);
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, User?>> signUpWithEmail(AuthEntity authEntity) async {
//     try {
//       final user = await authRemoteDataSource.signUpWithEmail(authEntity);
//       if (user != null) {
//         await authLocalDataSource.saveUserId(FirebaseAuth.instance.currentUser!.uid);
//         return Right(user);
//       } else {
//         return Left(Failure(message: 'Failed to sign up with email.'));
//       }
//     } catch (e) {
//       return Left(Failure(message: e.toString()));
//     }
//   }
// }
