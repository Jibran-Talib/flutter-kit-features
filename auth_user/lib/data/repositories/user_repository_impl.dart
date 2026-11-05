import 'package:fpdart/fpdart.dart';
import '../../core/api_service/api_handler.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/check_username_response_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/report_user_params.dart';
import '../../domain/usecases/user_params.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;

  UserRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, UserEntity>> getUser() =>
      executeApiRequest(() async {
        final model = await _remote.getUser();
        return model.toEntity();
      });

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserParams params) =>
      executeApiRequest(() async {
        final model = await _remote.updateUser(params);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, CheckUsernameResponseEntity>> checkUsername(String username) =>
      executeApiRequest(() async {
        final model = await _remote.checkUsername(username);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, List<UserEntity>>> getBlockedUsers() =>
      executeApiRequest(() async {
        final models = await _remote.getBlockedUsers();
        return models.map((e) => e.toEntity()).toList();
      });

  @override
  Future<Either<Failure, void>> toggleBlockUser({
    required String userId,
    required bool toggle,
  }) =>
      executeApiRequest(() => _remote.toggleBlockUser(userId: userId, toggle: toggle));

  @override
  Future<Either<Failure, String>> reportUser(ReportUserParams params) =>
      executeApiRequest(() => _remote.reportUser(params));

  @override
  Future<Either<Failure, String>> deleteAccount(String password) =>
      executeApiRequest(() => _remote.deleteAccount(password));

  @override
  Future<Either<Failure, void>> updateNotificationSettings(bool isEnabled) =>
      executeApiRequest(() => _remote.updateNotificationSettings(isEnabled));
}
