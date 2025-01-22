import 'dart:io';

import 'package:dbeaver_bookmarks/src/feature/connections/data/project_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/provider/workspace_directory.dart';
import '../domain/workspace.dart';

part 'workspace_repository.g.dart';

@riverpod
WorkspaceRepository workspaceRepository(Ref ref) {
  return WorkspaceRepository(ref.watch(projectRepositoryProvider));
}

@riverpod
Workspace workspace(Ref ref) {
  return ref
      .watch(workspaceRepositoryProvider)
      .getWorkspace(ref.watch(workspaceDirectoryProvider));
}

class WorkspaceRepository {
  final ProjectRepository _projectRepository;

  WorkspaceRepository(this._projectRepository);

  Workspace getWorkspace(Directory workspaceDirectory) {
    return Workspace(
      workspaceDirectory,
      _projectRepository.getProjects(),
    );
  }
}
