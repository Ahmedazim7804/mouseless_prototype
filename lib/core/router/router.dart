import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mouseless/core/router/routes.dart';
import 'package:mouseless/screens/home/home_screen.dart';
import 'package:mouseless/screens/root_scaffold.dart';

final GlobalKey<NavigatorState> _branchesNavigatorKey =
    GlobalKey<NavigatorState>();

GoRouter getRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home.path,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home.path,
                name: AppRoutes.home.name,
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.userApps.path,
                name: AppRoutes.userApps.name,
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stats.path,
                name: AppRoutes.stats.name,
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings.path,
                name: AppRoutes.settings.name,
                builder: (context, state) {
                  return const HomeScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
