import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace.g.dart';

@Riverpod(keepAlive: true)
class Workspace extends _$Workspace {
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
