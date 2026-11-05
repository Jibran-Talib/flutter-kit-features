import 'package:equatable/equatable.dart';

import '../../domain/entities/store_plan_entity.dart';

extension PurchaseStatusX on InAppPurchaseActionStatus {
  bool get isLoading =>
      this == InAppPurchaseActionStatus.processing ||
      this == InAppPurchaseActionStatus.awaitingStoreConfirmation ||
      this == InAppPurchaseActionStatus.verifying;
}

enum InAppPurchaseViewStatus { initial, loading, success, error }

enum InAppPurchaseActionStatus {
  idle,
  processing,
  awaitingStoreConfirmation,
  verifying,
  success,
  failure,
  canceled,
}

class InAppPurchaseState extends Equatable {
  final InAppPurchaseViewStatus status;
  final InAppPurchaseActionStatus purchaseStatus;
  final List<StorePlanEntity> products;
  final String? activeProductId;
  final String? lastPurchasedProductId;
  final String? message;

  const InAppPurchaseState({
    this.status = InAppPurchaseViewStatus.initial,
    this.purchaseStatus = InAppPurchaseActionStatus.idle,
    this.products = const [],
    this.activeProductId,
    this.lastPurchasedProductId,
    this.message,
  });

  InAppPurchaseState copyWith({
    InAppPurchaseViewStatus? status,
    InAppPurchaseActionStatus? purchaseStatus,
    List<StorePlanEntity>? products,
    String? activeProductId,
    String? lastPurchasedProductId,
    String? message,
    bool clearMessage = false,
    bool clearLastPurchasedProductId = false,
    bool clearActiveProductId = false,
  }) {
    return InAppPurchaseState(
      status: status ?? this.status,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      products: products ?? this.products,
      activeProductId: clearActiveProductId ? null : (activeProductId ?? this.activeProductId),
      lastPurchasedProductId: clearLastPurchasedProductId
          ? null
          : (lastPurchasedProductId ?? this.lastPurchasedProductId),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  bool isProcessingProduct(String productId) {
    return activeProductId == productId && purchaseStatus.isLoading;
  }

  @override
  List<Object?> get props => [
    status,
    purchaseStatus,
    products,
    activeProductId,
    lastPurchasedProductId,
    message,
  ];
}
