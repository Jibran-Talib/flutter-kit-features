// Tailored-specific fields removed: coinBalance, isRealisticUnlocked, isSuggestionOpen, getSuggestions.
// AddressDetails replaced with LocationData (self-contained, no tailored widget dependency).
import 'package:equatable/equatable.dart';
import 'location_data.dart';

class UserEntity extends Equatable {
  final String id;
  final String userName;
  final String fullName;
  final String email;
  final String profilePicture;
  final LocationData? location;
  final bool isSocial;
  final bool isPasswordSet;
  final bool notification;

  const UserEntity({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.profilePicture,
    this.location,
    this.isSocial = false,
    this.isPasswordSet = false,
    this.notification = false,
  });

  factory UserEntity.initial() => const UserEntity(
    id: '',
    userName: '',
    fullName: '',
    email: '',
    profilePicture: '',
  );

  UserEntity copyWith({
    String? id,
    String? userName,
    String? fullName,
    String? email,
    String? profilePicture,
    LocationData? location,
    bool? isSocial,
    bool? isPasswordSet,
    bool? notification,
  }) {
    return UserEntity(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      location: location ?? this.location,
      isSocial: isSocial ?? this.isSocial,
      isPasswordSet: isPasswordSet ?? this.isPasswordSet,
      notification: notification ?? this.notification,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userName': userName,
    'fullName': fullName,
    'email': email,
    'profilePicture': profilePicture,
    'isSocial': isSocial,
    'isPasswordSet': isPasswordSet,
    'notification': notification,
    if (location != null) 'location': {
      'latitude': location!.latitude,
      'longitude': location!.longitude,
      'city': location!.city,
      'state': location!.state,
      'country': location!.country,
      'zipCode': location!.zipCode,
    },
  };

  @override
  List<Object?> get props => [
    id, userName, fullName, email, profilePicture,
    location, isSocial, isPasswordSet, notification,
  ];
}
