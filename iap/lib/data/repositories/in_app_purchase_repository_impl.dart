import 'package:fpdart/fpdart.dart';

import '../../../../core/api_service/api_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/in_app_product_entity.dart';
import '../../domain/entities/in_app_purchase_update_entity.dart';
import '../../domain/entities/store_plan_entity.dart';
import '../../domain/repositories/in_app_purchase_repository.dart';
import '../../domain/usecases/verify_in_app_purchase_params.dart';
import '../datasources/in_app_purchase_remote_datasource.dart';
import '../datasources/in_app_purchase_store_datasource.dart';
import '../store_mapper/store_data_transformer.dart';

class InAppPurchaseRepositoryImpl implements InAppPurchaseRepository {
  final InAppPurchaseStoreDataSource storeDataSource;
  final InAppPurchaseRemoteDataSource remoteDataSource;

  InAppPurchaseRepositoryImpl({
    required this.storeDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<StorePlanEntity>>> getProducts() async {
    return executeApiRequest(() async {
      final available = await storeDataSource.isStoreAvailable();
      if (!available) throw ServerException('Store not available', 503);

      final backendPlans = await remoteDataSource.getPlansFromBackend();
      final planIds = backendPlans.map((plan) => plan.key ?? '').where((id) => id.isNotEmpty).toList();
      final storeProducts = await storeDataSource.getProducts(planIds);

      final updatedPlans = StorePlanMapper.mapWithStoreProducts(
        backendPlans: backendPlans,
        storeProducts: storeProducts,
      );

      return updatedPlans.map((plan) => plan.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> buyProduct(InAppProductEntity product) {
    return executeApiRequest(() async {
      await storeDataSource.buyProduct(product.id);
    });
  }

  @override
  Future<Either<Failure, void>> restorePurchases() {
    return executeApiRequest(() async {
      await storeDataSource.restorePurchases();
    });
  }

  @override
  Stream<List<InAppPurchaseUpdateEntity>> watchPurchaseUpdates() {
    return storeDataSource.watchPurchaseUpdates().map(
      (updates) => updates.map((update) => update.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> verifyPurchase(VerifyInAppPurchaseParams params) {
    return executeApiRequest(() async {
      await remoteDataSource.verifyPurchase(params);
    });
  }

  @override
  Future<Either<Failure, void>> completePurchase(InAppPurchaseUpdateEntity purchase) {
    return executeApiRequest(() async {
      await storeDataSource.completePurchase(purchase.productId);
    });
  }
}
