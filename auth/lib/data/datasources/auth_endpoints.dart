// Auth API endpoints — customize paths to match your backend.
// Place in: lib/data/datasources/auth_endpoints.dart

class AuthEndPoints {
  AuthEndPoints._();

  static const String login = '/auth/signin';
  static const String signup = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String updateFcm = '/auth/update-fcm';
  static const String forgotPassword = '/auth/forgot';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String sendOtp = '/auth/send-otp';
  static const String changePassword = '/auth/change-password';
  static const String setPassword = '/auth/social/set-password';
}
