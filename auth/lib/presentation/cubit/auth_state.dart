part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }

enum AuthProvider { email, social }

enum AuthAction {
  login,
  signup,
  verifyOtp,
  resendOtp,
  sendOtp,
  forgotPassword,
  resetPassword,
  changePassword,
  setPassword,
  socialLogin,
  logout,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthAction? action;
  final AuthProvider? provider;
  final AuthEntity? auth;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.action,
    this.auth,
    this.message,
    this.provider = AuthProvider.email,
  });

  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;

  bool isLoadingOf(AuthAction a) => status == AuthStatus.loading && action == a;
  bool isSuccessOf(AuthAction a) => status == AuthStatus.success && action == a;
  bool isErrorOf(AuthAction a) => status == AuthStatus.error && action == a;

  bool get isLoginLoading => isLoadingOf(AuthAction.login);
  bool get isLoginSuccess => isSuccessOf(AuthAction.login);
  bool get isSignupSuccess => isSuccessOf(AuthAction.signup);
  bool get isOtpVerified => isSuccessOf(AuthAction.verifyOtp);
  bool get isResendOtpSuccess => isSuccessOf(AuthAction.resendOtp);
  bool get isForgotPasswordSuccess => isSuccessOf(AuthAction.forgotPassword);
  bool get isResetPasswordSuccess => isSuccessOf(AuthAction.resetPassword);
  bool get isChangePasswordSuccess => isSuccessOf(AuthAction.changePassword);
  bool get isSocialLoginSuccess => isSuccessOf(AuthAction.socialLogin);
  bool get isLogoutLoading => isLoadingOf(AuthAction.logout);

  AuthState copyWith({
    AuthStatus? status,
    AuthAction? action,
    AuthProvider? provider,
    AuthEntity? auth,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      action: action ?? this.action,
      auth: auth ?? this.auth,
      message: message ?? this.message,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [status, action, auth, message, provider];
}
