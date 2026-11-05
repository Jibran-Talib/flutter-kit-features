// Tailored-specific fields removed: coinBalance, isRealisticUnlocked, isSuggestionOpen, getSuggestions.
// Flexible field names for maximum API compatibility.
import '../../domain/entities/location_data.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String? id;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? profilePicture;
  final LocationData? location;
  final bool? isSocialLogin;
  final bool? isPasswordSet;
  final bool? notification;

  UserModel({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.profilePicture,
    this.location,
    this.isSocialLogin,
    this.isPasswordSet,
    this.notification,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final normalizedJson =
        (json['user'] as Map<String, dynamic>?) ??
        (json['blockedId'] as Map<String, dynamic>?) ??
        json;

    return UserModel(
      id: normalizedJson['id']?.toString() ?? normalizedJson['_id']?.toString(),
      userName: normalizedJson['username']?.toString() ??
          normalizedJson['userName']?.toString() ??
          normalizedJson['handle']?.toString(),
      fullName: normalizedJson['fullName']?.toString() ??
          normalizedJson['name']?.toString() ??
          normalizedJson['full_name']?.toString(),
      email: normalizedJson['email']?.toString(),
      profilePicture: normalizedJson['profilePicture']?.toString() ??
          normalizedJson['photoURL']?.toString() ??
          normalizedJson['photoUrl']?.toString() ??
          normalizedJson['photo_url']?.toString() ??
          normalizedJson['avatar']?.toString() ??
          normalizedJson['avatarUrl']?.toString() ??
          normalizedJson['picture']?.toString() ??
          normalizedJson['image']?.toString() ??
          normalizedJson['profileImage']?.toString(),
      location: _parseLocation(normalizedJson),
      isSocialLogin:
          normalizedJson['isSocial'] as bool? ??
          normalizedJson['isSocialLogin'] as bool?,
      isPasswordSet: normalizedJson['hasPassword'] as bool? ??
          normalizedJson['isPasswordSet'] as bool?,
      notification: normalizedJson['notification'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': userName,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      if (location != null)
        'location': {'lat': location!.latitude, 'lng': location!.longitude},
      'isSocial': isSocialLogin,
      'hasPassword': isPasswordSet,
      'notification': notification,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      userName: userName ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      profilePicture: profilePicture ?? '',
      location: location ?? LocationData.initial(),
      isSocial: isSocialLogin ?? false,
      isPasswordSet: isPasswordSet ?? false,
      notification: notification ?? false,
    );
  }

  static LocationData _parseLocation(Map<String, dynamic> json) {
    try {
      final location = json['location'];
      final address = json['address'];

      double lat = 0;
      double lng = 0;
      String? city;
      String? state;
      String? country;
      String? zipCode;

      if (location is Map<String, dynamic>) {
        lat = ((location['lat'] ?? location['latitude'] ?? 0) as num).toDouble();
        lng = ((location['lng'] ?? location['longitude'] ?? 0) as num).toDouble();
        city = location['city']?.toString();
        state = location['state']?.toString();
        country = location['country']?.toString();
        zipCode = location['zipCode']?.toString();
      }

      if (address is Map<String, dynamic>) {
        city = address['city']?.toString() ?? city;
        state = address['state']?.toString() ?? state;
        country = address['country']?.toString() ?? country;
        zipCode = address['zipCode']?.toString() ?? zipCode;
      }

      return LocationData(
        latitude: lat,
        longitude: lng,
        city: city,
        state: state,
        country: country,
        zipCode: zipCode,
      );
    } catch (_) {
      return LocationData.initial();
    }
  }
}
