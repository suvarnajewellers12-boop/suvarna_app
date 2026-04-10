import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'current_username';
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';

  // =========================
  // TOKEN MANAGEMENT
  // =========================

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  // =========================
  // USER ID MANAGEMENT
  // =========================

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // =========================
  // LOGIN SESSION MANAGEMENT
  // =========================

  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // =========================
  // MPIN MANAGEMENT (PER USER)
  // =========================

  static Future<void> saveMpin(String username, String mpin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mpin_$username', mpin);
  }

  static Future<String?> getMpin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mpin_$username');
  }

  static Future<void> clearUserMpin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mpin_$username');
  }
}