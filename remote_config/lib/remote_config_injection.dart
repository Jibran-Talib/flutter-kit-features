import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'core/di/service_locator.dart';
import 'data/datasources/remote_config_datasource.dart';
import 'data/repositories/remote_config_repository_impl.dart';
import 'domain/repositories/remote_config_repository.dart';
import 'presentation/cubit/remote_config_cubit.dart';

void initRemoteConfigInjection() {
  sl.registerLazySingleton<RemoteConfigDataSource>(
    () => RemoteConfigDataSourceImpl(FirebaseRemoteConfig.instance),
  );

  sl.registerLazySingleton<RemoteConfigRepository>(
    () => RemoteConfigRepositoryImpl(sl<RemoteConfigDataSource>()),
  );

  // Singleton — config is shared across the app
  sl.registerLazySingleton<RemoteConfigCubit>(
    () => RemoteConfigCubit(sl<RemoteConfigRepository>()),
  );
}
