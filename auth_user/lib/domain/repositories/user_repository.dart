import 'package:fpdart/fpdart.dart';
import '../../../../auth/lib/domain/entities/auth_entity.dart';
import '../../core/errors/failure.dart';
import '../entities/check_username_response_entity.dart';
import '../entities/user_entity.dart';
import '../usecases/user_params.dart';
import '../usecases/report_user_params.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser();
  Future<Either<Failure, UserEntity>> updateUser(UserParams params);
  Future<Either<Failure, CheckUsernameResponseEntity>> checkUsername(String username);
  Future<Either<Failure, List<UserEntity>>> getBlockedUsers();
  Future<Either<Failure, void>> toggleBlockUser({required String userId, required bool toggle});
  Future<Either<Failure, String>> reportUser(ReportUserParams params);
  Future<Either<Failure, String>> deleteAccount(String password);
  Future<Either<Failure, void>> updateNotificationSettings(bool isEnabled);
}
