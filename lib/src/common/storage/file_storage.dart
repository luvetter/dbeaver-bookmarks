import 'dart:io';

import 'package:dbeaver_bookmarks/src/common/provider/workspace_directory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_storage.g.dart';

@riverpod
FileStorage fileStorage(Ref ref, String subdir) {
  var appData = ref.watch(workspaceDirectoryProvider);
  var directory = Directory('${appData.path}\\$subdir');
  return FileStorage(directory);
}

class FileStorage {
  final Directory _directory;

  FileStorage(this._directory) {
    _directory.createSync(recursive: true);
  }

  void write(String name, String content) {
    File('${_directory.path}\\$name').writeAsStringSync(content);
  }

  void remove(String name) {
    File('${_directory.path}\\$name').deleteSync();
  }

  String read<T>(String name) {
    var file = File('${_directory.path}\\$name');
    return file.readAsStringSync();
  }

  Iterable<String> readAll<T>([String type = '.json']) {
    return _directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(type))
        .map((file) => file.readAsStringSync());
  }
}
