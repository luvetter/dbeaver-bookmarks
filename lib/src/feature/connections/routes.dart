import 'package:dbeaver_bookmarks/src/feature/connections/presentation/connections_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<ConnectionsRoute>(
  path: '/connections',
)
class ConnectionsRoute extends GoRouteData {
  const ConnectionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ConnectionsPage();
}
