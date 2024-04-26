import 'dart:developer' as developer;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'common/provider/theme.dart';
import 'common/provider/workspace.dart';
import 'router.dart';

class DbeaverBookmarks extends HookConsumerWidget {
  const DbeaverBookmarks({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var future = useMemoized(() => _loadDefaultWorkspace(ref));
    if (useFuture(future).connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }

    return FluentApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      themeMode: ref.watch(themeModeProvider),
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
    );
  }

  Future _loadDefaultWorkspace(WidgetRef ref) async {
    return getApplicationSupportDirectory()
        .then((directory) => directory.absolute.path)
        .onError(_logError)
        .then((path) => Uri.directory(path, windows: true))
        .then((uri) => ref.read(workspaceProvider.notifier).change(uri));
  }

  String _logError(Object error, StackTrace stackTrace) {
    developer.log(
      'Konnte den Standardarbeitsbereich nicht laden.',
      error: error,
      stackTrace: stackTrace,
      name: 'DbeaverBookmarks',
    );
    return '';
  }
}
