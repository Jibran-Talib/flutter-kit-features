import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/session/session_cubit.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/auth_params/auth_request_params.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final UpdateFcmUseCase _updateFcmUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final SetPasswordUseCase _setPasswordUseCase;
  final SocialLoginUseCase _socialLoginUseCase;
  final LogoutUseCase _logoutUseCase;
  final SessionCubit _sessionCubit;
  final StorageService _storageService;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required UpdateFcmUseCase updateFcmUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required SetPasswordUseCase setPasswordUseCase,
    required SocialLoginUseCase socialLoginUseCase,
    required LogoutUseCase logoutUseCase,
    required SessionCubit sessionCubit,
    required StorageService storageService,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _updateFcmUseCase = updateFcmUseCase,
        _resendOtpUseCase = resendOtpUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _setPasswordUseCase = setPasswordUseCase,
        _socialLoginUseCase = socialLoginUseCase,
        _logoutUseCase = logoutUseCase,
        _sessionCubit = sessionCubit,
        _storageService = storageService,
        super(const AuthState());

  Future<void> login(LoginRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.login, message: null));

    final result = await _loginUseCase(params);

    await result.fold<Future<void>>(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.login,
        message: failure.message,
      )),
      (auth) async {
        await _sessionCubit.setSession(token: auth.token, user: auth.user);
        emit(state.copyWith(status: AuthStatus.success, action: AuthAction.login, auth: auth));
      },
    );
  }

  Future<void> signup(SignupRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.signup, message: ''));

    final result = await _signupUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.signup,
        message: failure.message,
      )),
      (auth) => emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.signup,
        auth: auth,
        message: 'OTP sent successfully',
      )),
    );
  }

  Future<void> verifyOtp(VerifyOtpRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.verifyOtp, message: null));

    final result = await _verifyOtpUseCase(params);

    await result.fold<Future<void>>(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.verifyOtp,
        message: failure.message,
      )),
      (auth) async {
        if (auth.token.isNotEmpty) {
          await _sessionCubit.setSession(token: auth.token, user: auth.user);
        }
        if (auth.tempToken.isNotEmpty) {
          await _storageService.saveResetToken(auth.tempToken);
        }
        emit(state.copyWith(
          status: AuthStatus.success,
          action: AuthAction.verifyOtp,
          auth: auth,
        ));
      },
    );
  }

  Future<void> resendOtp(ForgotPasswordRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.resendOtp, message: null));

    final result = await _resendOtpUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.resendOtp,
        message: failure.message,
      )),
      (message) => emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.resendOtp,
        message: message,
      )),
    );
  }

  Future<void> forgotPassword(ForgotPasswordRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.forgotPassword, message: null));

    final result = await _forgotPasswordUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.forgotPassword,
        message: failure.message,
      )),
      (message) => emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.forgotPassword,
        message: message,
      )),
    );
  }

  Future<void> resetPassword(ResetPasswordRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.resetPassword, message: null));

    final result = await _resetPasswordUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.resetPassword,
        message: failure.message,
      )),
      (message) {
        _storageService.removeResetToken();
        emit(state.copyWith(
          status: AuthStatus.success,
          action: AuthAction.resetPassword,
          message: message,
        ));
      },
    );
  }

  Future<void> changePassword(ChangePasswordRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.changePassword, message: null));

    final result = await _changePasswordUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.changePassword,
        message: failure.message,
      )),
      (message) => emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.changePassword,
        message: message,
      )),
    );
  }

  Future<void> setPassword(SetPasswordRequestParams params) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.setPassword, message: null));

    final result = await _setPasswordUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.setPassword,
        message: failure.message,
      )),
      (message) => emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.setPassword,
        message: message,
      )),
    );
  }

  Future<void> socialLogin(bool fromGoogle) async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.socialLogin, message: null));

    final result = await _socialLoginUseCase(fromGoogle);

    await result.fold<Future<void>>(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.socialLogin,
        message: failure.message,
      )),
      (auth) async {
        if (auth.token.trim().isEmpty) {
          emit(state.copyWith(
            status: AuthStatus.error,
            action: AuthAction.socialLogin,
            message: 'Social login succeeded but backend token was not returned.',
          ));
          return;
        }
        await _sessionCubit.setSession(token: auth.token, user: auth.user);
        emit(state.copyWith(
          status: AuthStatus.success,
          action: AuthAction.socialLogin,
          provider: AuthProvider.social,
          auth: auth,
        ));
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, action: AuthAction.logout, message: null));

    final result = await _logoutUseCase();

    await result.fold<Future<void>>(
      (failure) async => emit(state.copyWith(
        status: AuthStatus.error,
        action: AuthAction.logout,
        message: failure.message,
      )),
      (message) async {
        await _sessionCubit.logout();
        emit(state.copyWith(
          status: AuthStatus.success,
          action: AuthAction.logout,
          message: message,
        ));
      },
    );
  }

  Future<void> clearLocalSession() async {
    await _sessionCubit.logout();
    emit(const AuthState());
  }

  @override
  void onChange(Change<AuthState> change) {
    log('AuthCubit: ${change.nextState.action} → ${change.nextState.status}');
    super.onChange(change);
  }
}
