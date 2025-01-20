import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> signUpWithEmail(AuthEntity authEntity);
  Future<Either<Failure, User?>> signInWithEmail(AuthEntity authEntity);
  Future<Either<Failure, User?>> continueWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, String?>> getUserIdFromLocal();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
