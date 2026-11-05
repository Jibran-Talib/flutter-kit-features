import 'package:equatable/equatable.dart';

class LocationData extends Equatable {
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  const LocationData({
    this.latitude = 0,
    this.longitude = 0,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  factory LocationData.initial() => const LocationData();

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, city, state, country, zipCode];
}
