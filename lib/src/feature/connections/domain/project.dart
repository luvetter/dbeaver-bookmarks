import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';

class Project {
  final String name;
  final List<ConnectionConfiguration> configurations;

  Project({
    required this.name,
    this.configurations = const [],
  });
}
