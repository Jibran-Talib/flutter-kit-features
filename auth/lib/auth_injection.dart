import '../../core/di/service_locator.dart';
import '../../core/session/session_cubit.dart';
import '../../core/services/storage_service.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'presentation/cubit/auth_cubit.dart';

void initAuthInjection({
  // Optional: provide a function that returns a social token (Google/Apple ID token).
  // Example: (method) => GoogleSignIn().signIn().then((u) => u?.authentication.then((a) => a.idToken))
  SocialTokenProvider? socialTokenProvider,
}) {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), socialTokenProvider: socialTokenProvider),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFcmUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => SetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      signupUseCase: sl(),
      verifyOtpUseCase: sl(),
      updateFcmUseCase: sl(),
      resendOtpUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      changePasswordUseCase: sl(),
      setPasswordUseCase: sl(),
      socialLoginUseCase: sl(),
      logoutUseCase: sl(),
      sessionCubit: sl<SessionCubit>(),
      storageService: sl<StorageService>(),
    ),
  );
}
