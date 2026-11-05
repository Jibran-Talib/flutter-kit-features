import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../../core/usecase/usecase.dart';
import '../entities/check_username_response_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import 'user_params.dart';
import 'report_user_params.dart';

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}

class GetUserUseCase implements UseCase<UserEntity, NoParams> {
  final UserRepository _repository;
  GetUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) =>
      _repository.getUser();
}

class UpdateUserUseCase implements UseCase<UserEntity, UserParams> {
  final UserRepository _repository;
  UpdateUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserParams params) =>
      _repository.updateUser(params);
}

class CheckUsernameUseCase implements UseCase<CheckUsernameResponseEntity, String> {
  final UserRepository _repository;
  CheckUsernameUseCase(this._repository);

  @override
  Future<Either<Failure, CheckUsernameResponseEntity>> call(String username) =>
      _repository.checkUsername(username);
}

class GetBlockedUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository _repository;
  GetBlockedUsersUseCase(this._repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) =>
      _repository.getBlockedUsers();
}

class ToggleBlockUserParams extends Equatable {
  final String userId;
  final bool toggle;
  const ToggleBlockUserParams({required this.userId, required this.toggle});
  @override
  List<Object?> get props => [userId, toggle];
}

class ToggleBlockUserUseCase implements UseCase<void, ToggleBlockUserParams> {
  final UserRepository _repository;
  ToggleBlockUserUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ToggleBlockUserParams params) =>
      _repository.toggleBlockUser(userId: params.userId, toggle: params.toggle);
}

class ReportUserUseCase implements UseCase<String, ReportUserParams> {
  final UserRepository _repository;
  ReportUserUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(ReportUserParams params) =>
      _repository.reportUser(params);
}

class DeleteAccountParams extends Equatable {
  final String password;
  const DeleteAccountParams({required this.password});
  @override
  List<Object?> get props => [password];
}

class DeleteAccountUseCase implements UseCase<String, DeleteAccountParams> {
  final UserRepository _repository;
  DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(DeleteAccountParams params) =>
      _repository.deleteAccount(params.password);
}

class UpdateNotificationSettingsUseCase implements UseCase<void, bool> {
  final UserRepository _repository;
  UpdateNotificationSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(bool isEnabled) =>
      _repository.updateNotificationSettings(isEnabled);
}
