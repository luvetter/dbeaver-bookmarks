import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import 'common/provider/theme.dart';
import 'router.dart';

class Shell extends StatefulWidget {
  const Shell({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == const SettingsRoute().location) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(widget.title),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Consumer(
                builder: (context, ref, child) {
                  return ToggleSwitch(
                    content: const Text('Dark Mode'),
                    checked: FluentTheme.of(context).brightness.isDark,
                    onChanged: (v) {
                      ref.read(fluentThemeProvider.notifier).toggle();
                    },
                  );
                },
              ),
            ),
          ),
          if (!kIsWeb) const WindowButtons(),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        items: [
          PaneItem(
            key: Key(const ConnectionsRoute().location),
            icon: const Icon(FluentIcons.home),
            title: const Text('Home'),
            body: const SizedBox.shrink(),
            onTap: () {
              const ConnectionsRoute().go(context);
            },
          ),
          PaneItem(
            key: Key(const SettingsRoute().location),
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const SizedBox.shrink(),
            onTap: () {
              const SettingsRoute().go(context);
            },
          ),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
