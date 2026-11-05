import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';
import 'auth_params/auth_request_params.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  Future<Either<Failure, AuthEntity>> call(LoginRequestParams params) =>
      repository.login(params);
}

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);
  Future<Either<Failure, AuthEntity>> call(SignupRequestParams params) =>
      repository.signup(params);
}

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);
  Future<Either<Failure, AuthEntity>> call(VerifyOtpRequestParams params) =>
      repository.verifyOtp(params);
}

class UpdateFcmUseCase {
  final AuthRepository repository;
  UpdateFcmUseCase(this.repository);
  Future<Either<Failure, String>> call(UpdateFcmRequestParams params) =>
      repository.updateFcm(params);
}

class ResendOtpUseCase {
  final AuthRepository repository;
  ResendOtpUseCase(this.repository);
  Future<Either<Failure, String>> call(ForgotPasswordRequestParams params) =>
      repository.resendOtp(params);
}

class SendOtpUseCase {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);
  Future<Either<Failure, String>> call(ForgotPasswordRequestParams params) =>
      repository.sendOtp(params);
}

class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);
  Future<Either<Failure, String>> call(ForgotPasswordRequestParams params) =>
      repository.forgotPassword(params);
}

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);
  Future<Either<Failure, String>> call(ResetPasswordRequestParams params) =>
      repository.resetPassword(params);
}

class ChangePasswordUseCase {
  final AuthRepository repository;
  ChangePasswordUseCase(this.repository);
  Future<Either<Failure, String>> call(ChangePasswordRequestParams params) =>
      repository.changePassword(params);
}

class SetPasswordUseCase {
  final AuthRepository repository;
  SetPasswordUseCase(this.repository);
  Future<Either<Failure, String>> call(SetPasswordRequestParams params) =>
      repository.setPassword(params);
}

class SocialLoginUseCase {
  final AuthRepository repository;
  SocialLoginUseCase(this.repository);
  Future<Either<Failure, AuthEntity>> call(bool fromGoogle) =>
      repository.socialLogin(fromGoogle);
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);
  Future<Either<Failure, String>> call() => repository.logout();
}
