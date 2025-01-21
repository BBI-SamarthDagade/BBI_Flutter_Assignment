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

//   Future<User?> signInWithEmail(AuthEntity authEntity) async {
//   try {
//     // Attempt to sign in the user
//     UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//       email: authEntity.email!,
//       password: authEntity.password!,
//     );

//     User? user = userCredential.user;
//      print(user!.emailVerified);
//     if (user != null) {
//       // Reload the user to ensure the latest verification status
//       await user.reload();

//       // Check if the user's email is verified
//       if (!user.emailVerified) {
//         throw Exception("Email is not verified. Please verify your email to log in.");
//       }

//       // Save the user ID locally if verified
//       await _authLocalDataSource.saveUserId(user.uid);

//       return user;
//     } else {
//       throw Exception("Sign-in failed. User not found.");
//     }
//   } catch (e) {
//     throw Exception("Error during sign-in: ${e.toString()}");
//   }
// }


  @override
  Future<User?> continueWithGoogle() async {
    var user = await _firebaseAuth.signInWithProvider(_googleAuthProvider);

    if (user != null) {
      await _authLocalDataSource.saveUserId(_firebaseAuth.currentUser!.uid);
    }

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
//    Future<User?> signUpWithEmail(AuthEntity authEntity) async {
//   try {
//     // Sign up the user
//     UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//       email: authEntity.email!,
//       password: authEntity.password!,
//     );

//     User? user = userCredential.user;

//     if (user != null) {
//       // Send verification email
//       await user.sendEmailVerification();

//       // Check if email is verified
//       // if (!user.emailVerified) {
//       //   throw Exception("Email is not verified. Please verify your email.");
//       // }
    

//       // Save user ID locally if verified
//       await _authLocalDataSource.saveUserId(user.uid);
//       return user;
//     } else {
//       throw Exception("User creation failed.");
//     }
//   } catch (e) {
//     throw Exception("Error during sign-up: ${e.toString()}");
//   }
// }


  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
