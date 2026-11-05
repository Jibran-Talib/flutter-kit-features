import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/in_app_product_entity.dart';
import '../entities/in_app_purchase_update_entity.dart';
import '../entities/store_plan_entity.dart';
import '../repositories/in_app_purchase_repository.dart';
import 'verify_in_app_purchase_params.dart';

class GetInAppProductsUseCase {
  final InAppPurchaseRepository repository;
  GetInAppProductsUseCase(this.repository);
  Future<Either<Failure, List<StorePlanEntity>>> call() => repository.getProducts();
}

class BuyInAppProductUseCase {
  final InAppPurchaseRepository repository;
  BuyInAppProductUseCase(this.repository);
  Future<Either<Failure, void>> call(InAppProductEntity product) =>
      repository.buyProduct(product);
}

class RestoreInAppPurchasesUseCase extends UseCase<void, NoParams> {
  final InAppPurchaseRepository repository;
  RestoreInAppPurchasesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.restorePurchases();
}

class ListenInAppPurchaseUpdatesUseCase {
  final InAppPurchaseRepository repository;
  ListenInAppPurchaseUpdatesUseCase(this.repository);
  Stream<List<InAppPurchaseUpdateEntity>> call() => repository.watchPurchaseUpdates();
}

class VerifyInAppPurchaseUseCase {
  final InAppPurchaseRepository repository;
  VerifyInAppPurchaseUseCase(this.repository);
  Future<Either<Failure, void>> call(VerifyInAppPurchaseParams params) =>
      repository.verifyPurchase(params);
}

class CompleteInAppPurchaseUseCase {
  final InAppPurchaseRepository repository;
  CompleteInAppPurchaseUseCase(this.repository);
  Future<Either<Failure, void>> call(InAppPurchaseUpdateEntity purchase) =>
      repository.completePurchase(purchase);
}
