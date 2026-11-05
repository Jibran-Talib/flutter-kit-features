import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/api_service/api_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_params/auth_request_params.dart';
import '../datasources/auth_remote_datasource.dart';

// SocialAuthService is optional. If you don't use Google/Apple sign-in,
// remove the _socialAuthService field and stub out socialLogin().
// See flutter-kit-core or use package:google_sign_in / sign_in_with_apple directly.

typedef SocialTokenProvider = Future<String?> Function(String method);

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SocialTokenProvider? socialTokenProvider;

  AuthRepositoryImpl(this.remoteDataSource, {this.socialTokenProvider});

  @override
  Future<Either<Failure, AuthEntity>> login(LoginRequestParams params) {
    return executeApiRequest(() async {
      final model = await remoteDataSource.login(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, AuthEntity>> signup(SignupRequestParams params) {
    return executeApiRequest(() async {
      final model = await remoteDataSource.signup(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, AuthEntity>> verifyOtp(VerifyOtpRequestParams params) {
    return executeApiRequest(() async {
      final model = await remoteDataSource.verifyOtp(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> updateFcm(UpdateFcmRequestParams params) {
    return executeApiRequest(() => remoteDataSource.updateFcm(params));
  }

  @override
  Future<Either<Failure, String>> resendOtp(ForgotPasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.resendOtp(params));
  }

  @override
  Future<Either<Failure, String>> sendOtp(ForgotPasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.sendOtp(params));
  }

  @override
  Future<Either<Failure, String>> forgotPassword(ForgotPasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.forgotPassword(params));
  }

  @override
  Future<Either<Failure, String>> resetPassword(ResetPasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.resetPassword(params));
  }

  @override
  Future<Either<Failure, String>> changePassword(ChangePasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.changePassword(params));
  }

  @override
  Future<Either<Failure, String>> setPassword(SetPasswordRequestParams params) {
    return executeApiRequest(() => remoteDataSource.setPassword(params));
  }

  @override
  Future<Either<Failure, AuthEntity>> socialLogin(bool fromGoogle) {
    return executeApiRequest(() async {
      if (socialTokenProvider == null) {
        throw 'socialTokenProvider not configured. Pass it in AuthRepositoryImpl constructor.';
      }

      final method = (Platform.isAndroid || fromGoogle) ? 'google' : 'apple';
      final token = await socialTokenProvider!(method);

      if (token == null || token.trim().isEmpty) {
        throw 'Social login cancelled';
      }

      final model = await remoteDataSource.socialLogin(
        SocialLoginRequestParams(id: token, method: method),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> logout() {
    return executeApiRequest(() => remoteDataSource.logout());
  }
}
