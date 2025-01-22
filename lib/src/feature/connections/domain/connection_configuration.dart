import 'connection.dart';

class ConnectionConfiguration {
  final String name;
  final List<Connection> connections;

  ConnectionConfiguration({
    required this.name,
    this.connections = const [],
  });
}
