import 'package:dbeaver_bookmarks/src/feature/connections/data/connection_configuration_repository.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../domain/connection.dart';

part 'configuration_manager.g.dart';

@riverpod
class ConfigurationManager extends _$ConfigurationManager {
  @override
  Future<void> build() {
    return Future.value();
  }

  void createConfiguration({required String name, required String project}) {
    var configuration = ConnectionConfiguration(
      id: Uuid().v4(),
      name: name,
      project: project,
    );
    ref.read(connectionConfigurationRepositoryProvider).save(configuration);
    ref.invalidate(configurationsProvider);
  }

  void createConnection(String setId, String name) {
    var configuration =
        ref.read(connectionConfigurationRepositoryProvider).findById(setId);
    configuration = configuration.copyWith(
      connections: [
        ...configuration.connections,
        Connection(
          id: Uuid().v4(),
          name: name,
        )
      ],
    );
    ref.read(connectionConfigurationRepositoryProvider).save(configuration);
    ref.invalidate(configurationsProvider);
  }

  void removeConfiguration(String id) {
    ref.read(connectionConfigurationRepositoryProvider).remove(id);
    ref.invalidate(configurationsProvider);
  }
}
