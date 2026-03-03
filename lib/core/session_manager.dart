import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyUsername = 'current_username';
  static const _keyMpin = 'user_mpin';

  /// Save login session
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  /// Clear login session (Logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyMpin);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  /// Get current username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Save MPIN
  static Future<void> saveMpin(String mpin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMpin, mpin);
  }

  /// Get MPIN
  static Future<String?> getMpin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMpin);
  }
}