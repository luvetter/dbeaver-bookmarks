import 'dart:async';

import 'package:dbeaver_bookmarks/src/common/provider/theme.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/provider/workspace_directory.dart';

const _spacer = SizedBox(height: 10.0);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const biggerSpacer = SizedBox(height: 40.0);
    return ScaffoldPage.scrollable(
      header: PageHeader(title: Text(context.loc.settings)),
      children: const [
        _AppMode(),
        biggerSpacer,
        _Workspace(),
        biggerSpacer,
      ],
    );
  }
}

class _Workspace extends ConsumerWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentPath = ref.watch(dBeaverWorkspaceDirectoryProvider)?.path;
    return _SettingsTile(
      title: context.loc.workspace,
      children: [
        Text(currentPath ?? context.loc.noWorkspaceSelected),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
          child: Button(
            onPressed: () async {
              final path = await showOpenPanel(context, currentPath);
              if (path != null) {
                ref
                    .read(dBeaverWorkspaceDirectoryProvider.notifier)
                    .change(path);
              }
            },
            child: Text(context.loc.selectWorkspace),
          ),
        ),
      ],
    );
  }

  FutureOr<Uri?> showOpenPanel(
      BuildContext context, String? currentPath) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      initialDirectory: currentPath,
      lockParentWindow: true,
      dialogTitle: context.loc.selectWorkspace,
    );

    if (selectedDirectory == null) {
      return null;
    } else {
      return Uri.directory(selectedDirectory);
    }
  }
}

class _AppMode extends ConsumerWidget {
  const _AppMode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return _SettingsTile(title: context.loc.themeModeTitle, children: [
      ...[ThemeMode.light, ThemeMode.dark, ThemeMode.system].map(
        (mode) => Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8.0),
          child: RadioButton(
            checked: mode == themeMode,
            onChanged: (value) {
              if (value) {
                ref.read(themeModeProvider.notifier).change(mode);
              }
            },
            content: Text(context.loc.themeMode(mode.name)),
          ),
        ),
      ),
    ]);
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsTile({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FluentTheme.of(context).typography.subtitle),
        _spacer,
        ...children,
      ],
    );
  }
}
