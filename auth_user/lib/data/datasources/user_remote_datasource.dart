import '../../core/api_service/network.dart';
import '../models/check_username_response_model.dart';
import '../models/user_model.dart';
import '../../domain/usecases/report_user_params.dart';
import '../../domain/usecases/user_params.dart';
import 'user_endpoints.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(UserParams params);
  Future<CheckUsernameResponseModel> checkUsername(String username);
  Future<List<UserModel>> getBlockedUsers();
  Future<void> toggleBlockUser({required String userId, required bool toggle});
  Future<String> reportUser(ReportUserParams params);
  Future<String> deleteAccount(String password);
  Future<void> updateNotificationSettings(bool isEnabled);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService _apiService;

  UserRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserModel> getUser() async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.profile,
      method: DioMethod.get,
    );
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.message ?? 'Failed to get user profile');
  }

  @override
  Future<UserModel> updateUser(UserParams params) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.updateProfile,
      method: DioMethod.patch,
      data: params.toJson(),
      isFormData: true,
    );
    if (response.success && response.data != null) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.message ?? 'Failed to update user profile');
  }

  @override
  Future<CheckUsernameResponseModel> checkUsername(String username) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.checkUsername,
      method: DioMethod.get,
      query: {'username': username},
    );
    if (response.success && response.data != null) {
      return CheckUsernameResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.message ?? 'Failed to check username');
  }

  @override
  Future<List<UserModel>> getBlockedUsers() async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.blockedUsers,
      method: DioMethod.get,
    );
    if (response.success && response.data != null) {
      return (response.data as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(response.message ?? 'Failed to fetch blocked users');
  }

  @override
  Future<void> toggleBlockUser({required String userId, required bool toggle}) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.blockedUsers,
      method: DioMethod.post,
      data: {'userId': userId, 'toggle': toggle},
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update blocked user');
    }
  }

  @override
  Future<String> reportUser(ReportUserParams params) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.reportUser,
      method: DioMethod.post,
      data: params.toJson(),
    );
    if (response.success) {
      return response.message ?? 'User reported successfully';
    }
    throw Exception(response.message ?? 'Failed to report user');
  }

  @override
  Future<String> deleteAccount(String password) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.deleteAccount,
      method: DioMethod.delete,
      data: {'password': password},
    );
    if (response.success) {
      return response.message ?? 'Account deleted';
    }
    throw Exception(response.message ?? 'Failed to delete account');
  }

  @override
  Future<void> updateNotificationSettings(bool isEnabled) async {
    final response = await _apiService.request(
      endpoint: UserEndpoints.notifications,
      method: DioMethod.patch,
      data: {'notification': isEnabled},
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update notification settings');
    }
  }
}
