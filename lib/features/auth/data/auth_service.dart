import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/session_manager.dart';
import 'auth_models.dart';

class AuthService {
  static const String baseUrl =
      "https://suvarna-jewellers-customer-backend.vercel.app/api/auth";

  static Future<AuthResponse> sendSignupOtp({
    required String mobile,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": mobile,
        }),
      ).timeout(const Duration(seconds: 20));

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(success: true);
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "OTP send failed",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<AuthResponse> verifySignupOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": mobile,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(success: true);
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "Invalid OTP",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<AuthResponse> register({
    required String fullName,
    required String mobile,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": fullName,
          "phone": mobile,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final token = data["token"];
        final user = data["user"];

        if (token != null) {
          await SessionManager.saveToken(token);
          await SessionManager.saveLoginSession(mobile);

          if (data["user"] != null && data["user"]["id"] != null) {
            await SessionManager.saveUserId(data["user"]["id"].toString());
          }
        }

        if (user != null && user["id"] != null) {
          await SessionManager.saveUserId(user["id"].toString());
        }

        return AuthResponse(
          success: true,
          username: mobile,
        );
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "Signup failed",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": identifier,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data["token"];
        final user = data["user"];

        if (token != null) {
          await SessionManager.saveToken(token);
          await SessionManager.saveLoginSession(identifier);

          if (data["user"] != null && data["user"]["id"] != null) {
            await SessionManager.saveUserId(data["user"]["id"].toString());
          }
        }

        if (user != null && user["id"] != null) {
          await SessionManager.saveUserId(user["id"].toString());
        }

        // ← ADD: read mpinExists flag from backend
        final bool mpinExists = data["mpinExists"] ?? false;

        return AuthResponse(
          success: true,
          username: identifier,
          mpinExists: mpinExists,   // ← ADD
        );
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "Login failed",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<AuthResponse> setMpin({
    required String username,
    required String mpin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/set-mpin"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": username,
          "mpin": mpin,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await SessionManager.saveMpin(username, mpin);
        return AuthResponse(success: true);
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "MPIN save failed",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<AuthResponse> verifyLoginOtp({
    required String otp,
  }) async {
    return AuthResponse(success: true);
  }

  static Future<AuthResponse> verifyMpin({
    required String username,
    required String mpin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-mpin"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone": username,
          "mpin": mpin,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(success: true);
      }

      return AuthResponse(
        success: false,
        message: data["message"] ?? "Incorrect MPIN",
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}