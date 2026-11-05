import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/session/session_cubit.dart';
import '../../domain/usecases/user_usecases.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUseCase _getUser;
  final UpdateUserUseCase _updateUser;
  final CheckUsernameUseCase _checkUsername;
  final DeleteAccountUseCase _deleteAccount;
  final UpdateNotificationSettingsUseCase _updateNotification;
  final ToggleBlockUserUseCase _toggleBlock;
  final ReportUserUseCase _reportUser;
  final SessionCubit _sessionCubit;

  UserCubit({
    required GetUserUseCase getUser,
    required UpdateUserUseCase updateUser,
    required CheckUsernameUseCase checkUsername,
    required DeleteAccountUseCase deleteAccount,
    required UpdateNotificationSettingsUseCase updateNotification,
    required ToggleBlockUserUseCase toggleBlock,
    required ReportUserUseCase reportUser,
    required SessionCubit sessionCubit,
  })  : _getUser = getUser,
        _updateUser = updateUser,
        _checkUsername = checkUsername,
        _deleteAccount = deleteAccount,
        _updateNotification = updateNotification,
        _toggleBlock = toggleBlock,
        _reportUser = reportUser,
        _sessionCubit = sessionCubit,
        super(const UserState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: UserStatus.loading, action: UserAction.getProfile));

    final result = await _getUser(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, message: failure.message)),
      (user) {
        _sessionCubit.updateUser(user.toMap());
        emit(state.copyWith(status: UserStatus.success, user: user));
      },
    );
  }

  Future<void> updateProfile(UserParams params) async {
    emit(state.copyWith(status: UserStatus.loading, action: UserAction.updateProfile));

    final result = await _updateUser(params);

    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, message: failure.message)),
      (user) {
        _sessionCubit.updateUser(user.toMap());
        emit(state.copyWith(status: UserStatus.success, user: user));
      },
    );
  }

  Future<void> checkUsernameAvailability(String username) async {
    emit(state.copyWith(status: UserStatus.loading, action: UserAction.checkUsername));

    final result = await _checkUsername(username);

    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, message: failure.message)),
      (response) => emit(state.copyWith(
        status: UserStatus.success,
        usernameAvailable: response.isAvailable,
        message: response.message,
      )),
    );
  }

  Future<void> deleteAccount(String password) async {
    emit(state.copyWith(status: UserStatus.loading, action: UserAction.deleteAccount));

    final result = await _deleteAccount(DeleteAccountParams(password: password));

    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, message: failure.message)),
      (message) {
        _sessionCubit.logout();
        emit(state.copyWith(status: UserStatus.success, message: message));
      },
    );
  }

  Future<void> updateNotification(bool isEnabled) async {
    emit(state.copyWith(status: UserStatus.loading, action: UserAction.updateNotification));

    final result = await _updateNotification(isEnabled);

    result.fold(
      (failure) => emit(state.copyWith(status: UserStatus.failure, message: failure.message)),
      (_) {
        final currentUser = state.user;
        if (currentUser != null) {
          final updated = currentUser.copyWith(notification: isEnabled);
          _sessionCubit.updateUser(updated.toMap());
          emit(state.copyWith(status: UserStatus.success, user: updated));
        } else {
          emit(state.copyWith(status: UserStatus.success));
        }
      },
    );
  }

  Future<void> toggleBlock(String userId, bool toggle) async {
    await _toggleBlock(ToggleBlockUserParams(userId: userId, toggle: toggle));
  }

  Future<void> reportUser(ReportUserParams params) async {
    await _reportUser(params);
  }
}
