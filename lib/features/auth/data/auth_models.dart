class AuthResponse {
  final bool success;
  final String? message;
  final String? username;

  AuthResponse({
    required this.success,
    this.message,
    this.username,
  });
}