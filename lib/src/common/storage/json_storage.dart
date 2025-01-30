import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'file_storage.dart';

part 'json_storage.g.dart';

@riverpod
JsonStorage jsonStorage(Ref ref, String subdir) {
  return JsonStorage(ref.watch(fileStorageProvider(subdir)));
}

class JsonStorage {
  final FileStorage _fileStorage;

  JsonStorage(this._fileStorage);

  void write(String name, Object value) {
    var json = jsonEncode(value);
    _fileStorage.write('$name.json', json);
  }

  void remove(String name) {
    _fileStorage.remove('$name.json');
  }

  T read<T>(String name, T Function(Map<String, dynamic>) fromJson) {
    var json = _fileStorage.read('$name.json');
    return fromJson(jsonDecode(json));
  }

  List<T> readAll<T>(T Function(Map<String, dynamic>) fromJson) {
    return _fileStorage.readAll().map((json) {
      return fromJson(jsonDecode(json));
    }).toList();
  }
}
