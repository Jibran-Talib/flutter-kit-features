import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/errors/exceptions.dart';
import '../../constants.dart';
import '../models/in_app_product_model.dart';
import '../models/in_app_purchase_update_model.dart';

abstract class InAppPurchaseStoreDataSource {
  Future<bool> isStoreAvailable();
  Future<List<InAppProductModel>> getProducts(List<String> productIds);
  Future<void> buyProduct(String productId);
  Future<void> restorePurchases();
  Stream<List<InAppPurchaseUpdateModel>> watchPurchaseUpdates();
  Future<void> completePurchase(String productId);
}

class InAppPurchaseStoreDataSourceImpl implements InAppPurchaseStoreDataSource {
  final InAppPurchase _inAppPurchase;
  final Map<String, InAppProductModel> _productCache = {};
  final Map<String, InAppPurchaseUpdateModel> _purchaseCache = {};

  InAppPurchaseStoreDataSourceImpl({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  @override
  Future<bool> isStoreAvailable() => _inAppPurchase.isAvailable();

  @override
  Future<List<InAppProductModel>> getProducts(List<String> productIds) async {
    final response = await _inAppPurchase.queryProductDetails(productIds.toSet());

    if (response.error != null) throw response.error!.message;
    if (response.productDetails.isEmpty) throw 'No products found for the given IDs';

    final products = response.productDetails
        .map(InAppProductModel.fromProductDetails)
        .toList()
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    _productCache
      ..clear()
      ..addEntries(products.map((p) => MapEntry(p.id, p)));

    return products;
  }

  @override
  Future<void> buyProduct(String productId) async {
    final product = _productCache[productId];
    if (product == null) throw NotFoundException('Product not found for purchase.');

    final purchaseParam = PurchaseParam(productDetails: product.productDetails);

    if (InAppConstants.isNonConsumable(productId)) {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  Future<void> restorePurchases() => _inAppPurchase.restorePurchases();

  @override
  Stream<List<InAppPurchaseUpdateModel>> watchPurchaseUpdates() {
    return _inAppPurchase.purchaseStream.map((updates) {
      final mapped = updates.map(InAppPurchaseUpdateModel.fromPurchaseDetails).toList();
      for (final purchase in mapped) {
        _purchaseCache[purchase.productId] = purchase;
      }
      return mapped;
    });
  }

  @override
  Future<void> completePurchase(String productId) {
    final purchase = _purchaseCache[productId];
    if (purchase == null) throw NotFoundException('Purchase could not be completed.');
    return _inAppPurchase.completePurchase(purchase.purchaseDetails);
  }
}
