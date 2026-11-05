import '../entities/location_data.dart';

class UserParams {
  final String? name;
  final String? username;
  final LocationData? location;
  final String? profilePicturePath;

  UserParams({
    this.name,
    this.username,
    this.location,
    this.profilePicturePath,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (username != null) 'username': username,
      if (location != null)
        'location': {'lat': location!.latitude, 'lng': location!.longitude},
      if (profilePicturePath != null) 'image': profilePicturePath,
    };
  }
}
