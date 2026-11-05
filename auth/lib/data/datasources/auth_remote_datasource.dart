import '../../../../core/api_service/network.dart';
import '../../domain/usecases/auth_params/auth_request_params.dart';
import '../models/auth_model.dart';
import 'auth_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(LoginRequestParams params);
  Future<AuthModel> signup(SignupRequestParams params);
  Future<AuthModel> verifyOtp(VerifyOtpRequestParams params);
  Future<String> updateFcm(UpdateFcmRequestParams params);
  Future<String> resendOtp(ForgotPasswordRequestParams params);
  Future<String> sendOtp(ForgotPasswordRequestParams params);
  Future<String> forgotPassword(ForgotPasswordRequestParams params);
  Future<String> resetPassword(ResetPasswordRequestParams params);
  Future<String> changePassword(ChangePasswordRequestParams params);
  Future<String> setPassword(SetPasswordRequestParams params);
  Future<AuthModel> socialLogin(SocialLoginRequestParams params);
  Future<String> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthModel> login(LoginRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.login,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (response.success) return AuthModel.fromJson(response.data as Map<String, dynamic>);
    throw response.message ?? 'Login failed';
  }

  @override
  Future<AuthModel> signup(SignupRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.signup,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (response.success) return AuthModel.fromJson(response.data ?? {});
    throw response.message ?? 'Signup failed';
  }

  @override
  Future<AuthModel> verifyOtp(VerifyOtpRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.verifyOtp,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (response.success) return AuthModel.fromJson(response.data ?? {});
    throw response.message ?? 'OTP verification failed';
  }

  @override
  Future<String> updateFcm(UpdateFcmRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.updateFcm,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'FCM update failed';
    return response.message ?? 'FCM updated successfully';
  }

  @override
  Future<String> resendOtp(ForgotPasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.resendOtp,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Resend OTP failed';
    return response.message ?? 'OTP resent successfully';
  }

  @override
  Future<String> sendOtp(ForgotPasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.sendOtp,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Send OTP failed';
    return response.message ?? 'OTP sent successfully';
  }

  @override
  Future<String> forgotPassword(ForgotPasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.forgotPassword,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Forgot password request failed';
    return response.message ?? 'Password reset link sent successfully';
  }

  @override
  Future<String> resetPassword(ResetPasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.resetPassword,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Reset password failed';
    return response.message ?? 'Password reset successfully';
  }

  @override
  Future<String> changePassword(ChangePasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.changePassword,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Change password failed';
    return response.message ?? 'Password changed successfully';
  }

  @override
  Future<String> setPassword(SetPasswordRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.setPassword,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (!response.success) throw response.message ?? 'Set password failed';
    return response.message ?? 'Password set successfully';
  }

  @override
  Future<AuthModel> socialLogin(SocialLoginRequestParams params) async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.signup,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (response.success) {
      final model = AuthModel.fromJson(response.data as Map<String, dynamic>);
      if (model.token.trim().isNotEmpty) return model;
    }
    throw response.message ?? 'Social login failed';
  }

  @override
  Future<String> logout() async {
    final response = await apiService.request(
      endpoint: AuthEndPoints.logout,
      method: DioMethod.post,
    );
    if (!response.success) throw response.message ?? 'Logout failed';
    return response.message ?? 'Logged out successfully';
  }
}
