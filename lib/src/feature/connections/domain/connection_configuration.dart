import 'package:freezed_annotation/freezed_annotation.dart';

import 'connection.dart';

part 'connection_configuration.freezed.dart';
part 'connection_configuration.g.dart';

@freezed
class ConnectionConfiguration with _$ConnectionConfiguration {
  factory ConnectionConfiguration({
    required String id,
    required String name,
    required String project,
    @Default([]) List<Connection> connections,
  }) = _ConnectionConfiguration;

  factory ConnectionConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigurationFromJson(json);
}
