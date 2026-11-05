import 'dart:io';

import '../models/in_app_product_model.dart';
import '../models/store_plan_model.dart';

class StorePlanMapper {
  static List<StorePlanModel> mapWithStoreProducts({
    required List<StorePlanModel> backendPlans,
    required List<InAppProductModel> storeProducts,
  }) {
    final Map<String, InAppProductModel> productMap = {
      for (var product in storeProducts) product.id: product,
    };

    return backendPlans.map((plan) {
      final productId = Platform.isAndroid ? plan.skuGoogle : plan.skuApple;

      if (productId == null || !productMap.containsKey(productId)) return plan;

      final product = productMap[productId]!;
      return plan.copyWith(price: product.rawPrice, currency: product.currencyCode);
    }).toList();
  }
}
