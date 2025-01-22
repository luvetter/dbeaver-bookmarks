import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/connection.dart';
import '../domain/connection_configuration.dart';
import '../domain/project.dart';

part 'project_repository.g.dart';

@riverpod
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository();
}

@riverpod
List<Project> projects(Ref ref) {
  return ref.watch(projectRepositoryProvider).getProjects();
}

class ProjectRepository {
  ProjectRepository();

  List<Project> getProjects() {
    return [
      Project(
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

// Project _createProject(Directory directory) {
//   var dbBeaverDir = _findDbeaverDir(directory);
//   return Project(directory, [
//     ...?dbBeaverDir
//         ?.listSync()
//         .where(_isFile)
//         .cast<File>()
//         .where(not(_isDefaultProjectFile))
//         .where(_isJson)
//         .map(ConfigFile.new),
//   ]);
// }
//
// List<Directory> _findProjectDirs(Directory directory) {
//   return directory
//       .listSync()
//       .where(_isDirectory)
//       .cast<Directory>()
//       .where(_isProjectDir)
//       .toList();
// }
//
// Directory? _findDbeaverDir(Directory directory) {
//   return directory.listSync().firstWhereOrNull(_isDbeaverDir) as Directory?;
// }
//
// bool _isProjectDir(Directory directory) {
//   return directory.listSync().any(_isDbeaverDir);
// }
//
// bool _isDbeaverDir(FileSystemEntity directory) {
//   return _isDirectory(directory) && directory.path.endsWith('.dbeaver');
// }
//
// bool _isDirectory(FileSystemEntity entity) {
//   return FileSystemEntity.typeSync(entity.path) ==
//       FileSystemEntityType.directory;
// }
//
// bool _isFile(FileSystemEntity entity) {
//   return FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.file;
// }
//
// bool _isJson(File entity) {
//   return entity.path.endsWith('.json');
// }
//
// bool _isDefaultProjectFile(File entity) {
//   return _wellKnownProjectFiles.contains(
//     entity.path.split(Platform.pathSeparator).last,
//   );
// }
