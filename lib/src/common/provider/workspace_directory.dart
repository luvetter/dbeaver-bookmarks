import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_directory.g.dart';

@Riverpod(keepAlive: true)
class WorkspaceDirectory extends _$WorkspaceDirectory {
  @override
  Directory build() {
    var uri = Uri.directory(
      '',
      windows: true,
    );
    return Directory.fromUri(uri);
  }

  void change(Uri path) {
    state = Directory.fromUri(path);
  }
}

@Riverpod(keepAlive: true)
class DBeaverWorkspaceDirectory extends _$DBeaverWorkspaceDirectory {
  @override
  Directory? build() {
    return null;
  }

  void change(Uri path) {
    state = Directory.fromUri(path);
  }
}
