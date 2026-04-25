class AuthResponse {
  final bool success;
  final String? message;
  final String? username;
  final bool mpinExists;      // ← ADD

  AuthResponse({
    required this.success,
    this.message,
    this.username,
    this.mpinExists = false,  // ← ADD (defaults to false, safe fallback)
  });
}