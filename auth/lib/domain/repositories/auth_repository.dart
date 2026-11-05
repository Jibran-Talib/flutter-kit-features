import 'package:fpdart/fpdart.dart';

// Relative to flutter-kit-core: copy core/errors/failure.dart into project
import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../usecases/auth_params/auth_request_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(LoginRequestParams params);
  Future<Either<Failure, AuthEntity>> signup(SignupRequestParams params);
  Future<Either<Failure, AuthEntity>> verifyOtp(VerifyOtpRequestParams params);
  Future<Either<Failure, String>> updateFcm(UpdateFcmRequestParams params);
  Future<Either<Failure, String>> resendOtp(ForgotPasswordRequestParams params);
  Future<Either<Failure, String>> sendOtp(ForgotPasswordRequestParams params);
  Future<Either<Failure, String>> forgotPassword(ForgotPasswordRequestParams params);
  Future<Either<Failure, String>> resetPassword(ResetPasswordRequestParams params);
  Future<Either<Failure, String>> changePassword(ChangePasswordRequestParams params);
  Future<Either<Failure, String>> setPassword(SetPasswordRequestParams params);
  Future<Either<Failure, AuthEntity>> socialLogin(bool fromGoogle);
  Future<Either<Failure, String>> logout();
}
