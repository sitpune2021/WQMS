class SendOtpResult {
  final bool success;
  final String message;
  final String? otp;
  final String? mobile;
  final String? email;

  SendOtpResult({
    required this.success,
    required this.message,
    this.otp,
    this.mobile,
    this.email,
  });
}
