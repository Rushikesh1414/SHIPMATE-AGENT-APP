import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static SharedPreferences? _prefs;

  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint(" AppStorage initialized");
  }

  static Future<void> setUser({
    required String email,
    required String userName,
    required String photo,
  }) async {
    await _prefs?.setString("email", email);
    await _prefs?.setString("userName", userName);
    await _prefs?.setString("photo", photo);
  }

  static String? get email => _prefs?.getString("email");
  static String? get userName => _prefs?.getString("userName");
  static String? get photo => _prefs?.getString("photo");

  static Future<void> clearAll() async {
    await _prefs?.clear();
    debugPrint(" AppStorage cleared");
  }
}
