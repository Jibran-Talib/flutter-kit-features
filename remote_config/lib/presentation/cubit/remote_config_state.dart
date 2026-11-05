import 'package:equatable/equatable.dart';
import '../../domain/entities/remote_config_entity.dart';

enum RemoteConfigStatus { initial, loading, loaded, failure }

class RemoteConfigState extends Equatable {
  final RemoteConfigStatus status;
  final RemoteConfigEntity config;
  final String? message;

  RemoteConfigState({
    this.status = RemoteConfigStatus.initial,
    RemoteConfigEntity? config,
    this.message,
  }) : config = config ?? RemoteConfigEntity.empty();

  RemoteConfigState copyWith({
    RemoteConfigStatus? status,
    RemoteConfigEntity? config,
    String? message,
  }) {
    return RemoteConfigState(
      status: status ?? this.status,
      config: config ?? this.config,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, config, message];
}
