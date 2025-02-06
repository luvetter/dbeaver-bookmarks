import 'dart:io';

import 'package:dbeaver_bookmarks/src/common/context_menu.dart';
import 'package:dbeaver_bookmarks/src/common/provider/workspace_directory.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/application/configuration_manager.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/data/connection_configuration_repository.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/presentation/new_configuration_dialog.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/connection_configuration.dart';
import 'editor.dart';

class ConnectionsPage extends HookConsumerWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dbeaverSelected = ref
        .watch(dBeaverWorkspaceDirectoryProvider.select((dir) => dir != null));
    if (!dbeaverSelected) {
      return const Center(
        child: Text('Please select a DBeaver workspace directory.'),
      );
    }
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _ConfigFileBreadcrumbBar(),
        _CommandBar(),
        Expanded(child: _Workspace()),
      ],
    );
  }
}

class _ConfigFileBreadcrumbBar extends ConsumerWidget {
  const _ConfigFileBreadcrumbBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workspace = ref.watch(dBeaverWorkspaceDirectoryProvider)!;
    var path = workspace.path;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: BreadcrumbBar(
        items: [
          ...path.split(Platform.pathSeparator).map(
                (segment) => BreadcrumbItem(
                  label: Text(segment),
                  value: segment,
                ),
              ),
        ],
      ),
    );
  }
}

class _CommandBar extends HookConsumerWidget {
  const _CommandBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommandBar(
      overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
      primaryItems: [
        CommandBarButton(
          icon: Icon(FluentIcons.add),
          label: Text(context.loc.addConfigurationAction),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => NewConfigurationDialog(),
            );
          },
        ),
      ],
    );
  }
}

class _Workspace extends StatelessWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          height: double.infinity,
          child: _WorkspaceTree(),
        ),
        Expanded(
          child: Editor(),
        ),
      ],
    );
  }
}

class _WorkspaceTree extends ConsumerWidget {
  const _WorkspaceTree();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var configurations = ref.watch(configurationsByProjectProvider);

    return ContextMenu(
      items: [
        ContextMenuItem(
          title: context.loc.addConfigurationAction,
          icon: FluentIcons.add,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => NewConfigurationDialog(),
            );
          },
        ),
      ],
      child: TreeView(
        items: [
          ...configurations.entries.map((c) => _buildTreeViewItem(
                c.key,
                c.value,
                context,
                ref,
              )),
        ],
        onItemInvoked: (item, _) {
          if (item.value is ConnectionConfiguration) {
            ref
                .read(currentConnectionConfigurationProvider.notifier)
                .change(item.value);
          }
          return Future.value();
        },
      ),
    );
  }

  TreeViewItem _buildTreeViewItem(
    String projectName,
    List<ConnectionConfiguration> configurations,
    BuildContext context,
    WidgetRef ref,
  ) {
    return TreeViewItem(
      value: projectName,
      content: Text(projectName),
      children: [
        ...configurations.map(
          (configuration) => TreeViewItem(
            value: configuration,
            content: ContextMenu(
              items: [
                ContextMenuItem(
                  title: context.loc.deleteCommand,
                  icon: FluentIcons.delete,
                  onPressed: () => ref
                      .read(configurationManagerProvider.notifier)
                      .removeConfiguration(configuration.id),
                ),
              ],
              child: Text(configuration.name),
            ),
          ),
        ),
      ],
    );
  }
}
