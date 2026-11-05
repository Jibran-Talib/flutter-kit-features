import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/remote_config_entity.dart';
import '../../domain/repositories/remote_config_repository.dart';
import 'remote_config_state.dart';

class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  final RemoteConfigRepository _repository;

  RemoteConfigCubit(this._repository)
      : super(RemoteConfigState(config: RemoteConfigEntity.empty()));

  Future<void> fetchConfig() async {
    emit(state.copyWith(status: RemoteConfigStatus.loading));

    final result = await _repository.fetchAndActivate();

    result.fold(
      (failure) => emit(state.copyWith(
        status: RemoteConfigStatus.failure,
        message: failure.message,
      )),
      (config) => emit(state.copyWith(
        status: RemoteConfigStatus.loaded,
        config: config,
      )),
    );
  }

  /// Access config values directly — usage: sl<RemoteConfigCubit>().getString('key')
  String getString(String key, {String defaultValue = ''}) =>
      state.config.getString(key, defaultValue: defaultValue);

  int getInt(String key, {int defaultValue = 0}) =>
      state.config.getInt(key, defaultValue: defaultValue);

  bool getBool(String key, {bool defaultValue = false}) =>
      state.config.getBool(key, defaultValue: defaultValue);
}
