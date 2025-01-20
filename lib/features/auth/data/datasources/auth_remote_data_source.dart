import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signUpWithEmail(AuthEntity authEntity);
  Future<User?> continueWithGoogle();
  Future<User?> signInWithEmail(AuthEntity authEntity);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  // final GoogleSignIn _googleSignIn;
  final GoogleAuthProvider _googleAuthProvider;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRemoteDataSourceImpl(
      this._firebaseAuth, this._googleAuthProvider, this._authLocalDataSource);

  @override
  Future<User?> signInWithEmail(AuthEntity authEntity) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: authEntity.email!,
        password: authEntity.password!,
      );

      await _authLocalDataSource.saveUserId(userCredential.user!.uid);

      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User?> continueWithGoogle() async {
    var user = await _firebaseAuth.signInWithProvider(_googleAuthProvider);

    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      //await _googleSignIn.signOut();
      await _authLocalDataSource.clearUserId();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User?> signUpWithEmail(AuthEntity authEntity) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: authEntity.email!, password: authEntity.password!);
      await _authLocalDataSource.saveUserId(userCredential.user!.uid);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
