import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'current_username';

  // =========================
  // LOGIN SESSION MANAGEMENT
  // =========================

  /// Save login session
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  /// Clear login session (Logout)
  /// IMPORTANT: Do NOT remove MPIN here
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUsername);
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

  // =========================
  // MPIN MANAGEMENT (PER USER)
  // =========================

  /// Save MPIN for specific user
  static Future<void> saveMpin(String username, String mpin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mpin_$username', mpin);
  }

  /// Get MPIN for specific user
  static Future<String?> getMpin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mpin_$username');
  }

  /// Optional: Clear MPIN for specific user (not used now)
  static Future<void> clearUserMpin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mpin_$username');
  }
}