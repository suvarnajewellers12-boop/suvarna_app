import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDatabase {
  static const _usersKey = 'users_db';

  /// Get all users from storage
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);

    if (usersString == null) return [];

    final List decoded = jsonDecode(usersString);
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Save all users to storage
  static Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users);
    await prefs.setString(_usersKey, encoded);
  }

  /// Add new user
  static Future<void> addUser(Map<String, dynamic> user) async {
    final users = await getUsers();
    users.add(user);
    await _saveUsers(users);
  }

  /// Find user by username
  static Future<Map<String, dynamic>?> findByUsername(String username) async {
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u['username'] == username);
    } catch (_) {
      return null;
    }
  }

  /// Find user by mobile
  static Future<Map<String, dynamic>?> findByMobile(String mobile) async {
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u['mobile'] == mobile);
    } catch (_) {
      return null;
    }
  }

  /// Update user (used for saving MPIN)
  static Future<void> updateUser(Map<String, dynamic> updatedUser) async {
    final users = await getUsers();

    final index = users.indexWhere(
            (u) => u['username'] == updatedUser['username']);

    if (index != -1) {
      users[index] = updatedUser;
      await _saveUsers(users);
    }
  }
}