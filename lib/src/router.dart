import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'feature/connections/routes.dart' as connections;
import 'feature/settings/routes.dart' as settings;
import 'shell.dart';

export 'feature/connections/routes.dart'
    show ConnectionsRoute, $ConnectionsRouteExtension;
export 'feature/settings/routes.dart'
    show SettingsRoute, $SettingsRouteExtension;

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Shell(title: 'DBeaver Bookmarks', child: child);
      },
      routes: _appRoutes,
    )
  ],
);

final _appRoutes = [
  ...connections.$appRoutes,
  ...settings.$appRoutes,
];
