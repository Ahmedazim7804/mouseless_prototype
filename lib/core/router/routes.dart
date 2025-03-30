class AppRoute {
  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

class AppRoutes {
  static const AppRoute home = AppRoute(name: 'home', path: '/home');
  static const AppRoute userApps = AppRoute(
    name: 'userApps',
    path: '/user-apps',
  );
  static const AppRoute stats = AppRoute(name: 'stats', path: '/stats');
  static const AppRoute settings = AppRoute(
    name: 'settings',
    path: '/settings',
  );
}
