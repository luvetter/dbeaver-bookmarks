import 'dart:io';

import 'package:dbeaver_bookmarks/src/feature/connections/data/project_repository.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/workspace_repository.dart';
import '../domain/connection_configuration.dart';
import '../domain/project.dart';
import 'editor.dart';

class ConnectionsPage extends HookConsumerWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _ConfigFileBreadcrumbBar(),
        Expanded(child: _Workspace()),
      ],
    );
  }
}

class _ConfigFileBreadcrumbBar extends ConsumerWidget {
  const _ConfigFileBreadcrumbBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workspace = ref.watch(workspaceProvider);
    var path = workspace.directory.path;

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

class _Workspace extends StatelessWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
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
    var projects = ref.watch(projectsProvider);

    return TreeView(
      items: [
        ...projects.map(_buildTreeViewItem),
      ],
      onItemInvoked: (item, _) {
        if (item.value is ConnectionConfiguration) {
          ref
              .read(currentConnectionConfigurationProvider.notifier)
              .change(item.value);
        }
        return Future.value();
      },
    );
  }

  TreeViewItem _buildTreeViewItem(Project project) {
    return TreeViewItem(
      value: project,
      content: Text(project.name),
      children: [
        ...project.configurations.map(
          (configuration) => TreeViewItem(
            value: configuration,
            content: Text(configuration.name),
          ),
        ),
      ],
    );
  }
}
