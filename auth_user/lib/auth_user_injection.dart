import 'core/api_service/network.dart';
import 'core/di/service_locator.dart';
import 'core/session/session_cubit.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/user_usecases.dart';
import 'presentation/cubit/user_cubit.dart';

// Also includes auth injection — import auth_injection.dart separately and call initAuthInjection()

void initUserInjection() {
  // Datasource
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<ApiService>()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => CheckUsernameUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => UpdateNotificationSettingsUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => ToggleBlockUserUseCase(sl<UserRepository>()));
  sl.registerLazySingleton(() => ReportUserUseCase(sl<UserRepository>()));

  // Cubit (factory — new instance per screen)
  sl.registerFactory<UserCubit>(() => UserCubit(
    getUser: sl<GetUserUseCase>(),
    updateUser: sl<UpdateUserUseCase>(),
    checkUsername: sl<CheckUsernameUseCase>(),
    deleteAccount: sl<DeleteAccountUseCase>(),
    updateNotification: sl<UpdateNotificationSettingsUseCase>(),
    toggleBlock: sl<ToggleBlockUserUseCase>(),
    reportUser: sl<ReportUserUseCase>(),
    sessionCubit: sl<SessionCubit>(),
  ));
}
