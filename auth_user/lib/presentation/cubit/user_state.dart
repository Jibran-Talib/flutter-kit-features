import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum UserStatus { initial, loading, success, failure }

enum UserAction { getProfile, updateProfile, checkUsername, deleteAccount, updateNotification }

class UserState extends Equatable {
  final UserStatus status;
  final UserAction? action;
  final UserEntity? user;
  final String? message;
  final bool? usernameAvailable;

  const UserState({
    this.status = UserStatus.initial,
    this.action,
    this.user,
    this.message,
    this.usernameAvailable,
  });

  bool isLoadingOf(UserAction a) => status == UserStatus.loading && action == a;

  UserState copyWith({
    UserStatus? status,
    UserAction? action,
    UserEntity? user,
    String? message,
    bool? usernameAvailable,
  }) {
    return UserState(
      status: status ?? this.status,
      action: action ?? this.action,
      user: user ?? this.user,
      message: message,
      usernameAvailable: usernameAvailable ?? this.usernameAvailable,
    );
  }

  @override
  List<Object?> get props => [status, action, user, message, usernameAvailable];
}
