import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/remote_config_model.dart';

abstract class RemoteConfigDataSource {
  Future<RemoteConfigModel> fetchAndActivate();
  RemoteConfigModel getCachedConfig();
}

class RemoteConfigDataSourceImpl implements RemoteConfigDataSource {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigDataSourceImpl(this._remoteConfig);

  @override
  Future<RemoteConfigModel> fetchAndActivate() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.fetchAndActivate();
    return _buildModel();
  }

  @override
  RemoteConfigModel getCachedConfig() => _buildModel();

  RemoteConfigModel _buildModel() {
    final allKeys = _remoteConfig.getAll();
    final values = <String, dynamic>{};

    for (final entry in allKeys.entries) {
      final rv = entry.value;
      // Try to parse as most specific type first
      final raw = rv.asString();
      if (raw.toLowerCase() == 'true' || raw.toLowerCase() == 'false') {
        values[entry.key] = rv.asBool();
      } else if (int.tryParse(raw) != null) {
        values[entry.key] = rv.asInt();
      } else if (double.tryParse(raw) != null) {
        values[entry.key] = rv.asDouble();
      } else {
        values[entry.key] = raw;
      }
    }

    return RemoteConfigModel(values: values, fetchedAt: DateTime.now());
  }
}
