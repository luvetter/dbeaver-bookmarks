import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor.g.dart';

@riverpod
class CurrentConnectionConfiguration extends _$CurrentConnectionConfiguration {
  @override
  ConnectionConfiguration? build() {
    return null;
  }

  void change(ConnectionConfiguration? configFile) {
    state = configFile;
  }
}

class Editor extends ConsumerWidget {
  const Editor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var configFile = ref.watch(currentConnectionConfigurationProvider);
    return configFile == null
        ? const Center(child: Text('No config file selected'))
        : SingleChildScrollView(
            child: Column(
              children: [
                ...configFile.connections.map(
                  (connection) => ListTile(
                    title: Text(connection.name),
                  ),
                ),
              ],
            ),
          );
  }
}
