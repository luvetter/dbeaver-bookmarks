import 'package:dbeaver_bookmarks/src/feature/settings/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<SettingsRoute>(
  path: '/settings',
)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
