import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User?> signUpWithEmail(AuthEntity authEntity);
  Future<User?> continueWithGoogle();
  Future<User?> signInWithEmail(AuthEntity authEntity);
  Future<void> signOut();
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
    // try {
    //   // Attempt to sign in the user using Google Sign-In
    //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    //   // If the user cancels the Google sign-in process, return null.
    //   if (googleUser == null) {
    //     return null;
    //   }

    //   //retrive the authentication details (access token and ID token ) from signed-in Google User.
    //   final GoogleSignInAuthentication googleAuth =
    //       await googleUser.authentication;

    //   // Create Firebase credentials using the Google authentication tokens.
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken:
    //         googleAuth.accessToken, // Access token for the Google user.
    //     idToken: googleAuth.idToken, // ID token for the Google user.
    //   );

    //   // Use the generated credentials to sign in with Firebase Authentication.
    //   UserCredential userCredential =
    //       await _firebaseAuth.signInWithCredential(credential);

    //   await _authLocalDataSource.saveUserId(userCredential.user!.uid);

    //   return userCredential.user;
    // } catch (e) {
    //   throw e;
    // }

    var user = await _firebaseAuth.signInWithProvider(_googleAuthProvider);

    return _firebaseAuth.currentUser;

    // try {
    //   var user = await _firebaseAuth.signInWithProvider(_googleAuthProvider);

    //   if (user == null) {
    //     return Left(Failure('Google sign-in aborted'));
    //   }

    //   if (user != null) {
    //     await _authLocalDataSource.saveUserId(_firebaseAuth.currentUser!.uid);
    //   }

    //   return Right(_firebaseAuth.currentUser!);

    // } catch (e) {
    //   return Left(Failure(e.toString()));
    // }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      // await _googleSignIn.signOut();
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
}
