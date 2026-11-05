import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/in_app_product_entity.dart';
import '../../domain/entities/in_app_purchase_update_entity.dart';
import '../../domain/enums/in_app_purchase_status.dart';
import '../../domain/usecases/iap_usecases.dart';
import '../../domain/usecases/verify_in_app_purchase_params.dart';
import 'in_app_purchase_state.dart';

// onPurchaseSuccess callback: called after backend verification succeeds.
// Use this to unlock premium, update UI, refresh user data, etc.
typedef OnPurchaseSuccess = void Function(String productId);

class InAppPurchaseCubit extends Cubit<InAppPurchaseState> {
  final GetInAppProductsUseCase _getInAppProductsUseCase;
  final BuyInAppProductUseCase _buyInAppProductUseCase;
  final ListenInAppPurchaseUpdatesUseCase _listenInAppPurchaseUpdatesUseCase;
  final VerifyInAppPurchaseUseCase _verifyInAppPurchaseUseCase;
  final CompleteInAppPurchaseUseCase _completeInAppPurchaseUseCase;
  final RestoreInAppPurchasesUseCase _restoreInAppPurchasesUseCase;
  final OnPurchaseSuccess? onPurchaseSuccess;

  late final StreamSubscription<List<InAppPurchaseUpdateEntity>> _purchaseUpdatesSubscription;

  InAppPurchaseCubit({
    required GetInAppProductsUseCase getInAppProductsUseCase,
    required BuyInAppProductUseCase buyInAppProductUseCase,
    required ListenInAppPurchaseUpdatesUseCase listenInAppPurchaseUpdatesUseCase,
    required VerifyInAppPurchaseUseCase verifyInAppPurchaseUseCase,
    required CompleteInAppPurchaseUseCase completeInAppPurchaseUseCase,
    required RestoreInAppPurchasesUseCase restoreInAppPurchasesUseCase,
    this.onPurchaseSuccess,
  })  : _getInAppProductsUseCase = getInAppProductsUseCase,
        _buyInAppProductUseCase = buyInAppProductUseCase,
        _listenInAppPurchaseUpdatesUseCase = listenInAppPurchaseUpdatesUseCase,
        _verifyInAppPurchaseUseCase = verifyInAppPurchaseUseCase,
        _completeInAppPurchaseUseCase = completeInAppPurchaseUseCase,
        _restoreInAppPurchasesUseCase = restoreInAppPurchasesUseCase,
        super(const InAppPurchaseState()) {
    _purchaseUpdatesSubscription = _listenInAppPurchaseUpdatesUseCase().listen(
      _handlePurchaseUpdates,
    );
  }

  Future<void> loadPlans() async {
    emit(state.copyWith(status: InAppPurchaseViewStatus.loading, clearMessage: true));

    final result = await _getInAppProductsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: InAppPurchaseViewStatus.error,
        message: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: InAppPurchaseViewStatus.success,
        purchaseStatus: InAppPurchaseActionStatus.idle,
        products: products,
        clearMessage: true,
      )),
    );
  }

  Future<void> buyProduct(InAppProductEntity product) async {
    emit(state.copyWith(
      activeProductId: product.id,
      purchaseStatus: InAppPurchaseActionStatus.processing,
      clearMessage: true,
    ));

    final result = await _buyInAppProductUseCase(product);

    result.fold(
      (failure) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.awaitingStoreConfirmation,
      )),
    );
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(purchaseStatus: InAppPurchaseActionStatus.processing, clearMessage: true));

    final result = await _restoreInAppPurchasesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.failure,
        message: failure.message,
      )),
      (_) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.idle,
        message: 'Purchases restored successfully.',
      )),
    );
  }

  Future<void> _handlePurchaseUpdates(List<InAppPurchaseUpdateEntity> updates) async {
    for (final purchase in updates) {
      switch (purchase.status) {
        case InAppPurchaseStatus.pending:
          emit(state.copyWith(
            activeProductId: purchase.productId,
            purchaseStatus: InAppPurchaseActionStatus.processing,
            message: 'Purchase is pending confirmation.',
          ));
        case InAppPurchaseStatus.purchased:
        case InAppPurchaseStatus.restored:
          await _verifyPurchase(purchase);
        case InAppPurchaseStatus.canceled:
          emit(state.copyWith(
            activeProductId: purchase.productId,
            purchaseStatus: InAppPurchaseActionStatus.canceled,
            message: 'Purchase was canceled.',
          ));
        case InAppPurchaseStatus.error:
          emit(state.copyWith(
            activeProductId: purchase.productId,
            purchaseStatus: InAppPurchaseActionStatus.failure,
            message: 'Purchase failed. Please try again.',
          ));
      }

      if (purchase.pendingCompletePurchase) {
        await _completePurchase(purchase);
      }
    }
  }

  Future<void> _verifyPurchase(InAppPurchaseUpdateEntity purchase) async {
    emit(state.copyWith(
      activeProductId: purchase.productId,
      purchaseStatus: InAppPurchaseActionStatus.verifying,
      clearMessage: true,
    ));

    final result = await _verifyInAppPurchaseUseCase(
      VerifyInAppPurchaseParams.fromPurchase(purchase),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.failure,
        message: failure.message,
      )),
      (_) {
        // Notify caller to handle premium unlock (e.g., refresh user, update local state)
        onPurchaseSuccess?.call(purchase.productId);

        emit(state.copyWith(
          purchaseStatus: InAppPurchaseActionStatus.success,
          lastPurchasedProductId: purchase.productId,
          clearMessage: true,
        ));
      },
    );
  }

  Future<void> _completePurchase(InAppPurchaseUpdateEntity purchase) async {
    final result = await _completeInAppPurchaseUseCase(purchase);
    result.fold(
      (failure) => emit(state.copyWith(
        purchaseStatus: InAppPurchaseActionStatus.failure,
        message: failure.message,
      )),
      (_) {},
    );
  }

  void clearFeedback() {
    emit(state.copyWith(
      purchaseStatus: InAppPurchaseActionStatus.idle,
      clearMessage: true,
      clearLastPurchasedProductId: true,
      clearActiveProductId: true,
    ));
  }

  @override
  Future<void> close() async {
    await _purchaseUpdatesSubscription.cancel();
    return super.close();
  }
}
