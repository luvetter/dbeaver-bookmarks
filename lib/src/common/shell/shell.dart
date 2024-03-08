import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import '../../router.dart';
import '../provider/theme.dart';

class Shell extends StatelessWidget {
  const Shell({
    super.key,
    required this.child,
  });

  final Widget child;

  int? _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == const ConnectionsRoute().location) return 0;
    if (location == const SettingsRoute().location) return 1;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: AppTitle(),
        automaticallyImplyLeading: false,
        actions: AppActions(),
      ),
      paneBodyBuilder: (item, child) => FocusTraversalGroup(
        key: ValueKey('body${item?.name}'),
        child: this.child,
      ),
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        items: [
          PaneItem(
            key: Key(const ConnectionsRoute().location),
            icon: const Icon(FluentIcons.home),
            title: const Text('Connections'),
            body: const SizedBox.shrink(),
            onTap: () {
              const ConnectionsRoute().go(context);
            },
          ),
        ],
        footerItems: [
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

class AppActions extends StatelessWidget {
  const AppActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
      ],
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var title = const Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text('DBeaver Bookmarks'),
    );
    if (kIsWeb) return title;
    return DragToMoveArea(
      child: title,
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

extension _PaneItemNameExt on PaneItem {
  String? get name => key is ValueKey ? (key as ValueKey).value : null;
}
