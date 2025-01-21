import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearUserId();
}

class AuthLocalDataSourceImplementation extends AuthLocalDataSource {
  final SharedPreferences sharedPreferancese;

  AuthLocalDataSourceImplementation(this.sharedPreferancese);

  @override
  Future<void> clearUserId() async {
    await sharedPreferancese.remove("userId");
  }

  @override
  Future<String?> getUserId() async {
    return sharedPreferancese.getString('userId');
  }

  @override
  Future<void> saveUserId(String userId) async {
    await sharedPreferancese.setString('userId', userId);
  }
}
