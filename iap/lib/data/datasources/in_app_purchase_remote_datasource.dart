import 'dart:developer';

import '../../../../core/api_service/network.dart';
import '../../../../core/errors/exceptions.dart';
import '../../iap_endpoints.dart';
import '../models/store_plan_model.dart';
import '../../domain/usecases/verify_in_app_purchase_params.dart';

abstract class InAppPurchaseRemoteDataSource {
  Future<void> verifyPurchase(VerifyInAppPurchaseParams model);
  Future<List<StorePlanModel>> getPlansFromBackend();
}

class InAppPurchaseRemoteDataSourceImpl implements InAppPurchaseRemoteDataSource {
  final ApiService apiService;

  InAppPurchaseRemoteDataSourceImpl(this.apiService);

  @override
  Future<void> verifyPurchase(VerifyInAppPurchaseParams model) async {
    final response = await apiService.request(
      endpoint: IapEndPoints.verify,
      method: DioMethod.post,
      data: model.toJson(),
    );

    if (!response.success) {
      throw ServerException(response.message ?? 'Purchase verification failed', 500);
    }
  }

  @override
  Future<List<StorePlanModel>> getPlansFromBackend() async {
    final response = await apiService.request(
      endpoint: IapEndPoints.storePlans,
      method: DioMethod.get,
    );

    if (!response.success) {
      throw ServerException(response.message ?? 'Failed to fetch plans', 500);
    }

    if (response.data == null) throw ServerException('No data received from server', 500);
    if (response.data is! List) throw ServerException('Invalid data format received from server', 500);

    log("IAP plans: ${response.data}");

    return List<StorePlanModel>.from(
      (response.data as List).map((x) => StorePlanModel.fromJson(x as Map<String, dynamic>)),
    );
  }
}
