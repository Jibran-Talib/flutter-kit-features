import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../domain/entities/in_app_purchase_update_entity.dart';
import '../../domain/enums/in_app_purchase_status.dart';

class InAppPurchaseUpdateModel extends Equatable {
  final PurchaseDetails purchaseDetails;
  final String productId;
  final InAppPurchaseStatus status;
  final bool pendingCompletePurchase;
  final String purchaseToken;
  final String source;

  const InAppPurchaseUpdateModel({
    required this.purchaseDetails,
    required this.productId,
    required this.status,
    required this.pendingCompletePurchase,
    required this.purchaseToken,
    required this.source,
  });

  factory InAppPurchaseUpdateModel.fromPurchaseDetails(PurchaseDetails purchaseDetails) {
    return InAppPurchaseUpdateModel(
      purchaseDetails: purchaseDetails,
      productId: purchaseDetails.productID,
      status: _mapStatus(purchaseDetails.status),
      pendingCompletePurchase: purchaseDetails.pendingCompletePurchase,
      purchaseToken: Platform.isIOS
          ? purchaseDetails.purchaseID ?? ''
          : purchaseDetails.verificationData.serverVerificationData,
      source: purchaseDetails.verificationData.source,
    );
  }

  InAppPurchaseUpdateEntity toEntity() {
    return InAppPurchaseUpdateEntity(
      productId: productId,
      status: status,
      pendingCompletePurchase: pendingCompletePurchase,
      purchaseToken: purchaseToken,
      source: source,
    );
  }

  static InAppPurchaseStatus _mapStatus(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.pending:
        return InAppPurchaseStatus.pending;
      case PurchaseStatus.purchased:
        return InAppPurchaseStatus.purchased;
      case PurchaseStatus.restored:
        return InAppPurchaseStatus.restored;
      case PurchaseStatus.error:
        return InAppPurchaseStatus.error;
      case PurchaseStatus.canceled:
        return InAppPurchaseStatus.canceled;
    }
  }

  @override
  List<Object?> get props => [productId, status, pendingCompletePurchase, purchaseToken, source];
}
