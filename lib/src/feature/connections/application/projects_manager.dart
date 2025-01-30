import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/project_repository.dart';
import '../domain/project.dart';

part 'projects_manager.g.dart';

@riverpod
class ProjectsManager extends _$ProjectsManager {
  @override
  List<Project> build() {
    return ref.watch(projectRepositoryProvider).getProjects();
  }

  void createProject(String name) {
    var project = Project(id: Uuid().v4(), name: name);
    ref.read(projectRepositoryProvider).save(project);
    ref.invalidateSelf();
  }

  void removeProject(String id) {
    ref.read(projectRepositoryProvider).remove(id);
    ref.invalidateSelf();
  }
}
