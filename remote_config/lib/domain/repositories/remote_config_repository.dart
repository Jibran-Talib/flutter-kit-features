import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entities/remote_config_entity.dart';

abstract class RemoteConfigRepository {
  Future<Either<Failure, RemoteConfigEntity>> fetchAndActivate();
  RemoteConfigEntity getCachedConfig();
}
