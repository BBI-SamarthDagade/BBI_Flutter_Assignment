import 'package:firebase_database/firebase_database.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthEntity> createUser();
  Future<AuthEntity> loginUser(AuthEntity auth);
}

class AuthRemoteDataSourceImplementation extends AuthRemoteDataSource {
  final DatabaseReference _userCounterRef =
      FirebaseDatabase.instance.ref('user_count');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
   
   final AuthLocalDataSource authLocalDataSource;

      AuthRemoteDataSourceImplementation(this.authLocalDataSource);
  @override

  Future<AuthEntity> createUser() async {
    try {
      final snapshot = await _userCounterRef.get();
      final currentUserId = snapshot.exists && snapshot.value != null
          ? (snapshot.value as int)
          : 0;

      final newUserId = 'user_${currentUserId + 1}';
      await _userCounterRef.set(currentUserId + 1);

      // Create a new user in the database
      await _usersRef.child(newUserId).set({
        'userId': newUserId,
      });
       
       
      await authLocalDataSource.saveUserId(newUserId);
      
      return AuthEntity(userId: newUserId);
    } catch (e) {
      print("Unable to create user: $e");

      // Add this line to satisfy the return type
      throw Exception("Failed to create user: $e");
    }
  }



  Future<AuthEntity> loginUser(AuthEntity auth) async {
    try {
      // Retrieve the user data from the database
      final snapshot = await _usersRef.child(auth.userId).get();
        
      if (snapshot.exists) {
        print("User login successful: ${auth.userId}");
        await authLocalDataSource.saveUserId(auth.userId);
        return auth;
      } else {
        print("Error: User not registered");

        throw Exception('User not registered');
      }
    } catch (error) {
      print("Failed to login: $error");

      throw Exception('Failed to login: $error');
    }
  }
}
