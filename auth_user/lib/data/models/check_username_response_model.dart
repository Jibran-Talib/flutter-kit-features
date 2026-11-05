import '../../domain/entities/check_username_response_entity.dart';

class CheckUsernameResponseModel extends CheckUsernameResponseEntity {
  const CheckUsernameResponseModel({
    required super.isAvailable,
    super.message,
  });

  factory CheckUsernameResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckUsernameResponseModel(
      isAvailable: json['isAvailable'] as bool? ??
          json['available'] as bool? ??
          false,
      message: json['message']?.toString(),
    );
  }

  CheckUsernameResponseEntity toEntity() =>
      CheckUsernameResponseEntity(isAvailable: isAvailable, message: message);
}
