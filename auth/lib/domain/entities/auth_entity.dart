import 'package:equatable/equatable.dart';

// Generic AuthEntity — user is Map<String,dynamic> so it works with any project's user model.
// Tailored-specific fields removed: isAvatarConfirmed, isWalkthroughCompleted, isDetailsCompleted.
// Add project-specific flags by extending this entity.

class AuthEntity extends Equatable {
  final String token;
  final String tempToken;
  final bool isProfileCompleted;
  final bool isEmailVerified;
  final Map<String, dynamic> user;

  const AuthEntity({
    required this.token,
    required this.isProfileCompleted,
    required this.user,
    this.isEmailVerified = false,
    this.tempToken = '',
  });

  AuthEntity copyWith({
    String? token,
    String? tempToken,
    bool? isProfileCompleted,
    bool? isEmailVerified,
    Map<String, dynamic>? user,
  }) {
    return AuthEntity(
      token: token ?? this.token,
      tempToken: tempToken ?? this.tempToken,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [token, user, isProfileCompleted, isEmailVerified, tempToken];
}
