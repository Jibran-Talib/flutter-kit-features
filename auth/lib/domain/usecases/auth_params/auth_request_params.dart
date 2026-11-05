// Auth request params — same as tailored, all generic/reusable.
// Place in: lib/domain/usecases/auth_params/auth_request_params.dart

class LoginRequestParams {
  final String email;
  final String password;
  final String? deviceToken;
  final String method;

  LoginRequestParams({
    required this.email,
    required this.password,
    this.method = 'email',
    this.deviceToken,
  });

  Map<String, dynamic> toJson() => {
    'email': email.trim().toLowerCase(),
    'password': password,
    'method': method,
    if (deviceToken != null) 'device_token': deviceToken,
  };
}

class SignupRequestParams {
  final String email;
  final String password;
  final String method;

  SignupRequestParams({
    required this.email,
    required this.password,
    this.method = 'email',
  });

  Map<String, dynamic> toJson() => {
    'email': email.trim().toLowerCase(),
    'password': password,
    'method': method,
  };
}

class SocialLoginRequestParams {
  final String id;
  final String method;

  SocialLoginRequestParams({required this.id, required this.method});

  Map<String, dynamic> toJson() => {'idToken': id, 'method': method};
}

class VerifyOtpRequestParams {
  final String email;
  final String otp;
  final String? mode;

  VerifyOtpRequestParams({required this.email, required this.otp, this.mode});

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    if (mode != null) 'mode': mode,
  };
}

class UpdateFcmRequestParams {
  final String deviceToken;

  UpdateFcmRequestParams({required this.deviceToken});

  Map<String, dynamic> toJson() => {'fcmToken': deviceToken};
}

class ForgotPasswordRequestParams {
  final String email;
  final String? mode;

  ForgotPasswordRequestParams({required this.email, this.mode});

  Map<String, dynamic> toJson() => {
    'email': email,
    if (mode != null) 'mode': mode,
  };
}

class ResetPasswordRequestParams {
  final String password;
  final String resetToken;

  ResetPasswordRequestParams({required this.password, required this.resetToken});

  Map<String, dynamic> toJson() => {'password': password, 'resetToken': resetToken};
}

class ChangePasswordRequestParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequestParams({required this.oldPassword, required this.newPassword});

  Map<String, dynamic> toJson() => {'password': oldPassword, 'newPassword': newPassword};
}

class SetPasswordRequestParams {
  final String password;
  final String confirmPassword;

  SetPasswordRequestParams({required this.password, required this.confirmPassword});

  Map<String, dynamic> toJson() => {'password': password, 'confirm_password': confirmPassword};
}
