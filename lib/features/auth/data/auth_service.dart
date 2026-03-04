import 'auth_models.dart';
import 'local_auth_database.dart';

class AuthService {

  /// =========================
  /// REGISTER
  /// =========================
  static Future<AuthResponse> register({
    required String username,
    required String fullName,
    required String mobile,
    required String password,
  }) async {

    if (password.length < 6) {
      return AuthResponse(
        success: false,
        message: "Password must be at least 6 characters",
      );
    }

    final existingUser =
    await LocalAuthDatabase.findByUsername(username);

    if (existingUser != null) {
      return AuthResponse(
        success: false,
        message: "Username already exists",
      );
    }

    final existingMobile =
    await LocalAuthDatabase.findByMobile(mobile);

    if (existingMobile != null) {
      return AuthResponse(
        success: false,
        message: "Mobile already registered",
      );
    }

    await LocalAuthDatabase.addUser({
      "username": username,
      "fullName": fullName,
      "mobile": mobile,
      "password": password,
      "mpin": null,
    });

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

    final user =
    await LocalAuthDatabase.findByUsername(username);

    if (user == null) {
      return AuthResponse(
        success: false,
        message: "User not found",
      );
    }

    user["mpin"] = mpin;
    await LocalAuthDatabase.updateUser(user);

    return AuthResponse(success: true);
  }

  /// =========================
  /// LOGIN
  /// =========================
  static Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {

    Map<String, dynamic>? user =
    await LocalAuthDatabase.findByUsername(identifier);

    user ??=
    await LocalAuthDatabase.findByMobile(identifier);

    if (user == null) {
      return AuthResponse(
        success: false,
        message: "User not found",
      );
    }

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
  }

  /// =========================
  /// VERIFY LOGIN OTP
  /// =========================
  static Future<AuthResponse> verifyLoginOtp({
    required String otp,
  }) async {

    if (otp != "123456") {
      return AuthResponse(
        success: false,
        message: "Invalid OTP",
      );
    }

    return AuthResponse(success: true);
  }

  /// =========================
  /// VERIFY MPIN
  /// =========================
  static Future<AuthResponse> verifyMpin({
    required String username,
    required String mpin,
  }) async {

    final user =
    await LocalAuthDatabase.findByUsername(username);

    if (user == null || user["mpin"] != mpin) {
      return AuthResponse(
        success: false,
        message: "Incorrect MPIN",
      );
    }

    return AuthResponse(success: true);
  }
}
