import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/remote_config_entity.dart';
import '../../domain/repositories/remote_config_repository.dart';
import '../datasources/remote_config_datasource.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final RemoteConfigDataSource _dataSource;

  RemoteConfigRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, RemoteConfigEntity>> fetchAndActivate() async {
    try {
      final model = await _dataSource.fetchAndActivate();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  RemoteConfigEntity getCachedConfig() {
    try {
      return _dataSource.getCachedConfig().toEntity();
    } catch (_) {
      return RemoteConfigEntity.empty();
    }
  }
}
