import '../../core/di/service_locator.dart';
import 'data/datasources/in_app_purchase_remote_datasource.dart';
import 'data/datasources/in_app_purchase_store_datasource.dart';
import 'data/repositories/in_app_purchase_repository_impl.dart';
import 'domain/repositories/in_app_purchase_repository.dart';
import 'domain/usecases/iap_usecases.dart';
import 'presentation/cubit/in_app_purchase_cubit.dart';

void initIapInjection({
  // Optional callback: called after a purchase is verified on the backend.
  // Use it to unlock premium features, refresh user state, etc.
  OnPurchaseSuccess? onPurchaseSuccess,
}) {
  // Data sources
  sl.registerLazySingleton<InAppPurchaseStoreDataSource>(
    () => InAppPurchaseStoreDataSourceImpl(),
  );
  sl.registerLazySingleton<InAppPurchaseRemoteDataSource>(
    () => InAppPurchaseRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<InAppPurchaseRepository>(
    () => InAppPurchaseRepositoryImpl(
      storeDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetInAppProductsUseCase(sl()));
  sl.registerLazySingleton(() => BuyInAppProductUseCase(sl()));
  sl.registerLazySingleton(() => RestoreInAppPurchasesUseCase(sl()));
  sl.registerLazySingleton(() => ListenInAppPurchaseUpdatesUseCase(sl()));
  sl.registerLazySingleton(() => VerifyInAppPurchaseUseCase(sl()));
  sl.registerLazySingleton(() => CompleteInAppPurchaseUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => InAppPurchaseCubit(
      getInAppProductsUseCase: sl(),
      buyInAppProductUseCase: sl(),
      listenInAppPurchaseUpdatesUseCase: sl(),
      verifyInAppPurchaseUseCase: sl(),
      completeInAppPurchaseUseCase: sl(),
      restoreInAppPurchasesUseCase: sl(),
      onPurchaseSuccess: onPurchaseSuccess,
    ),
  );
}
