import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  SharedData._privateConstructor();

  static final SharedData _instance = SharedData._privateConstructor();

  static SharedData get instance => _instance;

  Future<void> saveSharedVariable(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sharedVariable', value);
  }

  Future<String?> getSharedVariable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sharedVariable');
  }

  // Save the current user token
  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  // Retrieve the current user token
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  String email = "";
}
