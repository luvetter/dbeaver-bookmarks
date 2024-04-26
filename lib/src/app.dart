import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/provider/theme.dart';
import 'router.dart';

class DbeaverBookmarks extends ConsumerWidget {
  const DbeaverBookmarks({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FluentApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      themeMode: ref.watch(themeModeProvider),
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
    );
  }
}
