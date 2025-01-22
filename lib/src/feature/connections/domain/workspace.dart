import 'dart:io';

import 'project.dart';

class Workspace {
  final Directory directory;
  final List<Project> projects;

  Workspace(this.directory, this.projects);
}
