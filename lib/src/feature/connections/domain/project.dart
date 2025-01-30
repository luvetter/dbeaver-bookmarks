import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  factory Project({
    required String id,
    required String name,
    @Default([]) List<ConnectionConfiguration> configurations,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
