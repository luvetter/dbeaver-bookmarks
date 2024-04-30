import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dbeaver_bookmarks/src/common/predicate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace.g.dart';

const _wellKnownProjectFiles = [
  'project-settings.json',
  'project-metadata.json',
  'credentials-config.json',
];

@Riverpod(keepAlive: true)
class Workspace extends _$Workspace {
  @override
  WorkspaceDirectory build() {
    var uri = Uri.directory(
      '',
      windows: true,
    );
    return _createWorkspaceDirectory(Directory.fromUri(uri));
  }

  void change(Uri path) {
    state = _createWorkspaceDirectory(Directory.fromUri(path));
  }
}

@Riverpod(keepAlive: true)
class CurrentConfigFile extends _$CurrentConfigFile {
  @override
  ConfigFile? build() {
    return null;
  }

  void change(ConfigFile? configFile) {
    state = configFile;
  }
}

WorkspaceDirectory _createWorkspaceDirectory(Directory directory) {
  final projectDirs = _findProjectDirs(directory);
  return WorkspaceDirectory(
    directory,
    [...projectDirs.map(_createProject)],
  );
}

Project _createProject(Directory directory) {
  var dbBeaverDir = _findDbeaverDir(directory);
  return Project(directory, [
    ...?dbBeaverDir
        ?.listSync()
        .where(_isFile)
        .cast<File>()
        .where(not(_isDefaultProjectFile))
        .where(_isJson)
        .map(ConfigFile.new),
  ]);
}

List<Directory> _findProjectDirs(Directory directory) {
  return directory
      .listSync()
      .where(_isDirectory)
      .cast<Directory>()
      .where(_isProjectDir)
      .toList();
}

Directory? _findDbeaverDir(Directory directory) {
  return directory.listSync().firstWhereOrNull(_isDbeaverDir) as Directory?;
}

bool _isProjectDir(Directory directory) {
  return directory.listSync().any(_isDbeaverDir);
}

bool _isDbeaverDir(FileSystemEntity directory) {
  return _isDirectory(directory) && directory.path.endsWith('.dbeaver');
}

bool _isDirectory(FileSystemEntity entity) {
  return FileSystemEntity.typeSync(entity.path) ==
      FileSystemEntityType.directory;
}

bool _isFile(FileSystemEntity entity) {
  return FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.file;
}

bool _isJson(File entity) {
  return entity.path.endsWith('.json');
}

bool _isDefaultProjectFile(File entity) {
  return _wellKnownProjectFiles.contains(
    entity.path.split(Platform.pathSeparator).last,
  );
}

class WorkspaceDirectory {
  final Directory _directory;
  final List<Project> projects;

  String get path => _directory.absolute.path;

  WorkspaceDirectory(this._directory, this.projects);
}

class Project {
  final Directory _directory;
  final List<ConfigFile> configFiles;

  String get name => _directory.path.split(Platform.pathSeparator).last;

  String get path => _directory.absolute.path;

  Project(this._directory, this.configFiles);
}

class ConfigFile {
  final File _file;

  String get name => _file.path.split(Platform.pathSeparator).last;

  String get path => _file.absolute.path;

  String get content => _file.readAsStringSync();

  ConfigFile(this._file);
}
