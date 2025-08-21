class AuthResult {
  final bool success;
  final String message;
  final String? mobile;
  final String? otp;

  AuthResult({
    required this.success,
    required this.message,
    this.mobile,
    this.otp,
  });
}
