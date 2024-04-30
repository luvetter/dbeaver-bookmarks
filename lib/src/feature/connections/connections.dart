import 'dart:convert';
import 'dart:io';

import 'package:dbeaver_bookmarks/src/common/provider/workspace.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  const _ConfigFileBreadcrumbBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workspaceDirectory = ref.watch(workspaceProvider);
    var configFile = ref.watch(currentConfigFileProvider);
    var path = configFile?.path ?? workspaceDirectory.path;

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
  const _Workspace({super.key});

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
          child: _ConfigFileEditor(),
        ),
      ],
    );
  }
}

class _ConfigFileEditor extends ConsumerWidget {
  const _ConfigFileEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var configFile = ref.watch(currentConfigFileProvider);
    const jsonEncoder = JsonEncoder.withIndent('  ');
    return configFile == null
        ? const Center(child: Text('No config file selected'))
        : SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                jsonEncoder.convert(json.decode(configFile.content)),
              ),
            ),
          );
  }
}

class _WorkspaceTree extends ConsumerWidget {
  const _WorkspaceTree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var workspaceDirectory = ref.watch(workspaceProvider);

    return TreeView(
      items: [
        ...workspaceDirectory.projects.map(_buildTreeViewItem),
      ],
      onItemInvoked: (item, _) {
        if (item.value is ConfigFile) {
          ref.read(currentConfigFileProvider.notifier).change(item.value);
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
        ...project.configFiles.map(
          (file) => TreeViewItem(
            value: file,
            content: Text(file.path.split(Platform.pathSeparator).last),
          ),
        ),
      ],
    );
  }
}
