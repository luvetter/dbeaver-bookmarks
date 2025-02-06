import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../selected_configuration.dart';

class Editor extends ConsumerWidget {
  const Editor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var configFile = ref.watch(selectedConnectionConfigurationProvider);
    return configFile == null
        ? Center(child: Text(context.loc.noConfigurationSelected))
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
