import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/in_app_product_entity.dart';
import '../entities/in_app_purchase_update_entity.dart';
import '../entities/store_plan_entity.dart';
import '../usecases/verify_in_app_purchase_params.dart';

abstract class InAppPurchaseRepository {
  Future<Either<Failure, List<StorePlanEntity>>> getProducts();
  Future<Either<Failure, void>> buyProduct(InAppProductEntity product);
  Future<Either<Failure, void>> restorePurchases();
  Stream<List<InAppPurchaseUpdateEntity>> watchPurchaseUpdates();
  Future<Either<Failure, void>> verifyPurchase(VerifyInAppPurchaseParams params);
  Future<Either<Failure, void>> completePurchase(InAppPurchaseUpdateEntity purchase);
}
