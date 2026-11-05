// Generic remote config entity — projects define their own keys.
// tailored's ConfigEntity fields (realisticAvatarGenerate, avatarGenerate, etc.) removed — those were app-specific.
import 'package:equatable/equatable.dart';

class RemoteConfigEntity extends Equatable {
  final Map<String, dynamic> values;
  final DateTime fetchedAt;

  const RemoteConfigEntity({
    required this.values,
    required this.fetchedAt,
  });

  factory RemoteConfigEntity.empty() => RemoteConfigEntity(
    values: const {},
    fetchedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  // Typed getters — return defaults if key missing
  String getString(String key, {String defaultValue = ''}) =>
      values[key]?.toString() ?? defaultValue;

  int getInt(String key, {int defaultValue = 0}) {
    final v = values[key];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    final v = values[key];
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final v = values[key];
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    return defaultValue;
  }

  RemoteConfigEntity copyWith({Map<String, dynamic>? values, DateTime? fetchedAt}) {
    return RemoteConfigEntity(
      values: values ?? this.values,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  List<Object?> get props => [values, fetchedAt];
}
