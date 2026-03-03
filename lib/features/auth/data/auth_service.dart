import 'dart:async';
import 'auth_models.dart';

class AuthService {
  /// Temporary in-memory user storage (mock database)
  static final Map<String, Map<String, dynamic>> _mockUsers = {};

  /// =========================
  /// REGISTER
  /// =========================
  static Future<AuthResponse> register({
    required String username,
    required String fullName,
    required String mobile,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Username already exists
    if (_mockUsers.containsKey(username)) {
      return AuthResponse(
        success: false,
        message: "Username already exists",
      );
    }

    if (password.length < 6) {
      return AuthResponse(
        success: false,
        message: "Password must be at least 6 characters",
      );
    }

    // Store mock user
    _mockUsers[username] = {
      "username": username,
      "fullName": fullName,
      "mobile": mobile,
      "password": password,
      "mpin": null,
    };

    return AuthResponse(
      success: true,
      username: username,
    );
  }

  /// =========================
  /// VERIFY SIGNUP OTP
  /// =========================
  static Future<AuthResponse> verifySignupOtp({
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp != "123456") {
      return AuthResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return AuthResponse(success: true);
  }

  /// =========================
  /// SET MPIN
  /// =========================
  static Future<AuthResponse> setMpin({
    required String username,
    required String mpin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!_mockUsers.containsKey(username)) {
      return AuthResponse(
        success: false,
        message: "User not found",
      );
    }

    _mockUsers[username]!["mpin"] = mpin;

    return AuthResponse(success: true);
  }

  /// =========================
  /// LOGIN
  /// =========================
  static Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _mockUsers.values.firstWhere(
            (u) =>
        u["username"] == identifier ||
            u["mobile"] == identifier,
      );

      if (user["password"] != password) {
        return AuthResponse(
          success: false,
          message: "Incorrect password",
        );
      }

      return AuthResponse(
        success: true,
        username: user["username"],
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: "User not found",
      );
    }
  }

  /// =========================
  /// VERIFY LOGIN OTP
  /// =========================
  static Future<AuthResponse> verifyLoginOtp({
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp != "123456") {
      return AuthResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return AuthResponse(success: true);
  }
}