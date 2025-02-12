import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Save multiple user details
  static Future<void> saveUserData(String userPhone, String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', userPhone);
    await prefs.setString('userName', userName);
  }

  // Get user ID
  static Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPhone');
  }

  // Get user name
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Get both userId and userName together
  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userPhone': prefs.getString('userPhone'),
      'userName': prefs.getString('userName'),
    };
  }

  // Remove user data (Logout)
  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhone');
    await prefs.remove('userName');
  }
}
