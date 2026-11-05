import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.isProfileCompleted,
    required super.token,
    required super.user,
    super.isEmailVerified = false,
    super.tempToken = '',
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    final userJson = (data['user'] as Map<String, dynamic>?) ?? {};

    final token =
        data['token'] as String? ??
        data['accessToken'] as String? ??
        data['access_token'] as String? ??
        data['authToken'] as String? ??
        data['auth_token'] as String? ??
        '';

    final tempToken =
        data['resetToken'] as String? ??
        data['reset_token'] as String? ??
        data['tempToken'] as String? ??
        data['temp_token'] as String? ??
        '';

    return AuthModel(
      token: token,
      tempToken: tempToken,
      isProfileCompleted: data['isProfileCompleted'] ?? false,
      isEmailVerified: data['isEmailVerified'] ?? false,
      user: userJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isProfileCompleted': isProfileCompleted,
      'isEmailVerified': isEmailVerified,
      'token': token,
      'tempToken': tempToken,
      'user': user,
    };
  }

  AuthEntity toEntity() {
    return AuthEntity(
      isProfileCompleted: isProfileCompleted,
      token: token,
      user: user,
      isEmailVerified: isEmailVerified,
      tempToken: tempToken,
    );
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      isProfileCompleted: entity.isProfileCompleted,
      token: entity.token,
      user: entity.user,
      isEmailVerified: entity.isEmailVerified,
      tempToken: entity.tempToken,
    );
  }
}
