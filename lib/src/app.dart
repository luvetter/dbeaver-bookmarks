import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes.dart';

part 'app.g.dart';

class DbeaverBookmarks extends ConsumerWidget {
  const DbeaverBookmarks({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FluentApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      theme: ref.watch(fluentThemeProvider),
    );
  }
}

final fluentThemeProvider = fluentThemeNotifierProvider;

@riverpod
class FluentThemeNotifier extends _$FluentThemeNotifier {
  @override
  FluentThemeData build() {
    return FluentThemeData.light();
  }

  void toggle() {
    if (state.brightness == Brightness.light) {
      state = state.copyWith(brightness: Brightness.dark);
    } else {
      state = state.copyWith(brightness: Brightness.light);
    }
  }
}
