import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'home.dart';

part 'routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(title: 'DBeaver Bookmarks', child: child);
      },
      routes: $appRoutes,
    )
  ],
);

@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const Text('home');
}

@TypedGoRoute<SettingsRoute>(
  path: '/settings',
)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Text('settings');
}
