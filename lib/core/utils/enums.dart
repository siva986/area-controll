enum AppRoutes {
  home(path: '/', pathName: "Area"),
  stops(path: '/stop', pathName: "stops");

  final String path;
  final String pathName;
  const AppRoutes({required this.path, required this.pathName});
}

enum DashboardTabs {
  area(route: AppRoutes.home),
  stops(route: AppRoutes.stops);

  final AppRoutes route;
  const DashboardTabs({required this.route});
}

enum StopAlias { left, right, entrance, middle }
