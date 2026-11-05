import 'package:equatable/equatable.dart';
import '../enums/in_app_purchase_status.dart';

class InAppPurchaseUpdateEntity extends Equatable {
  final String productId;
  final InAppPurchaseStatus status;
  final bool pendingCompletePurchase;
  final String purchaseToken;
  final String source;

  const InAppPurchaseUpdateEntity({
    required this.productId,
    required this.status,
    required this.pendingCompletePurchase,
    required this.purchaseToken,
    required this.source,
  });

  @override
  List<Object?> get props => [productId, status, pendingCompletePurchase, purchaseToken, source];
}
