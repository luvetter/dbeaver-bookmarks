import 'package:dbeaver_bookmarks/src/common/storage/json_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../domain/connection.dart';
import '../domain/connection_configuration.dart';
import '../domain/project.dart';

part 'project_repository.g.dart';

@riverpod
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository(ref.watch(jsonStorageProvider('projects')));
}

class ProjectRepository {
  final JsonStorage _jsonStorage;

  ProjectRepository(this._jsonStorage);

  void save(Project project) {
    _jsonStorage.write(project.id, project);
  }

  void remove(String id) {
    _jsonStorage.remove(id);
  }

  List<Project> getProjects() {
    return [
      ..._jsonStorage.readAll((json) => Project.fromJson(json)),
      Project(
        id: Uuid().v4(),
        name: 'Project 1',
        configurations: [
          ConnectionConfiguration(
            name: 'Configuration 1',
            connections: [
              Connection(id: '1', name: 'Connection 1'),
              Connection(id: '2', name: 'Connection 2'),
            ],
          ),
          ConnectionConfiguration(
            name: 'Configuration 2',
            connections: [
              Connection(id: '3', name: 'Connection 3'),
              Connection(id: '4', name: 'Connection 4'),
            ],
          ),
        ],
      ),
      Project(
        id: Uuid().v4(),
        name: 'Project 2',
        configurations: [
          ConnectionConfiguration(
            name: 'Configuration 3',
            connections: [
              Connection(id: '5', name: 'Connection 5'),
              Connection(id: '6', name: 'Connection 6'),
            ],
          ),
          ConnectionConfiguration(
            name: 'Configuration 4',
            connections: [
              Connection(id: '7', name: 'Connection 7'),
              Connection(id: '8', name: 'Connection 8'),
            ],
          ),
        ],
      ),
      Project(
        id: Uuid().v4(),
        name: 'Project 3',
        configurations: [
          ConnectionConfiguration(
            name: 'Configuration 5',
            connections: [
              Connection(id: '9', name: 'Connection 9'),
              Connection(id: '10', name: 'Connection 10'),
            ],
          ),
          ConnectionConfiguration(
            name: 'Configuration 6',
            connections: [
              Connection(id: '11', name: 'Connection 11'),
              Connection(id: '12', name: 'Connection 12'),
            ],
          ),
        ],
      ),
    ];
  }
}
