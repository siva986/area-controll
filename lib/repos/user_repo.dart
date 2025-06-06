import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  Future<SharedPreferences> get pref => SharedPreferences.getInstance();

  Future<void> saveToken(String token) {
    return pref.then((e) {
      e.setString('token', token);
    });
  }

  Future<String> getToken() {
    return pref.then((e) {
      return e.getString('token') ?? "";
    });
  }
}
