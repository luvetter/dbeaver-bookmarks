import 'package:collection/collection.dart';
import 'package:dbeaver_bookmarks/src/common/storage/json_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../domain/connection.dart';
import '../domain/connection_configuration.dart';

part 'connection_configuration_repository.g.dart';

@riverpod
ConnectionConfigurationRepository connectionConfigurationRepository(Ref ref) {
  return ConnectionConfigurationRepository(
    ref.watch(jsonStorageProvider('connections')),
  );
}

@riverpod
List<ConnectionConfiguration> configurations(Ref ref) {
  return ref.watch(connectionConfigurationRepositoryProvider).findAll();
}

@riverpod
Map<String, List<ConnectionConfiguration>> configurationsByProject(Ref ref) {
  return ref.watch(configurationsProvider).groupListsBy((conf) => conf.project);
}

class ConnectionConfigurationRepository {
  final JsonStorage _jsonStorage;

  ConnectionConfigurationRepository(this._jsonStorage);

  void save(ConnectionConfiguration configuration) {
    _jsonStorage.write(configuration.id, configuration);
  }

  void remove(String id) {
    _jsonStorage.remove(id);
  }

  ConnectionConfiguration findById(String id) {
    return _jsonStorage.read(
        id, (json) => ConnectionConfiguration.fromJson(json));
  }

  List<ConnectionConfiguration> findAll() {
    return [
      ..._jsonStorage.readAll((json) => ConnectionConfiguration.fromJson(json)),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 1',
        name: 'Configuration 1',
        connections: [
          Connection(id: '1', name: 'Connection 1'),
          Connection(id: '2', name: 'Connection 2'),
        ],
      ),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 1',
        name: 'Configuration 2',
        connections: [
          Connection(id: '3', name: 'Connection 3'),
          Connection(id: '4', name: 'Connection 4'),
        ],
      ),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 2',
        name: 'Configuration 3',
        connections: [
          Connection(id: '5', name: 'Connection 5'),
          Connection(id: '6', name: 'Connection 6'),
        ],
      ),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 2',
        name: 'Configuration 4',
        connections: [
          Connection(id: '7', name: 'Connection 7'),
          Connection(id: '8', name: 'Connection 8'),
        ],
      ),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 3',
        name: 'Configuration 5',
        connections: [
          Connection(id: '9', name: 'Connection 9'),
          Connection(id: '10', name: 'Connection 10'),
        ],
      ),
      ConnectionConfiguration(
        id: Uuid().v4(),
        project: 'Project 3',
        name: 'Configuration 6',
        connections: [
          Connection(id: '11', name: 'Connection 11'),
          Connection(id: '12', name: 'Connection 12'),
        ],
      ),
    ];
  }
}
