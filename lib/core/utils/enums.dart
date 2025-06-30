enum AppRoutes {
  home(path: '/', pathName: "Area"),
  buses(path: '/buses', pathName: "Bus"),
  stops(path: '/stop', pathName: "stops");

  final String path;
  final String pathName;
  const AppRoutes({required this.path, required this.pathName});
}

enum DashboardTabs {
  area(route: AppRoutes.home),
  stops(route: AppRoutes.stops),
  buses(route: AppRoutes.buses);

  final AppRoutes route;
  const DashboardTabs({required this.route});
}

enum StopAlias { left, right, entrance, middle }

enum DayType {
  weekday,
  saturday,
  sunday,
  holiday,
  daily,
}

enum VariantType {
  normal,
  firstBus,
  lastBus,
}

enum BusType {
  bus,
  metro,
  metroBus,
  airportBus;

  static BusType fromName(String name) {
    return BusType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BusType.bus,
    );
  }
}
