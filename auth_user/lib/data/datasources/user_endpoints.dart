class UserEndpoints {
  static const String _base = '/users';
  static const String profile = '$_base/me';          // GET  — fetch profile
  static const String updateProfile = '$_base/me';    // PATCH — update profile (multipart)
  static const String checkUsername = '$_base/check-username'; // GET ?username=
  static const String blockedUsers = '$_base/blocked';// GET / POST
  static const String reportUser = '$_base/report';   // POST
  static const String deleteAccount = '$_base/me';    // DELETE
  static const String notifications = '$_base/notification-settings'; // PATCH
}
