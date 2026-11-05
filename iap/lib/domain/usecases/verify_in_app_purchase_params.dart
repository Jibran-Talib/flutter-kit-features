import 'dart:io';
import '../entities/in_app_purchase_update_entity.dart';

class VerifyInAppPurchaseParams {
  final String productId;
  final String purchaseToken;

  const VerifyInAppPurchaseParams({
    required this.productId,
    required this.purchaseToken,
  });

  factory VerifyInAppPurchaseParams.fromPurchase(InAppPurchaseUpdateEntity purchase) {
    return VerifyInAppPurchaseParams(
      productId: purchase.productId,
      purchaseToken: purchase.purchaseToken,
    );
  }

  Map<String, dynamic> toJson() {
    // TODO: Replace 'com.yourcompany.yourapp' with your app's bundle ID / package name
    final androidParams = {
      'purchaseToken': purchaseToken,
      'packageName': 'com.yourcompany.yourapp',
    };
    return {
      'platform': Platform.isAndroid ? 'google' : 'apple',
      'productId': productId,
      if (Platform.isAndroid) ...androidParams else 'transactionId': purchaseToken,
    };
  }
}
