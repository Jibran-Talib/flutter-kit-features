import '../../domain/entities/remote_config_entity.dart';

class RemoteConfigModel extends RemoteConfigEntity {
  const RemoteConfigModel({
    required super.values,
    required super.fetchedAt,
  });

  RemoteConfigEntity toEntity() =>
      RemoteConfigEntity(values: values, fetchedAt: fetchedAt);
}
